//
//  FeedImagesMapper.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 03/12/2022.
//

import Foundation
import EssentialFeed

public final class FeedImagesMapper {
    private struct Root: Decodable {
        private let items: [RemoteFeedItem]
        
        private struct RemoteFeedItem: Decodable {
            let id: UUID
            let description: String?
            let location: String?
            let image: URL
        }
        
        var images: [FeedImage] {
            items.map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
        }
    }
    
     public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
         guard response.isOK,
             let root = try? JSONDecoder().decode(Root.self, from: data) else {
             throw RemoteFeedLoader.Error.invalidData
         }
        
         return root.images
    }
}
