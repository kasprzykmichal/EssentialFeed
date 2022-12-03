//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 01/12/2022.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
