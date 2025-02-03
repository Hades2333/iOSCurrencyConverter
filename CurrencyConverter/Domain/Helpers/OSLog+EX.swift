//
//  OSLog+EX.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation
import OSLog

extension Logger {
    static let exchangeRate = Logger(subsystem: "CurrencyConverter", category: "GetExchangeRateUseCase")
}
