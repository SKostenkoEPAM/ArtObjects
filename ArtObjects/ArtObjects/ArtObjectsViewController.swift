//
//  ArtObjectsViewController.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

import UIKit

class ArtObjectsViewController: UIViewController, UICollectionViewDelegate {
  
  typealias ArtObjectsDataSource = UICollectionViewDiffableDataSource<ArtObjectsSection, ArtObject>
  typealias ArtObjectsSnapshot = NSDiffableDataSourceSnapshot<ArtObjectsSection, ArtObject>
  
  private lazy var dataSource: ArtObjectsDataSource = {
    let dataSource = ArtObjectsDataSource(collectionView: contentView.collectionView) { collectionView, indexPath, artObject in
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ArtObjectCell.reuseIdentifier,
        for: indexPath) as? ArtObjectCell
      cell?.artObject = artObject
      return cell
    }
    
    dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
      guard let self else { return nil }
      switch kind {
      case UICollectionView.elementKindSectionHeader:
        let section = self.dataSource.snapshot()
          .sectionIdentifiers[indexPath.section]
        let view = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: ArtObjectsSectionHeaderView.reuseIdentifier,
          for: indexPath) as? ArtObjectsSectionHeaderView
        view?.titleLabel.text = section.title
        return view
      default:
        let view = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: ArtObjectsFooterView.reuseIdentifier,
          for: indexPath) as? ArtObjectsFooterView
        return view
      }
    }
    
    return dataSource
  }()
  
  private let contentView = ArtObjectsView()
  private let viewModel = ArtObjectsViewModel()
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigation()
    setupCollectionView()
    
    viewModel.delegate = self
    viewModel.fetchArtObjects()
    contentView.activityIndicator.startAnimating()
  }
}

private extension ArtObjectsViewController {
  func setupNavigation() {
    title = viewModel.title
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func setupCollectionView() {
    contentView.collectionView.delegate = self
    registerCellsAndViews()
    configureLayout()
  }
  
  func registerCellsAndViews() {
    contentView.collectionView.register(
      ArtObjectsSectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: ArtObjectsSectionHeaderView.reuseIdentifier
    )
    contentView.collectionView.register(
      ArtObjectsFooterView.self,
      forSupplementaryViewOfKind: "layout-footer-element-kind",
      withReuseIdentifier: ArtObjectsFooterView.reuseIdentifier
    )
    contentView.collectionView.register(
      ArtObjectCell.self,
      forCellWithReuseIdentifier: ArtObjectCell.reuseIdentifier
    )
  }
  
  func applySnapshot(animatingDifferences: Bool = false) {
    var snapshot = ArtObjectsSnapshot()
    let sections = viewModel.sections
    snapshot.appendSections(sections)
    sections.forEach { section in
      snapshot.appendItems(section.artObjects, toSection: section)
    }
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
  
  func configureLayout() {
    let config = UICollectionViewCompositionalLayoutConfiguration()
    let loadingFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(30)
    )
    
    let layoutFooter = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: loadingFooterSize,
      elementKind: "layout-footer-element-kind",
      alignment: .bottom
    )
    
    config.boundarySupplementaryItems = [layoutFooter]
    
    let layout = UICollectionViewCompositionalLayout(
      sectionProvider: { (_, _) in
        let size = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(350)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16
        
        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .estimated(20)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
      },
      configuration: config
    )
    
    contentView.collectionView.collectionViewLayout = layout
  }
  
  func showErrorAlert(with reason: String) {
    let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

extension ArtObjectsViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    if offsetY > scrollView.contentSize.height - scrollView.frame.size.height {
      viewModel.fetchArtObjects()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    navigationController?.pushViewController(PaintingViewController(), animated: true)
  }
}

extension ArtObjectsViewController: ArtObjectsViewModelDelegate {
  func onFetchCompleted() {
    contentView.activityIndicator.stopAnimating()
    contentView.activityIndicator.isHidden = true
    applySnapshot()
  }
  
  func onFetchFailed(with reason: String) {
    contentView.activityIndicator.stopAnimating()
    contentView.activityIndicator.isHidden = true
    showErrorAlert(with: reason)
  }
}
