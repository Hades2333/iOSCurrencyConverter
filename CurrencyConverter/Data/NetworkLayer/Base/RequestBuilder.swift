//
//  RequestBuilder.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

class RequestBuilder {
    
    func makeRequest(from endpoint: Endpoint) throws -> URLRequest {
        let url = try makeUrl(from: endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = makeBody(from: endpoint.params)
        return request
    }

    private func makeBody(from params: [String: Any]?) -> Data? {
        guard let params, !params.isEmpty else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: params)
    }

    private func makeUrl(from endpoint: Endpoint) throws -> URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.evp.lt"
        components.path = endpoint.path
        
        guard let url = components.url else {
            throw APIError.invalidUrl
        }
        return url
    }
}
