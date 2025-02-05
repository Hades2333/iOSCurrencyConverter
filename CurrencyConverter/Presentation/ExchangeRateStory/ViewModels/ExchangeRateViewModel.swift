//
//  File.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation
import Combine
import OSLog

@MainActor
class ExchangeRateViewModel: ObservableObject {
    
    private let defaultsService: DefaultsServiceProtocol

    @Published var originExchangeRate: CurrencyModel?
    @Published var targetExchangeRate: CurrencyModel?
    @Published var amount: Double?
    @Published var targetAmount: Double?
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let getExchangeRateUseCase: GetExchangeRateUseCase
    private var task: Task<Void, Never>?
    
    // MARK: - Initialization
    
    init(
        getExchangeRateUseCase: GetExchangeRateUseCase,
        defaultsService: DefaultsServiceProtocol
    ) {
        self.getExchangeRateUseCase = getExchangeRateUseCase
        self.defaultsService = defaultsService
        fetchDefaults()
    }
    
    private func fetchDefaults() {
        self.originExchangeRate = fetchFromCurreny()
        self.targetExchangeRate = fetchToCurrency()
        self.amount = fetchAmount()
    }
    
    func startUpdatingExchangeRate() {
        guard task == nil else { return }

        task = Task {
            while !Task.isCancelled {
                await fetchExchangeRate(
                    fromAmount: amount ?? 0.0,
                    fromCurrency: originExchangeRate ?? CurrencyModel.defaultOrigin,
                    toCurrency: targetExchangeRate ?? CurrencyModel.defaultTarget
                )
                
                if Task.isCancelled { return }
                
                do {
                    try await Task.sleep(nanoseconds: 4_000_000_000)
                } catch {
                    if Task.isCancelled { return }
                    Logger.exchangeRate.error("Sleep interrupted: \(error.localizedDescription)")
                }
            }
        }
    }
    
    deinit {
        task?.cancel()
    }
    
    // MARK: - Methods
    
    func fetchExchangeRate(fromAmount: Double, fromCurrency: CurrencyModel, toCurrency: CurrencyModel) async {
        
        saveData(fromCurrency: fromCurrency, toCurrency: toCurrency, amount: fromAmount)
        
        do {
            if Task.isCancelled { return }
                
            await MainActor.run {
                isLoading = true
            }
            
            let rate = try await getExchangeRateUseCase.execute(
                fromAmount: fromAmount, fromCurrency: fromCurrency.code, toCurrency: toCurrency.code
            )

            await MainActor.run {
                self.targetAmount = rate.amount
                self.errorMessage = nil
                
                isLoading = false
            }
            
        } catch {
            if Task.isCancelled { return }
            
            await MainActor.run {
                self.errorMessage = "An error occurred: \(error.localizedDescription)"
            }
        }
    }
    
    private func saveData(fromCurrency: CurrencyModel, toCurrency: CurrencyModel, amount: Double) {
        self.originExchangeRate = fromCurrency
        self.targetExchangeRate = toCurrency
        self.amount = amount
        defaultsService.save(fromCurrency: fromCurrency)
        defaultsService.save(toCurrency: toCurrency)
        defaultsService.save(amount: amount)
    }
    
    func fetchFromCurreny() -> CurrencyModel {
        if let fromCurrency = defaultsService.fetchFromCurrency() {
            return fromCurrency
        } else {
            return CurrencyModel.defaultOrigin
        }
    }
    
    func fetchAmount() -> Double {
        return defaultsService.fetchAmount() == 0 ? 100.00 : defaultsService.fetchAmount()!
    }
    
    func fetchToCurrency() -> CurrencyModel {
        if let toCurrency = defaultsService.fetchToCurrency() {
            return toCurrency
        } else {
            return CurrencyModel.defaultTarget
        }
    }
    
    func cancelUpdateTask() {
        task?.cancel()
        task = nil
    }
}
