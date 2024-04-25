//
//  RequestManager.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

protocol RequestManagerProtocol {
  func perform<T: Decodable>(_ request: Request, resultHandler: @escaping (Result<T, RequestError>) -> Void)
}

final class RequestManager: RequestManagerProtocol {
  let apiManager: APIManagerProtocol
  let parser: DataParserProtocol
  
  init(
    apiManager: APIManagerProtocol = APIManager(),
    parser: DataParserProtocol = DataParser()
  ) {
    self.apiManager = apiManager
    self.parser = parser
  }
  
  func perform<T: Decodable>(_ request: Request, resultHandler: @escaping (Result<T, RequestError>) -> Void) {
    apiManager.perform(request) { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let data):
        do {
          let decoded: T = try self.parser.parse(data: data)
          resultHandler(.success(decoded))
        } catch {
          resultHandler(.failure(.decode))
        }
      case .failure(let error):
        resultHandler(.failure(error))
      }
    }
  }
}
