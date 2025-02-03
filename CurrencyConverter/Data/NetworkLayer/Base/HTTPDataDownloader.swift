//
//  HTTPDataDownloader.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

protocol HTTPDataDownloader {
    func httpData(for request: URLRequest) async throws -> Data
}

extension URLSession: HTTPDataDownloader {
    func httpData(for request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await self.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return data
                
            case 401:
                throw APIError.unauthorized
                
            case 403:
                throw APIError.forbidden
                
            case 404:
                throw APIError.notFound
                
            case 500...599:
                throw APIError.serverError
                
            default:
                throw APIError.statusCode(httpResponse.statusCode)
            }
        } catch let error as URLError {
            throw APIError.networkError(error)
        } catch {
            throw APIError.decoding
        }
    }
}
