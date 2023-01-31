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

protocol WebServiceDelegate: AnyObject {
    
    func getRates() -> AnyPublisher<[Rate], Error>
    func getTransactions() -> AnyPublisher<[Transaction], Error>
}

final class WebService: WebServiceDelegate {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getRates() -> AnyPublisher<[Rate], Error> {
        let urlString = "\(baseUrl)\(Endpoints.rates.rawValue)"
        
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Rate].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
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
