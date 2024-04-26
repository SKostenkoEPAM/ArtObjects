//
//  ArtObjectsViewModel.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

import Foundation

protocol ArtObjectsViewModelDelegate: AnyObject {
  func onFetchCompleted()
  func onFetchFailed(with reason: String)
}

class ArtObjectsViewModel {
  
  static private let itemsInSection = 5
  
  weak var delegate: ArtObjectsViewModelDelegate?
  
  private var artObjects: [ArtObject] = []
  private var currentPage = 1
  private var total = 0
  private var isFetchInProgress = false
  
  private let requestManager = RequestManager()
  
  var totalCount: Int {
    return total
  }
  
  var currentCount: Int {
    return artObjects.count
  }
  
  var sections: [ArtObjectsSection] {
    return stride(from: 0, to: artObjects.count, by: Self.itemsInSection).map {
      Array(artObjects[$0..<min($0 + Self.itemsInSection, artObjects.count)])
    }
    .enumerated()
    .map {
      ArtObjectsSection(index: $0.offset, artObjects: $0.element)
    }
  }
  
  var title: String {
    "ArtObjects"
  }
  
  func artObject(at indexPath: IndexPath) -> ArtObject {
    let index = Self.itemsInSection * indexPath.section + indexPath.row
    return artObjects[index]
  }
  
  func fetchArtObjects() {
    guard !isFetchInProgress else { return }
    
    isFetchInProgress = true
    
    requestManager.perform(
      ArtObjectsRequest.getArtObjects(page: currentPage)
    ) { [weak self] (result: Result<Response, RequestError>) in
      
      guard let self else { return }
      switch result {
      case .success(let response):
        DispatchQueue.main.async {
          self.currentPage += 1
          self.total = response.count
          self.artObjects.append(contentsOf: response.artObjects)
          self.delegate?.onFetchCompleted()
          self.isFetchInProgress = false
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self.isFetchInProgress = false
          self.delegate?.onFetchFailed(with: error.reason)
        }
      }
    }
  }
}
