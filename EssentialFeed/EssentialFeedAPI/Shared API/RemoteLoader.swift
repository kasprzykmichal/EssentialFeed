//
//  RemoteLoader.swift
//  EssentialFeedAPI
//
//  Created by Michał Kasprzyk on 10/01/2023.
//

import Foundation
import EssentialFeed

public final class RemoteLoader<Resource> {
    private let url: URL
    private let client: HTTPClient
    private let mapper: Mapper
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    public typealias Result = Swift.Result<Resource, Swift.Error>
    
    public init(url: URL, client: HTTPClient, mapper: @escaping Mapper) {
        self.url = url
        self.client = client
        self.mapper = mapper
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success((data, response)):
                completion(self.map(data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

    private func map(_ data: Data, response: HTTPURLResponse) -> Result {
        do {
            return .success(try mapper(data, response))
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
