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
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case statusCode(Int)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decoding:
            return "Failed to decode the response."
        case .invalidUrl:
            return "The URL provided was invalid."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .unauthorized:
            return "Unauthorized request. Please check your credentials."
        case .forbidden:
            return "Access forbidden. You don’t have permission."
        case .notFound:
            return "The requested resource was not found."
        case .serverError:
            return "Server encountered an error. Try again later."
        case .statusCode(let code):
            return "Unexpected HTTP status code: \(code)."
        }
    }
}
