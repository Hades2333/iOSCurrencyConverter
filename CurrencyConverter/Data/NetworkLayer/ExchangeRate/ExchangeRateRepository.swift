//
//  ExchangeRateService.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

class ExchangeRateRepository {
    private let client: HTTPClient
    private let decoder = JSONDecoder()

    init(client: HTTPClient) {
        self.client = client
    }

    func getCurrentRate(fromAmount: Double, fromCurrency: String, toCurrency: String) async throws -> ExchangeRateDTO {
        do {
            let data = try await client.data(from: ExchangeRateEndpoint.getExchangeRates(
                fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency
            ))

            return try decoder.decode(ExchangeRateDTO.self, from: data)

        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw APIError.decoding
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
