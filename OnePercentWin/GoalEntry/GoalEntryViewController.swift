//
//  GoalEntryViewController.swift
//  OnePercentWin
//
//  Created by David on 12/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

protocol GoalEntryViewControllerDelegate: class {
    func didSaveGoal()
}

final class GoalEntryViewController: UIViewController {
    
    @IBOutlet weak var goalPrompt: UILabel!
    @IBOutlet weak var reasonPrompt: UILabel!
    @IBOutlet weak var difficultyPrompt: UILabel!
    @IBOutlet weak var repeatLastGoalPrompt: UILabel!
    @IBOutlet weak var repeatLastGoalStackView: UIStackView!
    @IBOutlet weak var repeatLastGoalSwitch: UISwitch!
    
    @IBOutlet weak var goalTextView: UITextViewFixed! {
        didSet { setup(textView: goalTextView) }
    }
    @IBOutlet weak var reasonTextView: UITextViewFixed! {
        didSet { setup(textView: reasonTextView) }
    }

    @IBOutlet weak var saveGoalButton: UIButton!
    @IBOutlet weak var goalTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reasonTextFieldHeightConstraint: NSLayoutConstraint!
    
    private(set) var viewModel: GoalEntryViewModel!
    
    var goal: DailyGoal? {
        didSet {
            guard let goal = goal else { return }
            self.viewModel = GoalEntryViewModel(wrapper: RepoWrapper.shared,
                                                goal: goal,
                                                delegate: self)
        }
    }
    
    @IBAction func repeatLastGoalToggled(_ sender: Any) {
        viewModel.updateWithLastGoal()
        setupUseLastGoalStackView()
    }
    @IBAction func saveButtonPressed(sender: Any) {
        guard let goal = goalTextView.text, let reason = reasonTextView.text else {
                return
        }
        viewModel.updateGoal(goal: goal, reason: reason)
        delegate?.didSaveGoal()
    }
    
    weak var delegate: GoalEntryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFonts()
        saveGoalButton.backgroundColor = ThemeHelper.defaultOrange()
        saveGoalButton.setTitleColor(.black, for: .normal)
        saveGoalButton.layer.cornerRadius = 5.0
        saveGoalButton.clipsToBounds = true
        goalTextView.becomeFirstResponder()
        if self.goal == nil {
            let createdBy = UserDefaults.standard.string(forKey: "user") ?? "Putu"

            self.goal = DailyGoal(id: UUID.init().uuidString,
                                  goal: "",
                                  reason: "",
                                  date: Date(),
                                  createdBy: createdBy,
                                  userId: UserService().userId(),
                                  completed: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUseLastGoalStackView()
    }
    
    private func setFonts() {
        goalPrompt.font = ThemeHelper.defaultFont(fontSize: .medium)
        goalTextView.font = ThemeHelper.defaultFont(fontSize: .medium)
        reasonPrompt.font = ThemeHelper.defaultFont(fontSize: .medium)
        reasonTextView.font = ThemeHelper.defaultFont(fontSize: .medium)
        repeatLastGoalPrompt.font = ThemeHelper.defaultFont(fontSize: .medium)
    }
    
    private func setup(textView: UITextView) {
        textView.delegate = self
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.tintColor = .white
        textViewDidChange(textView)
    }
    
    func setupUseLastGoalStackView() {
        guard let goalTextView = self.goalTextView,
            let reasonTextView = self.reasonTextView,
            let repeatLastGoalStackView = self.repeatLastGoalStackView
            else {
                return
        }
        let hasGoal = (goalTextView.text != "")
        let hasReason = (reasonTextView.text != "")
        repeatLastGoalStackView.isHidden = (hasGoal || hasReason)
        repeatLastGoalSwitch.isOn = false
    }
    
    func setupView(goal: DailyGoal) {
        goalTextView.text = goal.goal
        reasonTextView.text = goal.reason
    }
}

extension GoalEntryViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width:  textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if textView == goalTextView {
            goalTextFieldHeightConstraint.constant = estimatedSize.height
        } else if textView == reasonTextView {
            reasonTextFieldHeightConstraint.constant = estimatedSize.height
        }
        textView.layoutSubviews()
        setupUseLastGoalStackView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            if textView == goalTextView {
                reasonTextView.becomeFirstResponder()
            }
            return false
        }
        return true
    }
}

extension GoalEntryViewController: GoalEntryViewModelDelegate {
    func refreshView(hasLastGoal: Bool) {
        repeatLastGoalStackView.isHidden = !hasLastGoal
    }
    
    func updateView(goal: DailyGoal) {
        setupView(goal: goal)
    }
}

