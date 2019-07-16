//
//  CompletedGoalViewController.swift
//  OnePercentWin
//
//  Created by David on 26/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

final class CompletedGoalViewController: UIViewController, NotesEntryViewControllerPresenter {
    @IBOutlet private weak var congratulationsLabel: UILabel!
    @IBOutlet private weak var congrulationsSubtitleLabel: UILabel!
    @IBOutlet private weak var goalPrompt: UILabel!
    @IBOutlet private weak var reasonPrompt: UILabel!
    @IBOutlet private weak var lessonsLearntPrompt: UILabel!

    @IBOutlet private weak var lessonsLearntTextView: UITextView!
    @IBOutlet private weak var imageViewHolder: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var addLessonLearntButton: UIButton!
    @IBOutlet private weak var stackViewHolder: UIStackView!
    
    var goal: DailyGoal! {
        didSet {
            if viewModel == nil {
                viewModel = CompletedGoalViewModel(goal: goal)
            }
            viewModel.goal = goal
        }
    }
    var viewModel: CompletedGoalViewModel!
    
    @IBAction func didPressAddNotes(sender: Any) {
        presentNotesEntryViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CompletedGoalViewModel(goal: goal)
        styleElements()
        applyBackgroundColor()
    }
    
    func setup(with goal: DailyGoal) {
        self.goal = goal
        
        if let notes = goal.notes {
            lessonsLearntTextView.isHidden = false
            lessonsLearntPrompt.isHidden = false
            lessonsLearntTextView.text = notes
            addLessonLearntButton.setTitle("Edit Notes", for: .normal)
        } else {
            lessonsLearntTextView.isHidden = true
            lessonsLearntPrompt.isHidden = true
            lessonsLearntTextView.text = nil
            addLessonLearntButton.setTitle("Add Notes", for: .normal)
        }
        congratulationsLabel.text = viewModel.mainLabel
        congrulationsSubtitleLabel.text = viewModel.subtitle
        lessonsLearntPrompt.text = viewModel.lessonLearntPrompt
        
        goalPrompt.attributedText = viewModel.goalPromptAttributedText
        reasonPrompt.attributedText = viewModel.reasonPromptAttributedText
        imageViewHolder.isHidden = !viewModel.goal.isCompleted
    }
    
    func styleElements() {
        congratulationsLabel.applyBoldFont(fontSize: .large)
        congrulationsSubtitleLabel.applyFont(fontSize: .large)
        
        let orange = ThemeHelper.defaultOrange()
        
        goalPrompt.attributedText = viewModel.goalPromptAttributedText
        reasonPrompt.attributedText = viewModel.reasonPromptAttributedText
        
        lessonsLearntPrompt.applyFont(fontSize: .medium)
        lessonsLearntTextView.applyFont(fontSize: .medium, color: orange)
        lessonsLearntTextView.backgroundColor = ThemeHelper.backgroundColor()
        addLessonLearntButton.applyStyle()
        imageView.setImage(.goalCompletedDashboardImage)
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
