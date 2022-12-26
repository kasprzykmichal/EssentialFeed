//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 26/12/2022.
//

import Foundation

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public struct FeedErrorViewModel {
    public let message: String?
    
    public static let noError = FeedErrorViewModel(message: nil)
    
    public static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
