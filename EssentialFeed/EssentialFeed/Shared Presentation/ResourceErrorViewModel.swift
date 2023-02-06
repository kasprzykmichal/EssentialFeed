//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Michał Kasprzyk on 24/01/2023.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    public static let noError = ResourceErrorViewModel(message: nil)
    
    public static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
