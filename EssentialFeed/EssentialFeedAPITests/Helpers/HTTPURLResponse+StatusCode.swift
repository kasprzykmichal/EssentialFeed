//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeedAPITests
//
//  Created by Michał Kasprzyk on 10/01/2023.
//

import Foundation

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
