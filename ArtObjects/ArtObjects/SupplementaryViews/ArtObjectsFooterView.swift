//
//  ArtObjectsFooterView.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 26.04.2024.
//

import UIKit

class ArtObjectsFooterView: UICollectionReusableView {
  static var reuseIdentifier: String {
    return String(describing: ArtObjectsFooterView.self)
  }
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    return activityIndicator
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    activityIndicator.startAnimating()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
