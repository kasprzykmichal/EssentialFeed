//
//  ImageCommentViewModel.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 24/01/2023.
//

import Foundation

public struct ImageCommentViewModel: Equatable, Hashable {
    public let message: String
    public let date: String
    public let username: String

    public init(message: String, date: String, username: String) {
        self.message = message
        self.date = date
        self.username = username
    }
}
