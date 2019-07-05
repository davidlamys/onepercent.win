//
//  NotesEntryViewModel.swift
//  OnePercentWin
//
//  Created by David on 24/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation

class NotesEntryViewModel {
    var goal: DailyGoal!
    
    var mainLabel: String {
        if goal.isCompleted {
            return "Congratulations!"
        } else {
            return "Oops :("
        }
    }
    
    var subtitle: String {
        if goal.isCompleted {
            return "Looks like you crushed it!"
        } else {
            return "You failed your goal"
        }
    }
    
    var lessonLearntPrompt: String {
        return goal.isCompleted ? "How does that make you feel?" : "Lesson Learn"
    }
    
    func save(notes: String?) {
        goal.addNotes(notes)
        RepoWrapper.shared.save(goal)
    }
    
}
