//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 29/01/2025.
//

import UIKit

class ViewController: UIViewController {

    let api = APIClient()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await self.makeRequest()
        }
    }
    
    func makeRequest() async {
        do {
            let amount = try await api.exchangeRateProvider.getCurrentRate(fromAmount: 20, fromCurrency: "USD", toCurrency: "EUR")
            print(amount)
        } catch {
            print(error)
        }
    }
}

