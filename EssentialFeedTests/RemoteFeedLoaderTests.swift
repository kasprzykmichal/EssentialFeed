//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Michał Kasprzyk on 02/12/2022.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    func testInitDoesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
