//
//  SharedTestHelpers.swift
//  EssentialFeedAPITests
//
//  Created by Michał Kasprzyk on 31/12/2022.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}
