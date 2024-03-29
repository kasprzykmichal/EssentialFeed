//
//  NullStore.swift
//  EssentialApp
//
//  Created by Michał Kasprzyk on 02/03/2023.
//

import EssentialFeed

class NullStore: FeedStore & FeedImageDataStore {
    func deleteCachedFeed(completion: @escaping FeedStore.DeletionCompletion) {
        completion(.success(()))
    }
    
    func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        completion(.success(()))
    }
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.success(.none))
    }
    
    func insert(_ data: Data, for url: URL) throws {}
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        return .none
    }
}
