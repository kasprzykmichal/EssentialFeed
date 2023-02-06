//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Michał Kasprzyk on 24/01/2023.
//

import XCTest
import EssentialFeed

final class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table: table)
    }
}
