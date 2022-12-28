//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Michał Kasprzyk on 28/12/2022.
//

import Foundation

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
