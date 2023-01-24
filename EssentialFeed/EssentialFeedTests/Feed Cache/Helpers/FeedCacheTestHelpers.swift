//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Michał Kasprzyk on 14/12/2022.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let localImages = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (models, localImages)
}

extension Date {
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(minutes: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}
