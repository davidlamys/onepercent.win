//
//  CompletedGoalViewController.swift
//  OnePercentWin
//
//  Created by David on 26/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

final class CompletedGoalViewController: UIViewController {
    @IBOutlet weak var congratulationsLabel: UILabel!
    @IBOutlet weak var congrulationsSubtitleLabel: UILabel!
    @IBOutlet weak var lessonsLearntLabel: UILabel!
    @IBOutlet weak var lessonsLearntPrompt: UILabel!
    @IBOutlet weak var imageViewHolder: UIView!
    @IBOutlet weak var addLessonLearntButton: UIButton!
    @IBOutlet weak var stackViewHolder: UIStackView!
    
    var goal: DailyGoal?
    
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
            return
        }
        vc.delegate = self
        vc.goal = goal
        self.present(vc, animated: true)
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
