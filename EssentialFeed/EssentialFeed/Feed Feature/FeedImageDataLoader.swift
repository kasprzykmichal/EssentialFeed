//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 22/12/2022.
//

import Foundation

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
