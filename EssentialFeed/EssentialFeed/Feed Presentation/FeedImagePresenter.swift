//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 30/12/2022.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        return FeedImageViewModel(description: image.description, location: image.location)
    }
}
