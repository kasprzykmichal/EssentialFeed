//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Michał Kasprzyk on 24/01/2023.
//

import XCTest
import EssentialFeed

class SharedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table: table)
    }
    
    // MARK: - Helpers
    
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) { }
    }
}
