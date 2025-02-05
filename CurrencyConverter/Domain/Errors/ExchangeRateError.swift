//
//  ExchangeRateError.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

enum ExchangeRateError: Error, LocalizedError {
    case networkIssue
    case rateNotFound
    case serviceUnavailable
    case unknown
    case invalidData
    case bundleMissing
    case amountTooLarge

    var errorDescription: String? {
        switch self {
        case .networkIssue:
            return NSLocalizedString("Network connection issue. Please try again.", comment: "")
        case .rateNotFound:
            return NSLocalizedString("Exchange rate not found.", comment: "")
        case .serviceUnavailable:
            return NSLocalizedString("Service is currently unavailable. Please try again later.", comment: "")
        case .unknown:
            return NSLocalizedString("An unknown error occurred.", comment: "")
        case .invalidData:
            return NSLocalizedString("Invalid data received.", comment: "")
        case .bundleMissing:
            return NSLocalizedString("Required resource bundle is missing.", comment: "")
        case .amountTooLarge:
            return NSLocalizedString("The entered amount is too large to process.", comment: "")
        }
    }
}
