//
//  CheckinViewController.swift
//  OnePercentWin
//
//  Created by David_Lam on 27/6/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

protocol CheckinViewControllerPresenter: class {
    var goal: DailyGoal! { get }
    func presentCheckinViewController()
}

protocol CheckinViewControllerDelegate: class {
    func userCompletedCheckin()
    func userCancelledCheckin()
}

class CheckinViewController: UIViewController, NotesEntryViewControllerPresenter {

    @IBOutlet weak var checkinPrompt: UILabel!
    @IBOutlet weak var successPrompt: UILabel!
    @IBOutlet weak var failedPrompt: UILabel!
    @IBOutlet weak var cancelButton: UIButton!

    var goal: DailyGoal!
    
    weak var delegate: CheckinViewControllerDelegate?
    
    @IBAction func didPressFailed(sender: Any) {
        goal.failedWithoutNotes()
        RepoWrapper.shared.save(goal)
        presentNotesEntryViewController()
    }
    
    @IBAction func didPressCompleted(sender: Any) {
        goal.completedWithoutNotes()
        RepoWrapper.shared.save(goal)
        presentNotesEntryViewController()
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        delegate?.userCancelledCheckin()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applyBackgroundColor()
        applyStyle()
        checkinPrompt.text = "How did it go?"
    }
    
    private func applyStyle() {
        checkinPrompt.applyFont(fontSize: .large)
        successPrompt.applyFont(fontSize: .medium)
        failedPrompt.applyFont(fontSize: .medium)
        cancelButton.applyStyle()
    }
}

extension CheckinViewController: NotesEntryViewControllerDelegate {
    func userDidAbortNoteTaking() {
        delegate?.userCompletedCheckin()
    }
    
    func userDidSaveNotes() {
        delegate?.userCompletedCheckin()
    }
}

extension CheckinViewControllerPresenter where Self: CheckinViewControllerDelegate & UIViewController {
    func presentCheckinViewController() {
        let sb = UIStoryboard(name: "CheckinViewController", bundle: Bundle.main)
        guard let vc = sb.instantiateViewController(withIdentifier: "CheckinViewController") as? CheckinViewController else {
            fatalError("view controller not found")
        }
        vc.delegate = self
        vc.goal = goal
        present(vc, animated: true)
    }
}
