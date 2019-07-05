//
//  DateSelectionBuilder.swift
//  OnePercentWin
//
//  Created by David on 2/3/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation

class DateSelectionBuilder: DateSelectionBuilderProtocol {
    func build(view: DateSelectionViewProtocol,
               presenterOutputConsumer: DateSelectionPresenterOutputConsumer) {
        let presenter = DateSelectionPresenter()
        presenter.dateView = view
        presenter.outputConsumer = presenterOutputConsumer
        let interactor = DateSelectionInteractor()
        presenter.interactor = interactor
        interactor.presenter = presenter
        view.presenter = presenter
    }
}
