//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 01/12/2022.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
