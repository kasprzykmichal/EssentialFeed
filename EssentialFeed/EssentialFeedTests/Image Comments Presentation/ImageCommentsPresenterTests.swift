//
//  ImageCommentsPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Michał Kasprzyk on 24/01/2023.
//

import XCTest
import EssentialFeed

class ImageCommentsPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }
    
    // MARK: - Helpers
    
    private func localized(_ key: String, table: String = "ImageComments", file: StaticString = #file, line: UInt = #line) -> String {
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key), in table: \(table)", file: file, line: line)
        }
        return value
    }}
