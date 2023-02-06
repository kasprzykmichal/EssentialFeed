//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Michał Kasprzyk on 23/12/2022.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
