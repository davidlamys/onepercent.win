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
    private var viewModel: HistoryViewModel!
    
    @IBAction func showAllToggled(_ sender: Any) {
        guard let showAllSwitch = sender as? UISwitch else {
            return
        }
        viewModel.shouldShowAllGoals = showAllSwitch.isOn
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HistoryViewModel(delegate: self,
                                     userService: UserService())
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RepoWrapper.shared.delegate = viewModel
    }
}

extension HistoryViewController: HistoryViewModelDelegate {
    func refreshView() {
        self.tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.visibleGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let goalForCell = viewModel.visibleGoals[indexPath.row]
        cell.textLabel?.text = viewModel.shouldShowAllGoals ? goalForCell.displayTextGlobal : goalForCell.displayText
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
