//
//  Extensions.swift
//  GNBProducts
//
//  Created by Joaquín Corugedo Rodríguez on 30/1/23.
//

import Foundation


extension Decimal {
    
    /// - Parameters:
    ///   - scale: How many decimal places.
    ///   - roundingMode: How should number be rounded. Defaults to `.plain`.
    /// - Returns: The new rounded number.
    
    func rounded(_ scale: Int, roundingMode: RoundingMode = .plain) -> Decimal {
        var value = self
        var result: Decimal = 0
        NSDecimalRound(&result, &value, scale, roundingMode)
        return result
    }
}
