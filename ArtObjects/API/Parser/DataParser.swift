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
  private static let yearDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter
  }()
  
  private static let yearMonthDayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }()
  
  init(jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.jsonDecoder = jsonDecoder
    jsonDecoder.dateDecodingStrategy = .custom {
      let container = try $0.singleValueContainer()
      let dateString = try container.decode(String.self)
      let dateFormatter = dateString.count < 5 ? Self.yearDateFormatter : Self.yearMonthDayDateFormatter
      let date = dateFormatter.date(from: dateString)
      guard let date else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date")
      }
      return date
    }
  }
  
  func parse<T: Decodable>(data: Data) throws -> T {
    guard let decodedResponse = try? jsonDecoder.decode(T.self, from: data) else {
      throw RequestError.decode
    }
    return decodedResponse
  }
}
