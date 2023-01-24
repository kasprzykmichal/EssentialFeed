//
//  ImageCommentsPresenter.swift
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

public struct ImageCommentViewModel: Equatable {
    public let message: String
    public let date: String
    public let username: String

    public init(message: String, date: String, username: String) {
        self.message = message
        self.date = date
        self.username = username
    }
}

public class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
            tableName: "ImageComments",
            bundle: Bundle(for: ImageCommentsPresenter.self),
            comment: "Title for the image comments view")
    }

    public static func map(_ comments: [ImageComment]) -> ImageCommentsViewModel {
        let formatter = RelativeDateTimeFormatter()
        
        return ImageCommentsViewModel(comments: comments.map { comment in
            return ImageCommentViewModel(message: comment.message, date: formatter.localizedString(for: comment.createdAt, relativeTo: .now), username: comment.username)
        })
    }
}
