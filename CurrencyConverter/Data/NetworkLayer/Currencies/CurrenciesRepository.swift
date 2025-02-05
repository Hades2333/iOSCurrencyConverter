//
//  File.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation
import OSLog

class CurrenciesRepository {
    private let client: HTTPClient
    private let decoder = JSONDecoder()
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getCurrencies() async throws -> [CurrencyModel] {
        guard let url = Bundle.main.url(forResource: "codes", withExtension: "json") else {
            Logger.exchangeRate.error("Error searching for JSON: \(ExchangeRateError.bundleMissing)")
            
            throw ExchangeRateError.bundleMissing
        }
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            let data = try Data(contentsOf: url)
            let currencies = try JSONDecoder().decode([CurrencyModel].self, from: data)
            return currencies
            
        } catch {
            Logger.exchangeRate.error("Error decoding JSON: \(ExchangeRateError.invalidData)")
            
            throw ExchangeRateError.invalidData
        }
    }
}
