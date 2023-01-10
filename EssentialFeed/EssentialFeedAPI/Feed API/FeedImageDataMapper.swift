//
//  FeedImageDataMapper.swift
//  EssentialFeedAPI
//
//  Created by Michał Kasprzyk on 10/01/2023.
//

import Foundation

public class FeedImageDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidData
        }
        return data
    }
}
