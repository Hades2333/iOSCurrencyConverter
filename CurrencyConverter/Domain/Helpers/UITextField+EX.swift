//
//  UITextField+EX.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 04/02/2025.
//

import UIKit

extension UITextField {
    func setPadding(left: CGFloat, right: CGFloat) {
        if left > 0 {
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
            self.leftView = leftView
            self.leftViewMode = .always
        }
        
        if right > 0 {
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
            self.rightView = rightView
            self.rightViewMode = .always
        }
    }
}
