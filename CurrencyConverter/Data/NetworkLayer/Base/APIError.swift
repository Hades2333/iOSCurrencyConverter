//
//  APIError.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

enum APIError: Error {
    case networkError(Error)
    case decoding
    case invalidUrl
    case invalidResponse
    case statusCode(Int)
}
