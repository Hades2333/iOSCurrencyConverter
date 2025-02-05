//
//  UIViewController+EX.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import UIKit

enum AlertConstants {
    static let errorTitle = "Error"
    static let buttonTitleOK = "OK"
}
extension UIViewController {
    func showAlert(message: String?) {
        guard let message else {
            return
        }
        let alert = UIAlertController(title: AlertConstants.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertConstants.buttonTitleOK, style: .default))
        self.present(alert, animated: true)
    }
}
