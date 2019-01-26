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
    
    func save(notes: String?) {
        if notes == "" {
            self.goal.notes = nil
        } else {
            self.goal.notes = notes
        }
        RepoWrapper.shared.save(goal)
    }
}
