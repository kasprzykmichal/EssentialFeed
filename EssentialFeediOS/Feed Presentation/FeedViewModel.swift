//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Michał Kasprzyk on 26/12/2022.
//

import EssentialFeed

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}
