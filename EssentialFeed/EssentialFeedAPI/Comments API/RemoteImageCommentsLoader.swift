//
//  RemoteImageCommentsLoader.swift
//  EssentialFeedAPI
//
//  Created by Michał Kasprzyk on 10/01/2023.
//

import Foundation
import EssentialFeed

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
