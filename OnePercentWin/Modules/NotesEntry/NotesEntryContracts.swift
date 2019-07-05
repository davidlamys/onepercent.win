//
//  NotesEntryContracts.swift
//  OnePercentWin
//
//  Created by David_Lam on 28/6/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

protocol NotesEntryViewControllerPresenter: class {
    var goal: DailyGoal! { get }
    func presentNotesEntryViewController()
}

protocol NotesEntryViewControllerDelegate: class {
    func userDidAbortNoteTaking()
    func userDidSaveNotes()
}

extension NotesEntryViewControllerPresenter where Self: NotesEntryViewControllerDelegate & UIViewController {
    func presentNotesEntryViewController() {
        let sb = UIStoryboard(name: "NotesEntry", bundle: Bundle.main)
        guard let vc = sb.instantiateViewController(withIdentifier: "NotesEntryViewController") as? NotesEntryViewController else {
            fatalError("view controller not found")
        }
        vc.delegate = self
        vc.goal = goal
        present(vc, animated: true)
    }
}
