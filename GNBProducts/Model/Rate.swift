//
//  Rate.swift
//  GNBProducts
//
//  Created by Joaquín Corugedo Rodríguez on 29/1/23.
//

import Foundation

struct Rate: Codable {
    let from: String
    let to: String
    let rate: Decimal
}
