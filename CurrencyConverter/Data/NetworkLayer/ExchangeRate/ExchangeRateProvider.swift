//
//  ExchangeRateService.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

class ExchangeRateProvider {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func getCurrentRate(fromAmount: Double, fromCurrency: String, toCurrency: String) async throws -> Data {
        try await client.data(from: ExchangeRateEndpoint.getExchangeRates(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency))
    }
}
