//
//  DateSelectionContract.swift
//  OnePercentWin
//
//  Created by David on 2/3/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation
import UIKit

///-----------------------------------------------------------------------------
/// VIP FRAMEWORK PROTOCOL CONTRACT ******
//  This contract defines and explains the public protocols for the VIP module to work with your code. Protocols define the neccessary behavior for any class to conform to in order for the module to function correctly. Please make sure to reference default implementations to further understand what is happening in the background
///-----------------------------------------------------------------------------

//** Use Case
//*
//*
protocol DateSelectionUseCase: class {
    func selectDate()
}

//*** View
/// The video protocol defines the interface requirements for a view that supports video playback.
protocol DateSelectionViewProtocol: class {
    var presenter: DateSelectionPresenterProtocol? { get set }
    
    //These methods
    // PRESENTER -> VIEW
    func reloadCollectionView()
    //VIEW -> PRESENTER
}

//*** Builder
//*
//*
public protocol DateSelectionBuilderProtocol: class {
    
}

//*** Presenter
//*
//*
protocol DateSelectionPresenterProtocol: class {
    
    var dateView: DateSelectionViewProtocol? { get set }
    var interactor: DateSelectionInteractorProtocol? { get set }
    var outputConsumer: DateSelectionPresenterOutputConsumer? { get set }
    
    // VIEW -> PRESENTER
    func cellModelFor(indexPath: IndexPath) -> DateSelectionCellModelling
    func setupPresenter()
    func numberOfCellsToPresent() -> Int
    func didSelectCell(at indexPath: IndexPath)
    
}

protocol DateSelectionPresenterOutputConsumer: class {
    func didSelect(date: Date, goal: DailyGoal?)
}

//*** Interactor
//*
//*
protocol DateSelectionInteractorProtocol: class  {
    
    var presenter: DateSelectionInteractorOutputConsumer? { get set }

    // PRESENTER -> INTERACTOR
    func fetchAllUserGoals()
}

protocol DateSelectionInteractorOutputConsumer: class {
    //INTERACTOR --> PRESENTER
    func didFinishFetching(goals: [DailyGoal])
}

protocol DateSelectionCellModelling {
    var dayString: String { get }
    var dateString: String { get }
    var monthString: String { get }
    var colorForAccessory: UIColor { get }
    var goalStatus: GoalStatus { get }
}
