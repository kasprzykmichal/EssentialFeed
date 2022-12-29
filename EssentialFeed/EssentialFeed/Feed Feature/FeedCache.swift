//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 29/12/2022.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> ())
}
