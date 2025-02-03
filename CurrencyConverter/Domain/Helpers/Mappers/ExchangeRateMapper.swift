//
//  File.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

struct ExchangeRateMapper {
    static func map(dto: ExchangeRateDTO) throws -> ExchangeRate {
        guard let amount = Double(dto.amount) else {
            throw ExchangeRateMappingError.invalidAmount(dto.amount)
        }

        guard let currency = Currency(rawValue: dto.currency) else {
            throw ExchangeRateMappingError.invalidCurrency(dto.currency)
        }

        return ExchangeRate(amount: amount, currency: currency)
    }
}
