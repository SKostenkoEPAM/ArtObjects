//
//  PaintingViewModel.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 26.04.2024.
//

import Foundation

protocol PaintingViewModelDelegate: AnyObject {
  func onFetchCompleted()
  func onFetchFailed(with reason: String)
}

class PaintingViewModel {
  
  weak var delegate: PaintingViewModelDelegate?
  
  private let requestManager = RequestManager()
  private let artObject: ArtObject
  
  var title: String {
    "Details"
  }
  
  private var painting: Painting!
  
  var paintingTitle: String {
    painting.title
  }
  
  var paintingDescription: String? {
    painting.description
  }
  
  var imageURL: URL {
    painting.image.url
  }
  
  var imageAspectRatio: CGFloat {
    return painting.image.width / painting.image.height
  }
  
  var makerTexts: [String] {
    painting.makers.map {
      """
        \($0.name)
        \($0.placeOfBirth ?? "") - \($0.dateOfBirth?.formatted(.dateTime.year()) ?? "")
        \($0.placeOfDeath ?? "") - \($0.dateOfDeath?.formatted(.dateTime.year()) ?? "")
      """
    }
  }
  
  var colors: [String] {
    painting.colors
  }
  
  init(artObject: ArtObject) {
    self.artObject = artObject
  }
  
  func fetchPainting() {
    requestManager.perform(
      PaintingRequest.getPainting(id: artObject.id)
    ) { [weak self] (result: Result<Painting, RequestError>) in
      
      guard let self else { return }
      
      switch result {
      case .success(let painting):
        DispatchQueue.main.async {
          self.painting = painting
          self.delegate?.onFetchCompleted()
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.delegate?.onFetchFailed(with: error.reason)
        }
      }
    }
  }
}
