//
//  DateSelectionViewController.swift
//  OnePercentWin
//
//  Created by David on 2/3/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

fileprivate let collectionViewInset: CGFloat = 10.0

final class DateSelectionViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var presenter: DateSelectionPresenterProtocol? {
        didSet {
            presenter?.setupPresenter()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
    }
    
    func styleElements() {
        collectionView.backgroundColor = ThemeHelper.backgroundColor()
        reloadCollectionView()
    }
    
    fileprivate func needsCentering() -> Bool {
        let cellsToPresent = presenter?.numberOfCellsToPresent() ?? 1
        let cellWidth = view.frame.height + 10.0 // minimum line spacing
        let numCellsInCollectionView = view.frame.width / cellWidth
        return cellsToPresent > Int(numCellsInCollectionView)
    }
    
    fileprivate func optimalScrollPosition() -> UICollectionView.ScrollPosition {
        return needsCentering() ? .centeredHorizontally : []
    }
}

extension DateSelectionViewController: DateSelectionViewProtocol {
    func reloadCollectionView() {
        collectionView.reloadDataThenPerform { [weak collectionView, weak self] in
            guard let presenter = self?.presenter else {
                return
            }
            let scrollPosition = self?.optimalScrollPosition() ?? []
            let needAnimation = scrollPosition != []
            collectionView?.selectItem(at: presenter.selectedIndexPath,
                                      animated: needAnimation,
                                      scrollPosition: scrollPosition)
        }
    }
}

extension DateSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scrollPosition = optimalScrollPosition()
        let needAnimation = scrollPosition != []
        collectionView.selectItem(at: indexPath,
                                  animated: needAnimation,
                                  scrollPosition: scrollPosition)
        presenter?.didSelectCell(at: indexPath)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfCellsToPresent() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let presenter = presenter else {
            return UICollectionViewCell()
        }
        let cellModel = presenter.cellModelFor(indexPath: indexPath)
        let cellIdentifier: String!
        switch cellModel.goalStatus {
        case .completeWithNotes:
            cellIdentifier = "CompleteWithNotesCell"
        case .complete:
            cellIdentifier = "CompleteCell"
        case .incomplete:
            cellIdentifier = "IncompleteCell"
        case .notSet:
            cellIdentifier = "NoEntryCell"
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? DateSelectionCell else {
            fatalError("misconfigured collection view")
        }
        cell.cellModel = cellModel
        return cell
    }
    
}

extension DateSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.height - 10.0
        let width = height
        return CGSize(width: width, height: height)
    }
}
