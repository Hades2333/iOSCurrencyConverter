//
//  Config.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

enum ConfigConstants {
    static let exchangeRatesApiKey = "ExchangeRatesAPIKey"
    static let openExchangeRatesApiKey = "OpenExchangeRatesAPIKey"
}

struct Config {
    static let shared = Config()
    private let dictionary: [String: Any]
    
    private init() {
        guard let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("Configuration.plist not found")
        }
        self.dictionary = dict
    }
    
    func apiKey(for service: ExchangeRatesService) -> String {
        switch service {
        case .ExchangeRatesAPI:
            return dictionary[ConfigConstants.exchangeRatesApiKey] as? String ?? String()
        case .OpenExchangeRatesAPI:
            return dictionary[ConfigConstants.openExchangeRatesApiKey] as? String ?? String()
        }
    }
}
