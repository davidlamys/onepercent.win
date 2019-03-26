//
//  RepoWrapper.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Firebase
import FirebaseFirestore
import Foundation

class RepoWrapper {
    
    fileprivate var query: Query?
    private var listener: ListenerRegistration?
    private var goals: [DailyGoal] = []
    private var documents: [DocumentSnapshot] = []
    private let db: Firestore
    
    var delegate: RepoWrapperDelegate? {
        didSet {
            observeQuery()
            delegate?.refreshWith(goals: goals)
        }
    }
    
    static let shared = RepoWrapper()

    private init() {
        guard let app = FirebaseApp.app() else {
            fatalError()
        }
        db = Firestore.firestore(app: app)
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        query = baseQuery()
        observeQuery()
    }
    
    func save<T: DocumentSerializable>(_ document: T) {
        let collection = db.collection(T.collectionPath)
        collection.document(document.id).updateData(document.dictionary)
    }
    
    func add<T: DocumentSerializable>(_ document: T) {
        let collection = db.collection(T.collectionPath)
        collection.addDocument(data: document.dictionary)
    }
    
    fileprivate func baseQuery() -> Query {
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

            self.goals = models
            self.documents = snapshot.documents
            self.delegate?.refreshWith(goals: self.goals)
        }
    }
}

protocol RepoWrapperDelegate {
    func refreshWith(goals: [DailyGoal])
}
