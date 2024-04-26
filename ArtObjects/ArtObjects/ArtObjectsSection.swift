//
//  ArtObjectsSection.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 26.04.2024.
//

class ArtObjectsSection: Hashable {
  private let index: Int
  let artObjects: [ArtObject]
  
  init(index: Int, artObjects: [ArtObject]) {
    self.index = index
    self.artObjects = artObjects
  }
  
  var title: String {
    "Page \(index + 1)"
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(index)
  }
  
  static func == (lhs: ArtObjectsSection, rhs: ArtObjectsSection) -> Bool {
    lhs.index == rhs.index
  }
}
