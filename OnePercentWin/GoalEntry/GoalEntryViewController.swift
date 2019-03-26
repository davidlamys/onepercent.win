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
    var mode: GoalEntryMode!
    
    var goal: DailyGoal? {
        didSet {
            guard let goal = goal else { return }
            viewModel = GoalEntryViewModel(wrapper: RepoWrapper.shared,
                                           goal: goal,
                                           delegate: self,
                                           mode: mode)
            setupUseLastGoalStackView()
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
        applyBackgroundColor()
        setFonts()
        saveGoalButton.applyStyle()
        goalTextView.becomeFirstResponder()
        
        if let goal = goal {
            setupView(goal: goal)
        } else {
            let createdBy = UserDefaults.standard.string(forKey: "user") ?? "Unknown user"
            mode = .add
            goal = DailyGoal(goal: "",
                             reason: "",
                             date: Date(),
                             createdBy: createdBy,
                             userId: UserService().userId())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RepoWrapper.shared.delegate = viewModel
        setupUseLastGoalStackView()
    }
    
    private func setFonts() {
        goalPrompt.applyFont(fontSize: .medium)
        goalTextView.applyFont(fontSize: .medium)
        reasonPrompt.applyFont(fontSize: .medium)
        reasonTextView.applyFont(fontSize: .medium)
        repeatLastGoalPrompt.applyFont(fontSize: .medium)
    }
    
    private func setup(textView: UITextView) {
        textView.delegate = self
        textView.textColor = ThemeHelper.textColor()
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.tintColor = ThemeHelper.textColor()
        textViewDidChange(textView)
    }
    
    func setupUseLastGoalStackView() {
        guard let goalTextView = goalTextView,
            let reasonTextView = reasonTextView,
            let repeatLastGoalStackView = repeatLastGoalStackView,
            let viewModel = viewModel
        else {
            return
        }
        
        guard viewModel.lastGoal != nil,
            goalTextView.text.isEmpty,
            reasonTextView.text.isEmpty
        else {
            repeatLastGoalStackView.isHidden = true
            return
        }
        
        repeatLastGoalStackView.isHidden = false
        repeatLastGoalSwitch.isOn = false
    }
    
    func setupView(goal: DailyGoal) {
        guard let goalTextView = goalTextView,
            let reasonTextView = reasonTextView else {
                return
        }
            
        goalTextView.text = goal.goal
        reasonTextView.text = goal.reason
        textViewDidChange(goalTextView)
        textViewDidChange(reasonTextView)
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
        setupUseLastGoalStackView()
    }
    
    func updateView(goal: DailyGoal) {
        setupView(goal: goal)
    }
}

