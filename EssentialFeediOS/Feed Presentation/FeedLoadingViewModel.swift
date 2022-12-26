//
//  FeedLoadingViewModel.swift
//  EssentialFeediOS
//
//  Created by Michał Kasprzyk on 26/12/2022.
//

import EssentialFeed

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedLoadingViewModel {
    let isLoading: Bool
}
