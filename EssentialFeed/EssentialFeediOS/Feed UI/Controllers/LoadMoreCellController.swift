//
//  LoadMoreCellController.swift
//  EssentialFeediOS
//
//  Created by Michał Kasprzyk on 25/02/2023.
//

import UIKit
import EssentialFeed

public class LoadMoreCellController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let cell = LoadMoreCell()
    private let callback: () -> Void
    
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !self.cell.isLoading else { return }
        callback()
    }
}

extension LoadMoreCellController: ResouceLoadingView, ResourceErrorView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        cell.message = viewModel.message
    }
}
