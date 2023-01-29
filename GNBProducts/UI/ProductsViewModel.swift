//
//  ProductsViewModel.swift
//  GNBProducts
//
//  Created by Joaquín Corugedo Rodríguez on 29/1/23.
//

import Foundation
import Combine


class ProductsViewModel: ObservableObject {
    
    @Published var transactions = [Transaction]()
    
    @Published var products = Set<String>()
    
    private var suscriptors = Set<AnyCancellable>()
    
    private var webService: WebServiceDelegate
    
    init(webService: WebServiceDelegate = WebService()) {
        self.webService = webService
    }
        
    func loadTransactions() {
        
        webService.getTransactions().sink { _ in
            
        } receiveValue: { transactions in
            print(transactions)
            self.products = transactions.reduce(into: Set<String>(), { partialResult, transaction in
                partialResult.insert(transaction.sku)
            })
            
            print(self.products)
        }
        .store(in: &suscriptors)

    }
}
