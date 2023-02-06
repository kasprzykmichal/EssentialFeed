//
//  ImageCommentsEndpoint.swift
//  EssentialFeedAPI
//
//  Created by Michał Kasprzyk on 06/02/2023.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
            case let .get(id):
                return baseURL.appending(component: "v1/image/\(id)/comments")
        }
    }
}
