//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 02/12/2022.
//

import Foundation
import EssentialFeed

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = FeedLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteFeedLoader.map(data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

    private static func map(_ data: Data, response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedImagesMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}
