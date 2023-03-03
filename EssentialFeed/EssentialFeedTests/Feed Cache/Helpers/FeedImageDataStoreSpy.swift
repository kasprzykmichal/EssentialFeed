//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Michał Kasprzyk on 27/12/2022.
//

import Foundation
import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, url: URL)
    }
    
    private(set) var receivedMessages = [Message]()
    
    private var retrievalResult: Result<Data?, Error>?
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        receivedMessages.append(.retrieve(dataFor: url))
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }

    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalResult = .success(data)
    }

    private var insertionResult: Result<Void, Error>?

    func insert(_ data: Data, for url: URL) throws {
        receivedMessages.append(.insert(data: data, url: url))
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
}
