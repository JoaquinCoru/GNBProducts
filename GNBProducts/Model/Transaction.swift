//
//  Transaction.swift
//  GNBProducts
//
//  Created by Joaquín Corugedo Rodríguez on 29/1/23.
//

import Foundation

struct Transaction: Codable, Hashable {
    let sku: String
    let amount: Float
    let currency: String    
}
