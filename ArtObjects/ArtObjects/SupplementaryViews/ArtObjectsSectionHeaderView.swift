//
//  ArtObjectsSectionHeaderView.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

import UIKit

class ArtObjectsSectionHeaderView: UICollectionReusableView {
  static var reuseIdentifier: String {
    return String(describing: ArtObjectsSectionHeaderView.self)
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(
      ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize,
      weight: .bold)
    label.adjustsFontForContentSizeCategory = true
    label.textColor = .label
    label.textAlignment = .left
    label.setContentCompressionResistancePriority(
      .defaultHigh, for: .horizontal)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor),
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
