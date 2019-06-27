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
    var hasNotes: Bool { get }
    var completed: Bool { get set }
    var status: GoalStatus { get }
}

struct DailyGoal {
    var id: String
    var goal: String
    var reason: String
    var date: Date
    var createdBy: String
    var userId: String
    var notes: String?
    var completed: Bool = false
    var status: GoalStatus
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
                         date: date,
                         createdBy: createdBy,
                         userId: userId,
                         notes: nil,
                         completed: false,
                         status: .inProgress)
    }
}

extension DailyGoal {
    var displayTextGlobal: String {
        let user = createdBy
        return user + ": I wants to " + goal + " as it's going to help me" + reason
    }
    
    var displayText: String {
        return "I wants to " + goal + " as it's going to help me " + reason
    }
    
    var prettyDate: String {
        return date.prettyDate
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
            "notes": notes as Any,
            "completed": completed,
            "status": status.rawValue
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
        
        let statusString = dictionary["status"] as? String
        let status = GoalStatus.createFrom(rawValue: statusString, notes: notes)
        
        self.init(id: id,
                  goal: goal,
                  reason: reason,
                  date: date.dateValue(),
                  createdBy: createdBy,
                  userId: userId,
                  notes: notes,
                  completed: completed,
                  status: status)
    }
}

extension DailyGoal: Equatable {}

extension DailyGoal: DailyGoalModelling {
    var hasNotes: Bool {
        guard let notes = notes else {
            return false
        }
        return !notes.isEmpty
    }
    
}

extension Optional where Wrapped == DailyGoal {
    var status: GoalStatus {
        guard let goal = self else {
            return .notSet
        }
        return goal.status
    }
    
    var colorForStatus: UIColor {
        switch status {
        case .completedWithNotes:
            return completedWithNotesColor
        case .completed:
            return completedColor
        case .failed:
            return failedColor
        case .inProgress:
            return inprogressColor
        case .notSet:
            return noEntryColor
        }
    }
}

enum GoalStatus: String {
    case notSet
    case inProgress
    case failed
    case completed
    case completedWithNotes
    
    static func createFrom(rawValue: String?,
                           notes: String?) -> GoalStatus {
        guard let rawValue = rawValue else {
            return .inProgress
        }
        
        guard rawValue == completed.rawValue else {
            return GoalStatus.init(rawValue: rawValue) ?? .inProgress
        }
        
        return (notes == nil) ? .completed : .completedWithNotes
        
    }
}

fileprivate let completedWithNotesColor = UIColor.green
fileprivate let completedColor = UIColor.yellow
fileprivate let failedColor = UIColor.yellow
fileprivate let inprogressColor = UIColor.orange
fileprivate let noEntryColor = UIColor.red
