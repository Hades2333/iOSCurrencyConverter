//
//  File.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

protocol DefaultsServiceProtocol {
    func fetchFromCurrency() -> CurrencyModel?
    func fetchToCurrency() -> CurrencyModel?
    func fetchAmount() -> Double?
    func save(fromCurrency: CurrencyModel)
    func save(toCurrency: CurrencyModel)
    func save(amount: Double)
}

final class DefaultsService: DefaultsServiceProtocol {
    private let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    func save(fromCurrency: CurrencyModel) {
        if let encoded = try? JSONEncoder().encode(fromCurrency) {
            userDefaults.set(encoded, forKey: .fromCurrency)
        }
    }
    
    func save(toCurrency: CurrencyModel) {
        if let encoded = try? JSONEncoder().encode(toCurrency) {
            userDefaults.set(encoded, forKey: .toCurrency)
        }
    }
    
    func save(amount: Double) {
        userDefaults.set(amount, forKey: .amount)
    }
    
    func fetchFromCurrency() -> CurrencyModel? {
        guard let encoded = userDefaults.data(forKey: .fromCurrency) else { return nil }
        return try? JSONDecoder().decode(CurrencyModel.self, from: encoded)
    }
    
    func fetchToCurrency() -> CurrencyModel? {
        guard let encoded = userDefaults.data(forKey: .toCurrency) else { return nil }
        return try? JSONDecoder().decode(CurrencyModel.self, from: encoded)
    }
    
    func fetchAmount() -> Double? {
        userDefaults.double(forKey: .amount)
    }
}

// MARK: - Constants
private extension String {
    static let fromCurrency = "fromCurrency"
    static let toCurrency = "toCurrency"
    static let amount = "amount"
}
