//
//  NotesEntryViewController.swift
//  OnePercentWin
//
//  Created by David on 24/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit


final class NotesEntryViewController: UIViewController {
    @IBOutlet weak var congratulationsLabel: UILabel!
    @IBOutlet weak var congratulationsSubtitle: UILabel!
    @IBOutlet weak var lessonLearntPrompt: UILabel!
    @IBOutlet weak var lessonLearntTextBox: UITextView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var goal: DailyGoal! {
        didSet {
            viewModel = NotesEntryViewModel()
            viewModel.goal = goal
        }
    }
    
    var viewModel: NotesEntryViewModel!
    weak var delegate: NotesEntryViewControllerDelegate?
    
    @IBAction func didPressSkip(sender: Any) {
        delegate?.userDidAbortNoteTaking()
    }
    
    @IBAction func didPressSave(sender: Any) {
        let textTrimmed = lessonLearntTextBox.text.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.save(notes: textTrimmed)
        delegate?.userDidSaveNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBackgroundColor()
        applyStyle()
        
        congratulationsLabel.text = viewModel.mainLabel
        congratulationsSubtitle.text = viewModel.subtitle
        lessonLearntPrompt.text = viewModel.lessonLearntPrompt
        
        lessonLearntTextBox.delegate = self
        lessonLearntTextBox.text = self.goal?.notes
    }
    
    private func applyStyle() {
        congratulationsLabel.applyBoldFont(fontSize: .large)
        congratulationsSubtitle.applyFont(fontSize: .medium)
        lessonLearntPrompt.applyFont(fontSize: .medium)
        lessonLearntTextBox.applyFont(fontSize: .medium)
        skipButton.applyStyle()
        saveButton.applyStyle()
        lessonLearntTextBox.textColor = .white
        lessonLearntTextBox.tintColor = .white
    }
}

extension NotesEntryViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
