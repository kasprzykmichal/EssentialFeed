//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 22/12/2022.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
