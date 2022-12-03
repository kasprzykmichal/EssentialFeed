//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 01/12/2022.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
