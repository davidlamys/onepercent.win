//
//  DailyGoal.swift
//  OnePercentWin
//
//  Created by David on 26/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DailyGoalModelling {
    var completed: Bool { get set }
}

struct DailyGoal: DailyGoalModelling {
    var id: String
    var goal: String
    var reason: String
    var date: Date
    var createdBy: String
    var userId: String
    var notes: String?
    var completed: Bool = false
}

extension DailyGoal {
    init(goal: String,
         reason: String,
         date: Date,
         createdBy: String,
         userId: String) {
        self = DailyGoal(id: UUID.init().uuidString,
                         goal: goal,
                         reason: reason,
                         date: Date(),
                         createdBy: createdBy,
                         userId: userId,
                         notes: nil,
                         completed: false)
    }
}

extension DailyGoal {
    var displayTextGlobal: String {
        let user = createdBy
        return user + " wants to " + goal + " as it's going to help " + user + " " + reason
    }
    
    var displayText: String {
        return "I wants to " + goal + " as it's going to help me " + reason
    }
    
    var prettyDate: String {
        return self.date.prettyDate
    }
}

extension DailyGoal: DocumentSerializable {
    
    var dictionary: [String: Any] {
        return [
            "goal": goal,
            "reason": reason,
            "timestamp": date,
            "createdBy": createdBy,
            "userId": userId,
            "notes": notes,
            "completed": completed
        ]
    }
    
    static var collectionPath: String {
        return "dailyGoals"
    }
    
    init?(dictionary: [String : Any], id: String) {
        guard let goal = dictionary["goal"] as? String,
            let reason = dictionary["reason"] as? String,
            let createdBy = dictionary["createdBy"] as? String,
            let userId = dictionary["userId"] as? String,
            let date = dictionary["timestamp"] as? Timestamp else { return nil }
        
        let notes = dictionary["notes"] as? String
        let completed = dictionary["completed"] as? Bool ?? false
        
        self.init(id: id,
                  goal: goal,
                  reason: reason,
                  date: date.dateValue(),
                  createdBy: createdBy,
                  userId: userId,
                  notes: notes,
                  completed: completed)
    }
}

extension DailyGoal: Equatable {}

extension Optional where Wrapped: DailyGoalModelling {
    var status: GoalStatus {
        guard let goal = self else {
            return .notSet
        }
        return (goal.completed) ? .complete : .incomplete
    }
    
    var colorForStatus: UIColor {
        switch self.status {
        case .complete:
            return HistoryCellModel.completedColor
        case .incomplete:
            return HistoryCellModel.incompleteColor
        case .notSet:
            return HistoryCellModel.noEntryColor
        }
    }
}

enum GoalStatus {
    case notSet
    case incomplete
    case complete
    
    static let completedColor = UIColor.green
    static let incompleteColor = UIColor.yellow
    static let noEntryColor = UIColor.red
}

