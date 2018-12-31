//
//  HistoryViewController.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit
import JTAppleCalendar

final class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: JTAppleCalendarView!

    private var viewModel: HistoryViewModel!
    private var cellModels: [HistoryCellModel] = []
    private let formatter = DateFormatter()
    
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
        calendar.calendarDataSource = self
        calendar.calendarDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RepoWrapper.shared.delegate = viewModel
    }
}

extension HistoryViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = cellModels.last?.date ?? Date()
        let endDate = cellModels.first?.date ?? Date()
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        return parameters
    }
    
}

extension HistoryViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard cellState.dateBelongsTo == .thisMonth else {
            let emptyCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "EmptyCell", for: indexPath)
            return emptyCell
        }
        print(indexPath)
        
        guard
            let cellModel = cellModels
            .filter({ $0.date.startOfDay == date.startOfDay })
            .first
        else {
            let emptyCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "EmptyCell", for: indexPath)
            return emptyCell
        }
        
        switch cellModel.status {
        case .complete:
            let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CompleteGoalCell", for: indexPath) as! CompleteGoalCell
            cell.dateLabel.text = cellState.text
            return cell
        case .incomplete:
            let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "IncompleteGoalCell", for: indexPath) as! IncompleteGoalCell
            cell.dateLabel.text = cellState.text
            return cell
        case .notSet:
            let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "NoEntryCell", for: indexPath) as! NoEntryCell
            cell.dateLabel.text = cellState.text
            return cell
        }
    }
}

extension HistoryViewController: HistoryViewModelDelegate {
    func refreshView() {
        guard let viewModel = viewModel else {
            return
        }
        cellModels = viewModel.generateCellModels()
        self.tableView.reloadData()
        self.calendar.reloadData()
        self.calendar.scrollToDate(Date())
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
        cell.backgroundColor = .white
        if viewModel.shouldShowAllGoals {
            let goalForCell = viewModel.visibleGoals[indexPath.row]
            cell.textLabel?.text = goalForCell.displayTextGlobal
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = goalForCell.prettyDate
            
            let isCompleted = goalForCell.completed ?? false
            cell.accessoryType = isCompleted ? .checkmark : .none
            
            return cell
        } else {
            let cellModelForCell = cellModels[indexPath.row]
            cell.textLabel?.text = cellModelForCell.dateLabel
            cell.detailTextLabel?.text = cellModelForCell.textLabel
            switch cellModelForCell.status {
            case .complete:
                cell.accessoryType = .checkmark
            case .incomplete:
                cell.accessoryType = .none
            case .notSet:
                cell.accessoryType = .none
                cell.backgroundColor = cellModelForCell.colorForStatus
            }
            return cell
        }
    }
}
