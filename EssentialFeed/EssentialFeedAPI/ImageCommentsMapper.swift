//
//  ImageCommentsMapper.swift
//  EssentialFeedAPI
//
//  Created by Michał Kasprzyk on 10/01/2023.
//

import Foundation

final class ImageCommentsMapper {
   private struct Root: Decodable {
       let items: [RemoteFeedImage]
   }
   
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedImage] {
       guard response.isOK,
           let root = try? JSONDecoder().decode(Root.self, from: data) else {
           throw RemoteImageCommentsLoader.Error.invalidData
       }
       
       return root.items
   }
}

