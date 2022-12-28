//
//  FeedLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Michał Kasprzyk on 28/12/2022.
//

import Foundation
import EssentialFeed

public class FeedLoaderWithFallbackComposite: FeedLoader {
    private let primary: FeedLoader
    private let fallback: FeedLoader
    
    public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primary.load { [weak self] primaryResult in
            switch primaryResult {
            case .success:
                completion(primaryResult)
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}
