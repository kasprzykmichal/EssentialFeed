//
//  FeedEndpoint.swift
//  EssentialFeedAPI
//
//  Created by Michał Kasprzyk on 25/02/2023.
//

import Foundation

public enum FeedEndpoint {
     case get

     public func url(baseURL: URL) -> URL {
         switch self {
         case .get:
             return baseURL.appendingPathComponent("/v1/feed")
         }
     }
 }
