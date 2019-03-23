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
    var selectedIndex = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.contentInset = UIEdgeInsets(top: 0.0,
                                                   left: collectionViewInset,
                                                   bottom: 0.0,
                                                   right: collectionViewInset)
        
        NotificationCenter.default.observeOnMainQueue(for: .userDidChange) { _ in
            self.selectedIndex = IndexPath(item: 0, section: 0)
        }
    }
    
    func styleElements() {
        collectionView.reloadData()
        collectionView.selectItem(at: selectedIndex,
                                  animated: false,
                                  scrollPosition: .centeredHorizontally)
        collectionView.backgroundColor = ThemeHelper.backgroundColor()
    }
    
}

extension DateSelectionViewController: DateSelectionViewProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
        collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .centeredHorizontally)
        presenter?.didSelectCell(at: selectedIndex)
    }
}

extension DateSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        collectionView.selectItem(at: selectedIndex,
                                  animated: true,
                                  scrollPosition: .centeredHorizontally)
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
        case .complete:
            cellIdentifier = "CompleteGoalDateCell"
        case .incomplete:
            cellIdentifier = "IncompleteGoalDateCell"
        case .notSet:
            cellIdentifier = "NoEntryDateCell"
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
        let height = self.view.frame.height - 10.0
        let width = height
        return CGSize(width: width, height: height)
    }
}
