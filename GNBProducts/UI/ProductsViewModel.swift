//
//  ProductsViewModel.swift
//  GNBProducts
//
//  Created by Joaquín Corugedo Rodríguez on 29/1/23.
//

import Foundation
import Combine


class ProductsViewModel: ObservableObject {
        
    @Published var filteredTransactions = [Transaction]()
    
    @Published var totalAmount: Decimal = 0.0
    
    @Published var allProductsLoaded = false
    @Published var products = Set<String>()
    
    private var transactions = [Transaction]()
    private var conversionRates = [Rate]()
    private var convertDictionary: [String:[String:Decimal]] = [:]
    
    private var suscriptors = Set<AnyCancellable>()
    
    private var webService: WebServiceDelegate
    
    init(webService: WebServiceDelegate = WebService()) {
        self.webService = webService
        
    }
    
    /// Get convertion rates
    func getRates() {
        webService.getRates{ [weak self] rates, error in
            if let error {
                print("Error: \(error.localizedDescription)")
            } else {
                self?.conversionRates = rates
                self?.getConvertDictionaryRates()
                self?.loadTransactions()
            }
        }
     
    }
    
    /// Transform list of convertion rates into a dictionary
    func getConvertDictionaryRates() {
        for rate in conversionRates {
            
            convertDictionary[rate.from] = [rate.to: rate.rate]
        }
        print("Conversion Rates \(convertDictionary)")
        
    }
  
    /// Load total list of transanctions
    private func loadTransactions() {
        
        webService.getTransactions { [weak self] transactions, error in
            if let error {
                print("Error: \(error.localizedDescription)")
            } else {
                self?.transactions = transactions
                self?.loadProducts()
            }
        }
        
    }

    ///Load list of products in a set to avoid duplicates
    private func loadProducts() {
        self.products = Set<String>()
        self.products = transactions.reduce(into: Set<String>(), { partialResult, transaction in
            partialResult.insert(transaction.sku)
        })
//        print("Productos: \(products.count)")
        allProductsLoaded = true
    }
    
    func filterTransactionsByProduct(product: String) {
        self.filteredTransactions = transactions.filter({$0.sku == product})
        calculateTotal()
    }
    
    /// Calculates  subotal of products in EUR
    private func calculateTotal()
    {
        var total: Decimal = 0.0
        
        for transaction in filteredTransactions {
            
            if transaction.currency == "EUR" {
                total += transaction.amount
            } else {
                total += convertToEur(input: transaction.amount, currency: transaction.currency)
            }
        }
        
        self.totalAmount = total.rounded(2)
        
    }
    
    ///Converts from one currency to EUR based on Dictionary conversions
    private func convertToEur(input: Decimal, currency: String) -> Decimal {
        var output: Decimal = 0.0
        
        if let rate = convertDictionary[currency]?.first?.value {
            
            output = input*rate

        }
        
        if let otherCurrency = convertDictionary[currency]?.first?.key {
            
            if otherCurrency != "EUR" {
                return convertToEur(input: output, currency: otherCurrency).rounded(2)
            } else {
                return output.rounded(2)
            }
                
        }
        
        return output
    }
    
}
