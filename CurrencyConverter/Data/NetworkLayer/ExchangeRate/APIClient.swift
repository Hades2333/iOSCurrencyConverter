//
//  APIClient.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

class APIClient {
    let exchangeRateProvider: ExchangeRateProvider

    init(httpClient: HTTPClient = HTTPClient()) {
        self.exchangeRateProvider = ExchangeRateProvider(client: httpClient)
    }
}
