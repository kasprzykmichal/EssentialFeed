//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Michał Kasprzyk on 14/12/2022.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
