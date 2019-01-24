//
//  DashboardViewController.swift
//  OnePercentWin
//
//  Created by David on 21/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

final class DashboardViewController: UIViewController {
    @IBOutlet weak var goalPromptLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var reasonPromptLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var editGoalButton: UIButton!
    @IBOutlet weak var completeGoalButton: UIButton!
    
    var goal: DailyGoal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
    }
    
    @IBAction func didPressedCompleted(sender: Any) {
        goal.completed = true
        RepoWrapper.shared.save(goal)
    }

    func setup(with goal: DailyGoal) {
        self.goal = goal
        self.goalLabel.text = goal.goal
        self.reasonLabel.text = goal.reason
        
        let isGoalCompleted = goal.completed
        completeGoalButton.isEnabled = !isGoalCompleted
        completeGoalButton.alpha = isGoalCompleted ? 0.5 : 1
        editGoalButton.isEnabled = !isGoalCompleted
        editGoalButton.alpha = isGoalCompleted ? 0.5 : 1
    }
    
    private func applyStyle() {
        editGoalButton.applyStyle()
        completeGoalButton.applyStyle()
        goalPromptLabel.applyFont(fontSize: .medium)
        goalLabel.applyFont(fontSize: .medium, color: ThemeHelper.defaultOrange())
        reasonPromptLabel.applyFont(fontSize: .medium)
        reasonLabel.applyFont(fontSize: .medium, color: ThemeHelper.defaultOrange())
    }
    
}

