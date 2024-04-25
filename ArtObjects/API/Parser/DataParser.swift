//
//  DataParser.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

import Foundation

protocol DataParserProtocol {
  func parse<T: Decodable>(data: Data) throws -> T
}

class DataParser: DataParserProtocol {
  private var jsonDecoder: JSONDecoder
  
  init(jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.jsonDecoder = jsonDecoder
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
  }
  
  func parse<T: Decodable>(data: Data) throws -> T {
    guard let decodedResponse = try? jsonDecoder.decode(T.self, from: data) else {
      throw RequestError.decode
    }
    return decodedResponse
  }
}
