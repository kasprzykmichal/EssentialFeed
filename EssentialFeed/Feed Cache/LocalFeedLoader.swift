//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 07/12/2022.
//

import Foundation

private final class FeedCachePolicy {
    private let currentDate: () -> Date
    private let calendar = Calendar(identifier: .gregorian)
    private let maxCacheAgeInDays: Int = 7

    init(currentDate: @escaping () -> Date) {
        self.currentDate = currentDate
    }
    
    func validate(_ timestamp: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else { return false }
        return currentDate() < maxCacheAge
    }
}

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let cachePolicy: FeedCachePolicy
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
        self.cachePolicy = FeedCachePolicy(currentDate: currentDate)
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias SaveResult = Error?
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> ()) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }

    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> ()) {
        store.insert(feed.toLocal(), timestamp: self.currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

extension LocalFeedLoader {
    public typealias LoadResult = LoadFeedResult
    
    public func load(completion: @escaping (LoadFeedResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, timestamp) where self.cachePolicy.validate(timestamp):
                completion(.success(feed.toModels()))
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in }
            case let .found(_, timestamp) where !self.cachePolicy.validate(timestamp):
                self.store.deleteCachedFeed { _ in }
            case .empty, .found:
                break
            }
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}
