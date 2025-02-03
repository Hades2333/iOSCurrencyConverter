//
//  ExchangeRatesEndpoint.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

enum ExchangeRateEndpoint {
    case getExchangeRates(fromAmount: Double, fromCurrency: String, toCurrency: String)
}

extension ExchangeRateEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getExchangeRates(fromAmount: let fromAmount, fromCurrency: let fromCurrency, toCurrency: let toCurrency):
            return "currency/commercial/exchange/\(fromAmount)-\(fromCurrency)/\(toCurrency)/latest"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var params: [String: Any]? {
        return nil
    }
}
