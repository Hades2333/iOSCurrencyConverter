//
//  GetCurriencesListUseCase.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation
import OSLog

class GetCurrenciesListUseCase {
    private let repository: CurrenciesRepository

    init(repository: CurrenciesRepository) {
        self.repository = repository
    }

    func getCurrenciesList() async throws -> [CurrencyModel] {
        let currencies = try await repository.getCurrencies()
        return currencies
    }
}
