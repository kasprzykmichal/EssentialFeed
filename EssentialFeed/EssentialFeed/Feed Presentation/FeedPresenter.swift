//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 26/12/2022.
//

import Foundation

public final class FeedPresenter {
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view")
    }

    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        return FeedViewModel(feed: feed)
    }
}
