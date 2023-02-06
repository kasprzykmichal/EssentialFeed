//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Michał Kasprzyk on 25/12/2022.
//

import XCTest
import EssentialFeed

final class FeedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table: table)
    }
}
