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
    private var cellModels: [HistoryCellModel] = []
    
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
        guard let viewModel = viewModel else {
            return
        }
        cellModels = viewModel.generateCellModels()
        self.tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.shouldShowAllGoals {
            return viewModel.visibleGoals.count
        }
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if viewModel.shouldShowAllGoals {
            let goalForCell = viewModel.visibleGoals[indexPath.row]
            
            cell.backgroundColor = UIColor.white
            cell.textLabel?.text = goalForCell.displayTextGlobal
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = goalForCell.prettyDate
            
            let isCompleted = goalForCell.completed ?? false
            cell.accessoryType = isCompleted ? .checkmark : .none
            
            return cell
        } else {
            let cellModelForCell = cellModels[indexPath.row]
            cell.backgroundColor = cellModelForCell.colorForStatus
            cell.textLabel?.text = cellModelForCell.dateLabel
            cell.detailTextLabel?.text = cellModelForCell.textLabel
            cell.accessoryType = .none
            return cell
        }
    }
}
