//
//  FeedImageDataMapperTests.swift
//  EssentialFeedTests
//
//  Created by Michał Kasprzyk on 26/12/2022.
//

import XCTest
import EssentialFeed
import EssentialFeedAPI

final class FeedImageDataMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(try FeedImageDataMapper.map(anyData(), response: HTTPURLResponse(statusCode: code)))
        }
     }

    func test_map_throwsErrorOn200HTTPResponseWithEmptyData() {
        XCTAssertThrowsError(try FeedImageDataMapper.map(Data(), response: HTTPURLResponse(statusCode: 200)))
     }

    func test_map_deliversReceivedNonEmptyDataOn200HTTPResponse() throws {
        let nonEmptyData = Data("non-empty data".utf8)
        let result = try FeedImageDataMapper.map(nonEmptyData, response: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, nonEmptyData)
     }
}
