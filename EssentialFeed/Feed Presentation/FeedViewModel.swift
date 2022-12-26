//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 26/12/2022.
//

import Foundation

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public struct FeedViewModel {
    public let feed: [FeedImage]
}
