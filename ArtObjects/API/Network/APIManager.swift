//
//  APIManager.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

import Foundation

protocol APIManagerProtocol {
  func perform(_ request: Request, resultHandler: @escaping (Result<Data, RequestError>) -> Void)
}

class APIManager: APIManagerProtocol {
  
  private let urlSession: URLSession
  
  init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  func perform(_ request: Request, resultHandler: @escaping (Result<Data, RequestError>) -> Void) {
    do {
      let request = try request.createURLRequest()
      let urlTask = urlSession.dataTask(with: request) { data, response, error in
        guard error == nil else {
          resultHandler(.failure(.invalidURL))
          return
        }
        
        guard let response = response as? HTTPURLResponse else {
          resultHandler(.failure(.noResponse))
          return
        }
        
        guard let data = data else {
          resultHandler(.failure(.unknown))
          return
        }
        
        switch response.statusCode {
        case 200...299:
          resultHandler(.success(data))
        case 401:
          resultHandler(.failure(.unauthorized))
        default:
          resultHandler(.failure(.unexpectedStatusCode))
        }
      }
      urlTask.resume()
    } catch let error as RequestError {
      resultHandler(.failure(error))
    } catch {
      resultHandler(.failure(RequestError.unknown))
    }
  }
}
