//
//  CompletedGoalViewModel.swift
//  OnePercentWin
//
//  Created by David on 26/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation

fileprivate let goalPromptText = "I wanted to "
fileprivate let reasonPromptText = "Because it was going to help me "

struct CompletedGoalViewModel {
    var goal: DailyGoal!

    var mainLabel: String {
        if goal.isCompleted {
            return "Congratulations!"
        } else {
            return "Oops"
        }
    }
    
    var subtitle: String {
        if goal.isCompleted {
            return "Goal achieved!"
        } else {
            return "Goal failed."
        }
    }
    
    var lessonLearntPrompt: String {
        return goal.isCompleted ? "It made me feel" : "Lession Learn"
    }
    
    var goalPromptAttributedText: NSAttributedString {
        return getAttributedString(prompt: goalPromptText, input: goal?.goal ?? "")
    }
    
    var reasonPromptAttributedText: NSAttributedString {
        return getAttributedString(prompt: reasonPromptText, input: goal?.reason ?? "")
    }
    
    private func getAttributedString(prompt: String, input: String) -> NSAttributedString {
        let font = [NSAttributedString.Key.font: ThemeHelper.defaultFont(fontSize: .medium)]
        let retString = NSMutableAttributedString(string: prompt + input, attributes: font)
        let promptRange = NSMakeRange(0, prompt.count - 1)
        retString.addAttributes([NSAttributedString.Key.foregroundColor: ThemeHelper.textColor()], range: promptRange)
        let inputRange = NSMakeRange(prompt.count, input.count)
        retString.addAttributes([NSAttributedString.Key.foregroundColor: ThemeHelper.defaultOrange()], range: inputRange)
        return retString
    }
}
