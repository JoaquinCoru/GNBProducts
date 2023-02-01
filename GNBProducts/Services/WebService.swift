//
//  WebService.swift
//  GNBProducts
//
//  Created by Joaquín Corugedo Rodríguez on 29/1/23.
//

import Foundation
import Combine

let baseUrl = "https://android-ios-service.herokuapp.com"

enum Endpoints: String {
    case rates = "/rates"
    case transactions = "/transactions"
}

enum NetworkError: Error {
    case malformedURL
    case other
    case noData
    case decoding
}

protocol WebServiceDelegate: AnyObject {
    
    func getRates(completion: @escaping ([Rate], NetworkError?) -> Void)
    func getTransactions(completion: @escaping ([Transaction], NetworkError?) -> Void)
}

final class WebService: WebServiceDelegate {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getRates(completion: @escaping ([Rate], NetworkError?) -> Void){
        let urlString = "\(baseUrl)\(Endpoints.rates.rawValue)"
        
        performAuthenticatedNetworkRequest(urlString: urlString ) { (result: Result<[Rate], NetworkError>) in
            
            switch result {
            case .success(let success):
                completion(success, nil)
            case .failure(let failure):
                completion([], failure)
            }
        }
    }
    
    func getTransactions(completion: @escaping ([Transaction], NetworkError?) -> Void) {
        let urlString = "\(baseUrl)\(Endpoints.transactions.rawValue)"
        
        performAuthenticatedNetworkRequest(urlString: urlString) { (result: Result<[Transaction], NetworkError>) in
            
            switch result {
            case .success(let success):
                completion(success, nil)
            case .failure(let failure):
                completion([], failure)
            }
        }
    }

    func getTransactions() -> AnyPublisher<[Transaction], Error> {
        let urlString = "\(baseUrl)\(Endpoints.transactions.rawValue)"
        
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
}

extension WebService {
    func performAuthenticatedNetworkRequest<T:Codable>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.malformedURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.other))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let response = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            
            completion(.success(response))
        }
        
        task.resume()
    }
}

