//
//  ArtObjectCell.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

import UIKit
import Kingfisher

private extension ArtObjectCell {
  enum LayoutConsts {
    static let cornerRadius: CGFloat = 16
    static let imageViewHeight: CGFloat = 100
    static let defaultInsets = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
  }
}

class ArtObjectCell: UICollectionViewCell {
  
  static var reuseIdentifier: String {
    return String(describing: ArtObjectCell.self)
  }
  
  private(set) lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.kf.indicatorType = .activity
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var descriptionStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.alignment = .leading
    return stackView
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(
      ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize,
      weight: .bold)
    label.textColor = .label
    label.numberOfLines = 0
    return label
  }()
  
  lazy var authorLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.numberOfLines = 0
    return label
  }()
  
  var artObject: ArtObject? {
    didSet {
      imageView.kf.setImage(with: artObject?.imageURL)
      titleLabel.text = artObject?.title
      authorLabel.text = artObject?.author
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    contentView.layer.cornerRadius = LayoutConsts.cornerRadius
    contentView.layer.masksToBounds = true
    contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
    
    contentView.addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.heightAnchor.constraint(equalToConstant: LayoutConsts.imageViewHeight),
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
    ])
    
    contentView.addSubview(descriptionStackView)
    NSLayoutConstraint.activate([
      descriptionStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LayoutConsts.defaultInsets.top),
      descriptionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConsts.defaultInsets.left),
      descriptionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConsts.defaultInsets.right),
      descriptionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConsts.defaultInsets.bottom)
    ])
  }
}
