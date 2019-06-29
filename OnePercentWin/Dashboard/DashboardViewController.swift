//
//  DashboardViewController.swift
//  OnePercentWin
//
//  Created by David on 21/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

protocol DashboardViewControllerDelegate: class {
    func userDidCompleteGoal()
}

final class DashboardViewController: UIViewController, CheckinViewControllerPresenter {
    @IBOutlet weak var goalPromptLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var reasonPromptLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var editGoalButton: UIButton!
    @IBOutlet weak var completeGoalButton: UIButton!
    
    var goal: DailyGoal!
    weak var delegate: DashboardViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBackgroundColor()
        styleElements()
    }
    
    @IBAction func didPressCompleted(sender: Any) {
        presentCheckinViewController()
    }
    
    @IBAction func didPressit(sender: Any) {
        let sb = UIStoryboard(name: "GoalEntry", bundle: Bundle.main)
        guard let vc = sb.instantiateViewController(withIdentifier: "GoalEntryViewController") as? GoalEntryViewController else {
            fatalError("view controller not found")
        }
        vc.delegate = self
        vc.mode = .update
        vc.goal = goal
        present(vc, animated: true)
    }

    func setup(with newGoal: DailyGoal) {
        goal = newGoal
        goalLabel.text = newGoal.goal
        reasonLabel.text = newGoal.reason
        
        let isGoalCompleted = newGoal.completed
        completeGoalButton.isEnabled = !isGoalCompleted
        completeGoalButton.greyOutIfDisable()
        editGoalButton.isEnabled = !isGoalCompleted
        editGoalButton.greyOutIfDisable()
    }
    
    func styleElements() {
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
    
    func didCancel() {
        dismiss(animated: true)
    }
}

extension DashboardViewController: CheckinViewControllerDelegate {

    func userCancelledCheckin() {
        dismiss(animated: true)
    }

    func userCompletedCheckin() {
        dismiss(animated: true)
    }
}
