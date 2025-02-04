//
//  ExchangeRateError.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

enum ExchangeRateError: Error {
    case networkIssue
    case rateNotFound
    case serviceUnavailable
    case unknown
    case invalidData
    case bundleMissing
}
