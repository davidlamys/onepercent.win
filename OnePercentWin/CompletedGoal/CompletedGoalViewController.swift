//
//  CompletedGoalViewController.swift
//  OnePercentWin
//
//  Created by David on 26/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

final class CompletedGoalViewController: UIViewController {
    @IBOutlet private weak var congratulationsLabel: UILabel!
    @IBOutlet private weak var congrulationsSubtitleLabel: UILabel!
    @IBOutlet private weak var lessonsLearntLabel: UILabel!
    @IBOutlet private weak var lessonsLearntPrompt: UILabel!
    @IBOutlet private weak var imageViewHolder: UIView!
    @IBOutlet private weak var addLessonLearntButton: UIButton!
    @IBOutlet private weak var stackViewHolder: UIStackView!
    
    private var goal: DailyGoal?
    
    @IBAction func didPressAddNotes(sender: Any) {
        guard let goal = goal else { return }
        presentNotesEntryViewController(goal: goal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleElements()
        applyBackgroundColor()
    }
    
    func setup(with goal: DailyGoal) {
        self.goal = goal
        if let notes = goal.notes {
            imageViewHolder.isHidden = true
            lessonsLearntLabel.isHidden = false
            lessonsLearntPrompt.isHidden = false
            lessonsLearntLabel.text = notes
            addLessonLearntButton.setTitle("Edit Notes", for: .normal)
        } else {
            imageViewHolder.isHidden = false
            lessonsLearntLabel.isHidden = true
            lessonsLearntPrompt.isHidden = true
            lessonsLearntLabel.text = nil
            addLessonLearntButton.setTitle("Add Notes", for: .normal)
        }
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
        congrulationsSubtitleLabel.applyFont(fontSize: .medium)
        lessonsLearntPrompt.applyFont(fontSize: .medium)
        lessonsLearntLabel.applyFont(fontSize: .medium, color: ThemeHelper.defaultOrange())
        addLessonLearntButton.applyStyle()
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
