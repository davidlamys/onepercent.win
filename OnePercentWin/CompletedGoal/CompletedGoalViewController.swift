//
//  CompletedGoalViewController.swift
//  OnePercentWin
//
//  Created by David on 26/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

fileprivate let goalPromptText = "I wanted to "
fileprivate let reasonPromptText = "Because it was going to help me "

final class CompletedGoalViewController: UIViewController, NotesEntryViewControllerPresenter {
    @IBOutlet private weak var congratulationsLabel: UILabel!
    @IBOutlet private weak var congrulationsSubtitleLabel: UILabel!
    @IBOutlet private weak var goalPrompt: UILabel!
    @IBOutlet private weak var reasonPrompt: UILabel!
    @IBOutlet private weak var lessonsLearntPrompt: UILabel!
    @IBOutlet private weak var lessonsLearntLabel: UILabel!
    @IBOutlet private weak var imageViewHolder: UIView!
    @IBOutlet private weak var addLessonLearntButton: UIButton!
    @IBOutlet private weak var stackViewHolder: UIStackView!
    
    var goal: DailyGoal!
    
    @IBAction func didPressAddNotes(sender: Any) {
        presentNotesEntryViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleElements()
        applyBackgroundColor()
    }
    
    func setup(with goal: DailyGoal) {
        self.goal = goal
        
        if let notes = goal.notes {
            lessonsLearntLabel.isHidden = false
            lessonsLearntPrompt.isHidden = false
            lessonsLearntLabel.text = notes
            addLessonLearntButton.setTitle("Edit Notes", for: .normal)
        } else {
            lessonsLearntLabel.isHidden = true
            lessonsLearntPrompt.isHidden = true
            lessonsLearntLabel.text = nil
            addLessonLearntButton.setTitle("Add Notes", for: .normal)
        }
        goalPrompt.attributedText = getAttributedString(prompt: goalPromptText, input: goal.goal)
        
        reasonPrompt.attributedText = getAttributedString(prompt: reasonPromptText, input: goal.reason)
    }
    
    private func presentNotesEntryViewController(goal: DailyGoal) {
        let sb = UIStoryboard(name: "NotesEntry", bundle: Bundle.main)
        guard let vc = sb.instantiateViewController(withIdentifier: "NotesEntryViewController") as? NotesEntryViewController else {
            fatalError("view controller not found")
        }
        vc.delegate = self
        vc.goal = goal
        present(vc, animated: true)
    }
    
    func styleElements() {
        congratulationsLabel.applyBoldFont(fontSize: .large)
        congrulationsSubtitleLabel.applyFont(fontSize: .large)
        
        let orange = ThemeHelper.defaultOrange()
        
        goalPrompt.attributedText = getAttributedString(prompt: goalPromptText, input: goal?.goal ?? "")
        
        reasonPrompt.attributedText = getAttributedString(prompt: reasonPromptText, input: goal?.reason ?? "")
        lessonsLearntPrompt.applyFont(fontSize: .medium)
        lessonsLearntLabel.applyFont(fontSize: .medium, color: orange)
        addLessonLearntButton.applyStyle()
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

extension CompletedGoalViewController: NotesEntryViewControllerDelegate {
    func userDidAbortNoteTaking() {
        dismiss(animated: true)
    }
    
    func userDidSaveNotes() {
        dismiss(animated: true)
    }
}
