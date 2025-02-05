//
//  HTTPClient.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import Foundation

class HTTPClient {
    private let downloader: any HTTPDataDownloader
    private let requestBuilder: RequestBuilder

    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970
        return aDecoder
    }()

    init(downloader: any HTTPDataDownloader = URLSession.shared, requestBuilder: RequestBuilder = .init()) {
        self.downloader = downloader
        self.requestBuilder = requestBuilder
    }
}

extension HTTPClient {
    @discardableResult
    func data(from endpoint: Endpoint) async throws -> Data {
        let request = try requestBuilder.makeRequest(from: endpoint)
        return try await downloader.httpData(for: request)
    }

    func data<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        let request = try requestBuilder.makeRequest(from: endpoint)
        let data = try await downloader.httpData(for: request)
        return try decoder.decode(from: data)
    }
}
