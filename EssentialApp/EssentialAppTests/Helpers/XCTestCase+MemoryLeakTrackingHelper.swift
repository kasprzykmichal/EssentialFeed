//
//  XCTestCase+MemoryLeakTrackingHelper.swift
//  EssentialAppTests
//
//  Created by Michał Kasprzyk on 28/12/2022.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.")
        }
    }
}
