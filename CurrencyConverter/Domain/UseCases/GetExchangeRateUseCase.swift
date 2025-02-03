//
//  File.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation
import OSLog

class GetExchangeRateUseCase {
    private let repository: ExchangeRateRepository

    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func execute(fromAmount: Double, fromCurrency: String, toCurrency: String) async throws -> ExchangeRate {
        do {
            let exchangeRateDTO = try await repository.getCurrentRate(
                fromAmount: fromAmount,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency
            )
            return try ExchangeRateMapper.map(dto: exchangeRateDTO)
            
        } catch let error as ExchangeRateMappingError {
            Logger.exchangeRate.error("Mapping Error: \(error.localizedDescription)")
            
            throw ExchangeRateError.invalidData
        } catch {
            throw ExchangeRateError.unknown
        }
    }
}
