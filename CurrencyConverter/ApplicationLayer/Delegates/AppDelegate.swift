//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 29/01/2025.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let client: HTTPClient = HTTPClient()
        let repository: ExchangeRateRepository = .init(client: client)
        let excahngeUseCase = GetExchangeRateUseCase(repository: repository)
        let DefaultsService: DefaultsServiceProtocol = DefaultsService()
        let viewModel = ExchangeRateViewModel(getExchangeRateUseCase: excahngeUseCase, defaultsService: DefaultsService)
        let rootViewController = ExchangeRateViewController(viewModel: viewModel)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }
}
