//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Michał Kasprzyk on 29/12/2022.
//

import XCTest
import EssentialApp
import EssentialFeed

final class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {
    func test_load_deliversFeedOnLoaderSuccess() {
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed))
        
        expect(sut, toCompleteWith: .success(feed))
    }

    func test_load_deliversFeedOnLoaderError() {
        let error = anyNSError()
        let sut = makeSUT(loaderResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(error))
    }

    func test_load_cachesLoadedFeedOnLoaderSuccess() {
        let cache = CacheSpy()
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertEqual(cache.messages, [.save(feed)], "Expected to cache loaded feed on success")
    }

    func test_load_doesNotCacheOnLoaderFailure() {
        let cache = CacheSpy()
        let sut = makeSUT(loaderResult: .failure(anyNSError()), cache: cache)
        
        sut.load { _ in }
        
        XCTAssertEqual(cache.messages, [], "Expected to cache loaded feed on success")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(loaderResult: FeedLoader.Result, cache: FeedCache = CacheSpy(), file: StaticString = #file, line: UInt = #line) -> FeedLoader {
        let loader = FeedLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private class CacheSpy: FeedCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save([FeedImage])
        }

        func save(_ feed: [FeedImage], completion: @escaping (FeedCache.Result) -> ()) {
            messages.append(.save(feed))
            completion(.success(()))
        }
    }
}
