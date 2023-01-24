//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 24/01/2023.
//

import Foundation

public struct FeedViewModel {
    public let feed: [FeedImage]
    
    public init(feed: [FeedImage]) {
        self.feed = feed
    }
}
