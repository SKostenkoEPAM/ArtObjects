//
//  Painting.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

import Foundation

struct Painting: Decodable {
  let id: String
  let title: String
  let description: String?
  let image: Image
  let makers: [Maker]
  let colors: [String]
  
  enum CodingKeys: CodingKey {
    case artObject
  }
  
  enum ArtObjectKeys: String, CodingKey {
    case id = "objectNumber"
    case title
    case description = "plaqueDescriptionEnglish"
    case image = "webImage"
    case makers = "principalMakers"
    case colors = "normalizedColors"
  }
  
  enum ColorKeys: CodingKey {
    case hex
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let artObjectContaner = try container.nestedContainer(
      keyedBy: ArtObjectKeys.self,
      forKey: .artObject
    )
    id = try artObjectContaner.decode(String.self, forKey: .id)
    title = try artObjectContaner.decode(String.self, forKey: .title)
    description = try artObjectContaner.decodeIfPresent(String.self, forKey: .description)
    makers = try artObjectContaner.decode([Maker].self, forKey: .makers)
    
    image = try artObjectContaner.decode(Image.self, forKey: .image)
    var colorsContainer = try artObjectContaner.nestedUnkeyedContainer(forKey: .colors)
    var colors: [String] = []
    while !colorsContainer.isAtEnd {
      let colorContainer = try colorsContainer.nestedContainer(keyedBy: ColorKeys.self)
      let color = try colorContainer.decode(String.self, forKey: .hex)
      colors.append(color)
    }
    self.colors = colors
  }
  
  struct Image: Decodable {
    let url: URL
    let width: CGFloat
    let height: CGFloat
  }
}

struct Maker: Decodable, Identifiable {
  let name: String
  let placeOfBirth: String?
  let placeOfDeath: String?
  let dateOfBirth: Date?
  let dateOfDeath: Date?
  
  var id: String { name }
}
