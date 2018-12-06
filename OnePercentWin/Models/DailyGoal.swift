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
    var goal: String
    var reason: String
    var date: Date
    var createdBy: String
    
    var dictionary: [String: Any] {
        return [
            "goal": goal,
            "reason": reason,
            "timestamp": date,
            "createdBy": createdBy
        ]
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yy"
        return dateFormatter.string(from: self.date)
    }
}

extension DailyGoal: DocumentSerializable {
    static var collectionPath: String {
        return "dailyGoals"
    }
    
    init?(dictionary: [String : Any]) {
        guard let goal = dictionary["goal"] as? String,
            let reason = dictionary["reason"] as? String,
            let createdBy = dictionary["createdBy"] as? String,
            let date = dictionary["timestamp"] as? Timestamp else { return nil }
        
        self.init(goal: goal,
                  reason: reason,
                  date: date.dateValue(),
                  createdBy: createdBy)
    }
}
