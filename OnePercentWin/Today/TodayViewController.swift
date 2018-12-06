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
    
    var viewModel: TodayViewModel!
    
    @IBAction func didPressDone(_ sender: Any) {
        viewModel.addGoal(goal: goalTextField.text ?? "", reason: reasonTextField.text ?? "")
        goalTextField.text = ""
        reasonTextField.text = ""
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTextField.delegate = self
        reasonTextField.delegate = self
        viewModel = TodayViewModel(wrapper: RepoWrapper.shared, delegate: self)
        doneButton.isEnabled = false
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
        self.goalTextField.text = goal.goal
        self.reasonTextField.text = goal.reason
    }
}
