//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

struct CurrencyModel: Codable {
    let name: String
    let code: String
    let country: String
    let countryCode: String
    
    static let defaultOrigin: CurrencyModel = CurrencyModel(name: "United States Dollar", code: "USD", country: "United States", countryCode: "US")
    
    static let defaultTarget: CurrencyModel = CurrencyModel(name: "Ukrainian Hryvnia", code: "UAH", country: "Ukraine", countryCode: "UA")
}
