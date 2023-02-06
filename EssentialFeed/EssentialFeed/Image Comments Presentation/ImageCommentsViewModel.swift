//
//  ImageCommentsViewModel.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 24/01/2023.
//

import Foundation

public struct ImageCommentsViewModel: Equatable {
    public let comments: [ImageCommentViewModel]
    
    public init(comments: [ImageCommentViewModel]) {
        self.comments = comments
    }
}
