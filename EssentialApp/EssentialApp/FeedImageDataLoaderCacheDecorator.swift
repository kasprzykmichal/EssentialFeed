//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Michał Kasprzyk on 29/12/2022.
//

import EssentialFeed

public class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache

    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            if let data = try? result.get() {
                self?.cache.saveIgnoringResult(data, url: url)
            }
            completion(result)
        }
    }
}

private extension FeedImageDataCache {
    func saveIgnoringResult(_ data: Data, url: URL) {
        save(data, for: url) { _ in }
    }
}
