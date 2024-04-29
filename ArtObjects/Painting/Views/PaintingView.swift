//
//  PaintingView.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 26.04.2024.
//

import UIKit
import Kingfisher

private extension PaintingView {
  enum LayoutConsts {
    static let imageViewHeight: CGFloat = 30
    static let colorsViewHeight: CGFloat = 36
    static let colorsSpacing: CGFloat = 8
    static let defaultInsets = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
  }
}

class PaintingView: UIView {
  private(set) lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.alwaysBounceVertical = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  let activityIndicator = UIActivityIndicatorView()
  
  private let contentView: UIView = {
    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    return contentView
  }()
  
  private(set) lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.kf.indicatorType = .activity
    imageView.backgroundColor = .lightGray
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  private(set) var imageViewHeightConstraint: NSLayoutConstraint!
  
  private(set) lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(
      ofSize: UIFont.preferredFont(
        forTextStyle: .title1).pointSize,
      weight: .bold
    )
    label.textColor = .label
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private(set) lazy var makersStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.spacing = LayoutConsts.defaultInsets.left
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private(set) lazy var colorsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    stackView.spacing = LayoutConsts.colorsSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private(set) lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    backgroundColor = .systemBackground
    addSubview(scrollView)
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
    
    scrollView.addSubview(contentView)
    let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
    contentViewHeightConstraint.priority = .defaultLow
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentViewHeightConstraint
    ])
    
    contentView.addSubview(imageView)
    imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: LayoutConsts.imageViewHeight)
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageViewHeightConstraint
    ])
    
    contentView.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LayoutConsts.defaultInsets.top),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConsts.defaultInsets.left),
      titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
    
    contentView.addSubview(makersStackView)
    NSLayoutConstraint.activate([
      makersStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConsts.defaultInsets.top),
      makersStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConsts.defaultInsets.left),
      makersStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
    
    contentView.addSubview(colorsStackView)
    NSLayoutConstraint.activate([
      colorsStackView.topAnchor.constraint(equalTo: makersStackView.bottomAnchor, constant: LayoutConsts.defaultInsets.top),
      colorsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConsts.defaultInsets.left),
      colorsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      colorsStackView.heightAnchor.constraint(equalToConstant: LayoutConsts.colorsViewHeight)
    ])
    
    contentView.addSubview(descriptionLabel)
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: colorsStackView.bottomAnchor, constant: LayoutConsts.defaultInsets.top),
      descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConsts.defaultInsets.left),
      descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -LayoutConsts.defaultInsets.bottom)
    ])
    
    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
