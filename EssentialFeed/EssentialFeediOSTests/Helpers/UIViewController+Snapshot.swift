//
//  UIViewController+Snapshot.swift
//  EssentialFeediOSTests
//
//  Created by Michał Kasprzyk on 30/01/2023.
//

import UIKit

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}
