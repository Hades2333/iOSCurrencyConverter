//
//  File.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

enum ExchangeRateMappingError: Error {
    case invalidAmount(String)
    case invalidCurrency(String)
}
