//
//  HTTPURLResponse+Status.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 27/12/2022.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
