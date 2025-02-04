//
//  CurrencyPickerViewModel.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation
import Combine

class CurrencyPickerViewModel {
    
    private let currenciesUseCase: GetCurrenciesListUseCase
    
    @Published var allCurrencies: [CurrencyModel] = []
    @Published var filteredCurrencies: [CurrencyModel] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(currenciesUseCase: GetCurrenciesListUseCase) {
        self.currenciesUseCase = currenciesUseCase
        Task { @MainActor in
            await self.fetchCurrencies()
        }
    }

    func fetchCurrencies() async {
        do {
            let currencies = try await self.currenciesUseCase.getCurrenciesList()

            await MainActor.run {
                self.allCurrencies = currencies
                self.filteredCurrencies = currencies
            }

        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func addCancellable(_ cancellable: AnyCancellable) {
        cancellables.insert(cancellable)
    }
    
    func filterCurrencies(by searchText: String) {
        if searchText.isEmpty {
            filteredCurrencies = allCurrencies
        } else {
            filteredCurrencies = allCurrencies.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased()) ||
                $0.country.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func numberOfRows() -> Int {
        return filteredCurrencies.count
    }
    
    func currency(at index: Int) -> CurrencyModel? {
//        return filteredCurrencies[index]
        guard index >= 0, index < filteredCurrencies.count else {
                print("❌ Attempted to access index \(index) in filteredCurrencies, but count is \(filteredCurrencies.count)")
                return nil
            }
            return filteredCurrencies[index]
    }
}
