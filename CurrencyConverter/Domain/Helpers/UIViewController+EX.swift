//
//  UIViewController+EX.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import UIKit

extension UIViewController {
    func showAlert(message: String?) {
        guard let message else {
            return
        }
        let alert = UIAlertController(title: "Text.Alert.errorTitle", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Text.Alert.buttonTitleOK", style: .default))
        self.present(alert, animated: true)
    }
}
