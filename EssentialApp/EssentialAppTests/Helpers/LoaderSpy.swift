//
//  LoaderSpy.swift
//  EssentialAppTests
//
//  Created by Michał Kasprzyk on 05/02/2023.
//

import Foundation
import EssentialFeed
import Combine

class LoaderSpy: FeedImageDataLoader {
    
    // MARK: - FeedLoader
    
    private var feedRequests = [PassthroughSubject<[FeedImage], Error>]()
    
    var loadFeedCallCount: Int {
        return feedRequests.count
    }

    func loadPublisher() -> AnyPublisher<[FeedImage], Error> {
        let publisher = PassthroughSubject<[FeedImage], Error>()
        feedRequests.append(publisher)
        return publisher.eraseToAnyPublisher()
    }

    func completeFeedLoading(with feed: [FeedImage] = [], at index: Int) {
        feedRequests[index].send(feed)
    }

    func completeFeedLoadingWithError(at index: Int) {
        let error = NSError(domain: "an error", code: 0)
        feedRequests[index].send(completion: .failure(error))
    }
    
    // MARK: - FeedImageDataLoader
    
    private struct TaskSpy: FeedImageDataLoaderTask {
        let cancelCallback: () -> Void
        
        func cancel() {
            cancelCallback()
        }
    }
    
    private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
    private(set) var cancelledImageURLs = [URL]()

    var loadedImageURLs: [URL] {
        return imageRequests.map { $0.url }
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        imageRequests.append((url, completion))
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
    }

    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }

    func completeImageLoadingWithError(at index: Int) {
        let error = NSError(domain: "any error", code: 0)
        imageRequests[index].completion(.failure(error))
    }
}
