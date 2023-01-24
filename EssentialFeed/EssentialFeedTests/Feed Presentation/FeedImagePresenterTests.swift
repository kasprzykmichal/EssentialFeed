//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Michał Kasprzyk on 24/01/2023.
//

import XCTest
import EssentialFeed

class FeedImagePresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let image = uniqueImage()
        
        let viewModel = FeedImagePresenter<DummyView, AnyImage>.map(image)
        
        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }
    
    // MARK: - Helpers {
    
    private class DummyView: FeedImageView {
        typealias ResourceViewModel = FeedImageViewModel
        
        func display(_ viewModel: FeedImageViewModel<AnyImage>) { }
    }
    
    private struct AnyImage: Equatable {}
}
