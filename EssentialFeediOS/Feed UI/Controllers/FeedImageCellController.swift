//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Michał Kasprzyk on 22/12/2022.
//

import UIKit

final class FeedImageCellController {
    private let viewModel: FeedImageViewModel<UIImage>
    private var cell: FeedImageCell?

    init(viewModel: FeedImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = binded(tableView.dequeueReusableCell())
        viewModel.loadImageData()
        return cell!
    }

    func preload() {
        viewModel.loadImageData()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        viewModel.cancelImageDataLoad()
    }

    private func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.onRetry = viewModel.loadImageData
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }
    
        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.feedImageContainer.isShimmering = isLoading
        }
    
        viewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
            cell?.feedImageRetryButton.isHidden = !shouldRetry
        }
    
        return cell
    }

    private func releaseCellForReuse() {
        viewModel.onImageLoad = nil
        viewModel.onImageLoadingStateChange = nil
        viewModel.onShouldRetryImageLoadStateChange = nil
        cell = nil
    }
}
