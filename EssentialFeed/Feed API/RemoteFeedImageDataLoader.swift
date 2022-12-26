//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 27/12/2022.
//

import Foundation

public class RemoteFeedImageDataLoader: FeedImageDataLoader {
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private class HTTPTaskWrapper: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping ((FeedImageDataLoader.Result) -> Void)) {
            self.completion = completion
        }
    
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventsFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventsFurtherCompletions() {
            completion = nil
        }
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }

    @discardableResult
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPTaskWrapper(completion)
        
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure:
                task.complete(with: .failure(Error.connectivity))
            case let .success((data, response)):
                if response.statusCode == 200, !data.isEmpty {
                    task.complete(with: .success(data))
                } else {
                    task.complete(with: .failure(Error.invalidData))
                }
            }
        }
        
        return task
    }
}
