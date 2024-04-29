//
//  PaintingViewController.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 26.04.2024.
//

import UIKit
import Kingfisher

class PaintingViewController: UIViewController {
  
  private let contentView = PaintingView()
  private let viewModel: PaintingViewModel
  
  init(artObject: ArtObject) {
    viewModel = PaintingViewModel(artObject: artObject)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigation()
    setupEmptyStateView()
    
    viewModel.delegate = self
    viewModel.fetchPainting()
  }
  
  private func setupNavigation() {
    title = viewModel.title
  }
  
  private func setupEmptyStateView() {
    contentView.activityIndicator.startAnimating()
    contentView.scrollView.isHidden = true
  }
  
  private func setupDetailsView() {
    contentView.activityIndicator.isHidden = true
    contentView.scrollView.isHidden = false
    
    contentView.titleLabel.text = viewModel.paintingTitle
    contentView.descriptionLabel.text = viewModel.paintingDescription
    
    contentView.imageViewHeightConstraint.constant = contentView.imageView.frame.width / viewModel.imageAspectRatio
    contentView.imageView.kf.setImage(with: viewModel.imageURL)
    
    viewModel.makerTexts.forEach {
      let makerView = MakerView()
      makerView.descriptionlabel.text = $0
      contentView.makersStackView.addArrangedSubview(makerView)
    }
    
    viewModel.colors.forEach {
      let colorView = UIView()
      colorView.backgroundColor = UIColor(hex: $0, alpha: 1.0)
      contentView.colorsStackView.addArrangedSubview(colorView)
    }
  }
}

extension PaintingViewController: PaintingViewModelDelegate {
  func onFetchCompleted() {
    setupDetailsView()
  }
  
  func onFetchFailed(with reason: String) {
    let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    })
    present(alert, animated: true)
  }
}
