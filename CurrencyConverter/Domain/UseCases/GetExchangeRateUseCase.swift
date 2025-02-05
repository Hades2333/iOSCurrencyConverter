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
    private let maxAmount: Double = 100_000_000
    
    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func execute(fromAmount: Double, fromCurrency: String, toCurrency: String) async throws -> ExchangeRate {
        do {
            
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            guard fromAmount <= maxAmount else {
                throw ExchangeRateError.amountTooLarge
            }
            
            let exchangeRateDTO = try await repository.getCurrentRate(
                fromAmount: fromAmount,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency
            )
            return try ExchangeRateMapper.map(dto: exchangeRateDTO)
            
        } catch let error as ExchangeRateMappingError {
            Logger.exchangeRate.error("Mapping Error: \(error.localizedDescription)")
            
            throw ExchangeRateError.invalidData
        } catch(let error) {
            throw error
        }
    }
}
