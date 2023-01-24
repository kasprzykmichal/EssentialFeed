//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 26/12/2022.
//

import Foundation

public final class FeedPresenter {
    private let feedView: FeedView
    private let loadingView: ResouceLoadingView
    private let errorView: ResourceErrorView
    
    private var feedLoadError: String {
        return NSLocalizedString("GENERIC_CONNECTION_ERROR",
                tableName: "Shared",
                bundle: Bundle(for: FeedPresenter.self),
                comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    public init(feedView: FeedView, loadingView: ResouceLoadingView, errorView: ResourceErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view")
    }
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(Self.map(feed))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: feedLoadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }

    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        return FeedViewModel(feed: feed)
    }
}
