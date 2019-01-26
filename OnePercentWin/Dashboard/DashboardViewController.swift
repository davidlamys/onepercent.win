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
    
    @IBAction func didPressEdit(sender: Any) {
        let sb = UIStoryboard(name: "GoalEntry", bundle: Bundle.main)
        guard let vc = sb.instantiateViewController(withIdentifier: "GoalEntryViewController") as? GoalEntryViewController else {
            fatalError("view controller not found")
            return
        }
        vc.delegate = self
        vc.mode = .update
        vc.goal = self.goal
        self.present(vc, animated: true)
    }

    func setup(with goal: DailyGoal) {
        self.goal = goal
        self.goalLabel.text = goal.goal
        self.reasonLabel.text = goal.reason
        
        let isGoalCompleted = goal.completed
        completeGoalButton.isEnabled = !isGoalCompleted
        completeGoalButton.greyOutIfDisable()
        editGoalButton.isEnabled = !isGoalCompleted
        editGoalButton.greyOutIfDisable()
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

extension DashboardViewController: GoalEntryViewControllerDelegate {
    func didSaveGoal() {
        dismiss(animated: true)
        // TodayViewModel will propogate the new goal to this dashboard view controller for now.
    }
}
