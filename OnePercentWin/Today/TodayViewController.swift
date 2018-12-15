//
//  TodayViewController.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit

final class TodayViewController: UIViewController {
    
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var viewModel: TodayViewModel!
    
    @IBAction func didPressSave(_ sender: Any) {
        viewModel.addGoal(goal: goalTextField.text ?? "", reason: reasonTextField.text ?? "")
        self.view.endEditing(true)
    }
    
    @IBAction func didPressDone(_ sender: Any) {
        viewModel.toggleGoalCompletion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTextField.delegate = self
        reasonTextField.delegate = self
        viewModel = TodayViewModel(wrapper: RepoWrapper.shared, delegate: self)
        doneButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goalTextField.text = ""
        reasonTextField.text = ""
        RepoWrapper.shared.delegate = viewModel
    }
}

extension TodayViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let hasReason = !(reasonTextField.text?.isEmpty ?? true)
        let hasGoal = !(goalTextField.text?.isEmpty ?? true)
        doneButton.isEnabled = hasReason && hasGoal
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let hasReason = !(reasonTextField.text?.isEmpty ?? true)
        let hasGoal = !(goalTextField.text?.isEmpty ?? true)
        doneButton.isEnabled = hasReason && hasGoal
    }
}

extension TodayViewController: TodayViewModelDelegate {
    func setup(goal: DailyGoal) {
        doneButton.isEnabled = true
        self.goalTextField.text = goal.goal
        self.reasonTextField.text = goal.reason
        if goal.completed ?? false {
            saveButton.isEnabled = false
            doneButton.setTitle("Mark incomplete", for: .normal)
            countdownLabel.text = "Congratulations"
        } else {
            saveButton.isEnabled = true
            doneButton.setTitle("Mark complete", for: .normal)
            countdownLabel.text = "Go after it!!!"
        }
    }
}
