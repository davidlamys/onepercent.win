//
//  MainViewController.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var dashboardView: UIView!
    @IBOutlet weak var completedGoalView: UIView!
    @IBOutlet weak var tapToAddGoal: UIButton!
    @IBOutlet weak var noGoalContainerView: UIView!
    @IBOutlet weak var noGoalPrompt: UILabel!
    @IBOutlet weak var noGoalImageView: UIImageView!
    
    var viewModel: MainViewModel!
    
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
        viewModel = MainViewModel(delegate: self)
        dashboardViewController = children.first(where: { $0 is DashboardViewController }) as?  DashboardViewController
        completedGoalViewController = children.first(where: { $0 is CompletedGoalViewController }) as?  CompletedGoalViewController
        dateSelectionViewController = children.first(where: { $0 is DateSelectionViewController }) as? DateSelectionViewController
        dashboardView.isHidden = true
        completedGoalView.isHidden = true

        NotificationCenter.default
            .observeOnMainQueue(for: .themeDidChange) { _ in
                self.applyStyle()
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
        performSegue(withIdentifier: "showGoalEntry", sender: nil)
    }
    
    func applyStyle() {
        
        tapToAddGoal.applyStyle()
        noGoalPrompt.applyFont(fontSize: .medium)
        if UserDefaultsWrapper().getTheme() == .dark {
            noGoalImageView.image = #imageLiteral(resourceName: "no_goal_dark")
        } else {
            noGoalImageView.image = #imageLiteral(resourceName: "no_goal_light")
        }
        noGoalImageView.image = ThemeHelper.getImage(for: .noGoalImage)
        applyBackgroundColor()
        
        dashboardViewController.styleElements()
        dashboardViewController.applyBackgroundColor()
        
        completedGoalViewController.styleElements()
        completedGoalViewController.applyBackgroundColor()
        
        dateSelectionViewController.styleElements()
        dateSelectionViewController.applyBackgroundColor()
        
        navigationController?.navigationBar.barTintColor = ThemeHelper.backgroundColor()
        navigationController?.navigationBar.tintColor = ThemeHelper.defaultOrange()
    }
    
    func setupInitialView() {
        guard let goalForDay = viewModel.todayGoal else {
            dashboardView.isHidden = true
            completedGoalView.isHidden = true
            noGoalContainerView.isHidden = false
            return
        }
        noGoalContainerView.isHidden = true
        
        if goalForDay.completed {
            dashboardView.isHidden = true
            completedGoalView.isHidden = false
            completedGoalViewController.setup(with: goalForDay)
        } else {
            dashboardView.isHidden = false
            completedGoalView.isHidden = true
            dashboardViewController.setup(with: goalForDay)
        }
    }
}

extension MainViewController: MainViewModelDelegate {
    func setup(goal: DailyGoal?) {
        if let goal = goal {
            dashboardViewController.setup(with: goal)
        }
        setupInitialView()
    }
    
}

extension MainViewController: GoalEntryViewControllerDelegate {
    func didSaveGoal() {
        dismiss(animated: true, completion: nil)
    }
}
