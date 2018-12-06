//
//  HistoryViewModel.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation

struct HistoryViewModel {
    weak var delegate: HistoryViewModelDelegate?

    private let wrapper: RepoWrapper!
    init(delegate: HistoryViewModelDelegate) {
        self.delegate = delegate
        wrapper = RepoWrapper.shared
        wrapper.delegate = self
    }
}

extension HistoryViewModel: RepoWrapperDelegate {
    func refreshWith(goals: [DailyGoal]) {
        delegate?.setup(goals: goals.sorted(by: {
            $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970
        }))
    }
}

protocol HistoryViewModelDelegate: class {
    func setup(goals: [DailyGoal])
}
