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
    @IBOutlet weak var completedGoalView: UIView!

    var viewModel: TodayViewModel!
    
    weak var dashboardViewController: DashboardViewController!
    weak var completedGoalViewController: CompletedGoalViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TodayViewModel(wrapper: RepoWrapper.shared, delegate: self)
        dashboardViewController = self.children.first(where: { $0 is DashboardViewController }) as?  DashboardViewController
        
        completedGoalViewController = self.children.first(where: { $0 is CompletedGoalViewController }) as?  CompletedGoalViewController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RepoWrapper.shared.delegate = viewModel
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.setupInitialView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let vc = segue.destination as? GoalEntryViewController else {
            return
        }
        vc.delegate = self
    }
    
    func setupInitialView() {
        if let todayGoal = self.viewModel.todayGoal {
            if todayGoal.completed == true {
                dashboardView.isHidden = true
                completedGoalView.isHidden = false
                self.completedGoalViewController.setup(with: todayGoal)
            } else {
                dashboardView.isHidden = false
                completedGoalView.isHidden = true
                self.dashboardViewController.setup(with: todayGoal)
            }
        } else {
            self.performSegue(withIdentifier: "showGoalEntry", sender: nil)
        }
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
