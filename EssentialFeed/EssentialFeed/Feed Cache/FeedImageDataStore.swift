//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 27/12/2022.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
