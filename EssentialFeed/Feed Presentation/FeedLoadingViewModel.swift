//
//  FeedLoadingViewModel.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 26/12/2022.
//

import Foundation

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}
