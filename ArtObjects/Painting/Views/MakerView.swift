//
//  MakerView.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 29.04.2024.
//

import UIKit

class MakerView: UIView {
  private(set) lazy var descriptionlabel: UILabel = {
    let descriptionlabel = UILabel()
    descriptionlabel.textColor = .secondaryLabel
    descriptionlabel.numberOfLines = 0
    return descriptionlabel
  }()
  
  private lazy var paintImageView: UIImageView = {
    let paintImageView = UIImageView()
    paintImageView.image = UIImage(systemName: "paintpalette")
    paintImageView.tintColor = .secondaryLabel
    return paintImageView
  }()
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [paintImageView, descriptionlabel])
    stackView.alignment = .firstBaseline
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  init() {
    super.init(frame: .zero)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}
