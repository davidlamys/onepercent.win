//
//  UserGoalsServiceWrapper.swift
//  OnePercentWin
//
//  Created by David on 3/3/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Firebase
import FirebaseFirestore
import Foundation

class UserGoalQueryListener {
    fileprivate var query: Query?
    private var listener: ListenerRegistration?
    private var goals: [DailyGoal] = []
    private var documents: [DocumentSnapshot] = []
    private let db: Firestore
    
    static let shared = UserGoalQueryListener()
    private var userId: String!
    
    private init() {
        guard let app = FirebaseApp.app() else {
            fatalError()
        }
        db = Firestore.firestore(app: app)
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        observeQuery()
    }
    
    var delegate: RepoWrapperDelegate? {
        didSet {
            observeQuery()
            delegate?.refreshWith(goals: self.goals)
        }
    }
    
    func set(userId: String) {
        self.userId = userId
        goals = goals.filter({ $0.userId == userId })
        query = baseQuery(userId: userId)
        observeQuery()
    }
    
    fileprivate func baseQuery(userId: String) -> Query {
        return db.collection("dailyGoals")
            .order(by: "timestamp", descending: true)
            .limit(to: 365)
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    fileprivate func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.compactMap { (document) -> DailyGoal? in
                if let model = DailyGoal(dictionary: document.data(), id: document.documentID) {
                    return model
                } else {
                    print("Unable to initialize type \(DailyGoal.self) with dictionary \(document.data())")
                    return nil
                }
            }
            if let userId = self.userId {
                self.goals = models.filter { $0.userId == userId }
            } else {
                self.goals = []
            }
            
            self.documents = snapshot.documents
            self.delegate?.refreshWith(goals: self.goals)
        }
    }
    
}
