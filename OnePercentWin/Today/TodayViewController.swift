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
    @IBOutlet weak var tapToAddGoal: UIButton!
    @IBOutlet weak var noGoalContainerView: UIView!
    
    var viewModel: TodayViewModel!
    
    weak var dashboardViewController: DashboardViewController!
    weak var completedGoalViewController: CompletedGoalViewController!
    weak var dateSelectionViewController: DateSelectionViewController! {
        didSet {
            let builder = DateSelectionBuilder()
            builder.build(view: dateSelectionViewController,
                          presenterOutputConsumer: viewModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TodayViewModel(delegate: self)
        dashboardViewController = self.children.first(where: { $0 is DashboardViewController }) as?  DashboardViewController
        completedGoalViewController = self.children.first(where: { $0 is CompletedGoalViewController }) as?  CompletedGoalViewController
        dateSelectionViewController = self.children.first(where: { $0 is DateSelectionViewController }) as? DateSelectionViewController
        dashboardView.isHidden = true
        completedGoalView.isHidden = true
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "themeDidChange"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                self.applyStyle()
            }
        }
        applyStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func userTappedOnAddButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showGoalEntry", sender: nil)
    }
    
    func applyStyle() {
        self.dashboardViewController.styleElements()
        self.dashboardViewController.applyBackgroundColor()
        
        self.tapToAddGoal.applyStyle()
        self.applyBackgroundColor()
        
        self.completedGoalViewController.styleElements()
        self.completedGoalViewController.applyBackgroundColor()
    }
    
    func setupInitialView() {
        if let todayGoal = self.viewModel.todayGoal {
            if todayGoal.completed == true {
                dashboardView.isHidden = true
                completedGoalView.isHidden = false
                noGoalContainerView.isHidden = true
                self.completedGoalViewController.setup(with: todayGoal)
            } else {
                dashboardView.isHidden = false
                completedGoalView.isHidden = true
                noGoalContainerView.isHidden = true
                self.dashboardViewController.setup(with: todayGoal)
            }
        } else {
            dashboardView.isHidden = true
            completedGoalView.isHidden = true
            noGoalContainerView.isHidden = false
        }
    }
}

extension TodayViewController: TodayViewModelDelegate {
    func setup(todayGoal: DailyGoal?) {
        if let todayGoal = todayGoal {
            self.dashboardViewController.setup(with: todayGoal)
        }
        setupInitialView()
    }
    
}

extension TodayViewController: GoalEntryViewControllerDelegate {
    func didSaveGoal() {
        self.dismiss(animated: true, completion: nil)
    }
}
