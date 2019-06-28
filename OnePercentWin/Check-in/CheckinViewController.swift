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
}

class CheckinViewController: UIViewController, NotesEntryViewControllerPresenter {
    @IBOutlet weak var successPrompt: UILabel!
    @IBOutlet weak var failedPrompt: UILabel!

    var goal: DailyGoal!
    
    weak var delegate: CheckinViewControllerDelegate?
    
    @IBAction func didPressedFailed(sender: Any) {
        goal.failedWithoutNotes()
        RepoWrapper.shared.save(goal)
        presentNotesEntryViewController()
    }
    
    @IBAction func didPressedCompleted(sender: Any) {
        goal.completedWithoutNotes()
        RepoWrapper.shared.save(goal)
        presentNotesEntryViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBackgroundColor()
        applyStyle()
    }
    
    private func applyStyle() {
        successPrompt.applyFont(fontSize: .medium)
        failedPrompt.applyFont(fontSize: .medium)
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
