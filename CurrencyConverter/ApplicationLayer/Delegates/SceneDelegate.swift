//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 29/01/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let client: HTTPClient = HTTPClient()
        let repository: ExchangeRateRepository = .init(client: client)
        let excahngeUseCase = GetExchangeRateUseCase(repository: repository)
        let defaultsService: DefaultsServiceProtocol = DefaultsService()
        let viewModel = ExchangeRateViewModel(getExchangeRateUseCase: excahngeUseCase, defaultsService: defaultsService)
        let rootViewController = ExchangeRateViewController(viewModel: viewModel)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}
