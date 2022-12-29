//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Michał Kasprzyk on 29/12/2022.
//

import XCTest

final class EssentialAppUIAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()

        XCTAssertEqual(app.cells.count, 22)
        
        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
        XCTAssertNotNil(firstImage)
    }
}
