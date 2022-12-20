//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 03/12/2022.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are resonsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
