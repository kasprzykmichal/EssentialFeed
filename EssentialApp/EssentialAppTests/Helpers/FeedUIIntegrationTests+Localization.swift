//
//  FeedUIIntegrationTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Michał Kasprzyk on 25/12/2022.
//

import Foundation
import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }

    var commentsTitle: String {
        ImageCommentsPresenter.title
    }
    
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) { }
    }
}
