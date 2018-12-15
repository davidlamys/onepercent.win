//
//  HistoryViewController.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var goals = [DailyGoal]() {
        didSet {
            visibleGoals = self.getVisibleGoals(goals: goals,
                                                showAll: showAll,
                                                userName: userName)
        }
    }
    
    private var viewModel: HistoryViewModel!
    private var showAll: Bool = false {
        didSet {
            visibleGoals = self.getVisibleGoals(goals: goals,
                                                showAll: showAll,
                                                userName: userName)
        }
    }
    
    private var visibleGoals = [DailyGoal]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var userName: String {
        return UserDefaults.standard.string(forKey: "user") ?? ""
    }
    
    @IBAction func showAllToggled(_ sender: Any) {
        guard let showAllSwitch = sender as? UISwitch else {
            return
        }
        self.showAll = showAllSwitch.isOn
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HistoryViewModel(delegate: self)
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RepoWrapper.shared.delegate = viewModel
    }
    
    private func getVisibleGoals(goals: [DailyGoal],
                                 showAll: Bool,
                                 userName: String) -> [DailyGoal] {
        if showAll {
            return goals
        }
        return goals.filter { $0.createdBy.lowercased() == userName.lowercased() }
    }
}

extension HistoryViewController: HistoryViewModelDelegate {
    func setup(goals: [DailyGoal]) {
        self.goals = goals
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let goalForCell = visibleGoals[indexPath.row]
        cell.textLabel?.text = showAll ? goalForCell.displayTextGlobal : goalForCell.displayText
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = goalForCell.prettyDate
        if goalForCell.completed ?? false {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}
