//
//  TodayViewController.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit

final class TodayViewController: UIViewController {
    
    @IBOutlet weak var dashboardView: UIView!
    
    var viewModel: TodayViewModel!
    
    @IBAction func didPressUseLast(_ sender: Any) {
        viewModel.repeatLastGoal()
        self.view.endEditing(true)
    }
    
    @IBAction func didPressDone(_ sender: Any) {
        viewModel.toggleGoalCompletion()
    }
    
    weak var dashboardViewController: DashboardViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TodayViewModel(wrapper: RepoWrapper.shared, delegate: self)
        dashboardViewController = self.children.first(where: { $0 is DashboardViewController }) as?  DashboardViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RepoWrapper.shared.delegate = viewModel
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if self.viewModel.todayGoal == nil {
                self.performSegue(withIdentifier: "showGoalEntry", sender: nil)
            } else {
                self.dashboardViewController.setup(with: self.viewModel.todayGoal)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let vc = segue.destination as? GoalEntryViewController else {
            return
        }
        vc.delegate = self
    }
}

extension TodayViewController: TodayViewModelDelegate {
    func setup(todayGoal: DailyGoal?,
               lastGoal: DailyGoal?) {
        if let todayGoal = todayGoal {
            self.dashboardViewController.setup(with: todayGoal)
        }
    }
    
}

extension TodayViewController: GoalEntryViewControllerDelegate {
    func didSaveGoal() {
        self.dismiss(animated: true, completion: nil)
    }
}
