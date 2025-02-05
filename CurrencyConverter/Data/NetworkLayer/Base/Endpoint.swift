//
//  Endpoint.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any]? { get }
}
