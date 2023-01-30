//
//  SharedHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Michał Kasprzyk on 30/01/2023.
//

import UIKit
import XCTest

func assert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
    let snapshotData = makeSnapshotData(for: snapshot)
    let snapshotURL = makeSnapshotURL(named: "\(name)", file: file)
    
    guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
        XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store snapshot before asserting", file: file, line: line)
        return
    }
    
    if snapshotData != storedSnapshotData {
        let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent(snapshotURL.lastPathComponent)
        try? snapshotData?.write(to: temporarySnapshotURL)
        XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), stored snapshot URL: \(snapshotURL)", file: file, line: line)
    }
}

func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
    let snapshotData = makeSnapshotData(for: snapshot)
    let snapshotURL = makeSnapshotURL(named: "\(name)", file: file)
    
    do {
        try FileManager.default.createDirectory(at: snapshotURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try snapshotData?.write(to: snapshotURL)
    } catch {
        XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
    }
}

private func makeSnapshotData(for snapshot: UIImage, file: StaticString = #file, line: UInt = #line) -> Data? {
    guard let data = snapshot.pngData() else {
        XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
        return nil
    }
    return data
}

private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
    return URL(fileURLWithPath: String(describing: file))
        .deletingLastPathComponent()
        .appendingPathComponent("snapshots")
        .appendingPathComponent("\(name).png")
}

struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection

    static func iPhone8(style: UIUserInterfaceStyle) -> SnapshotConfiguration {
    return SnapshotConfiguration(
        size: CGSize(width: 375, height: 667),
        safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
        layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
        traitCollection: UITraitCollection(traitsFrom: [
            .init(forceTouchCapability: .available),
            .init(layoutDirection: .leftToRight),
            .init(preferredContentSizeCategory: .medium),
            .init(userInterfaceIdiom: .phone),
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .regular),
            .init(displayScale: 2),
            .init(displayGamut: .P3),
            .init(userInterfaceStyle: style)
        ]))
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone8(style: .light)
    
    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }
    
    override var safeAreaInsets: UIEdgeInsets {
        return configuration.safeAreaInsets
    }
    
    override var traitCollection: UITraitCollection {
        return UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
    }
    
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}
