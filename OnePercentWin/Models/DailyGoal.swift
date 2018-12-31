//
//  DailyGoal.swift
//  OnePercentWin
//
//  Created by David on 26/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct DailyGoal {
    var id: String
    var goal: String
    var reason: String
    var date: Date
    var createdBy: String
    var userId: String
    var completed: Bool?
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
            "completed": completed ?? false
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
        
        let completed = dictionary["completed"] as? Bool ?? false
        self.init(id: id,
                  goal: goal,
                  reason: reason,
                  date: date.dateValue(),
                  createdBy: createdBy,
                  userId: userId,
                  completed: completed)
    }
}

extension DailyGoal: Equatable {}
