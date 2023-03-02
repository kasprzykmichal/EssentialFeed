//
//  FeedUIIntegrationTests.swift
//  EssentialFeediOSTests
//
//  Created by Michał Kasprzyk on 21/12/2022.
//

import XCTest
import UIKit
import EssentialFeed
import EssentialFeediOS
import EssentialApp
import Combine

class FeedUIIntegrationTests: XCTestCase {
    func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, feedTitle)
    }
    
    func test_loadFeedAction_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiaderReload()
        XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected no request until previous completes")
        
        loader.completeFeedLoading(at: 0)
        sut.simulateUserInitiaderReload()
        XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected another loading request once user initiates a load")
    
        loader.completeFeedLoading(at: 1)
        sut.simulateUserInitiaderReload()
        XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected a third loading request once user initiates a load")
    }

    func test_loadMoreActions_requestMoreFromLoader() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(at: 0)
        
        XCTAssertEqual(loader.loadMoreCallCount, 0, "Expected no requests until load more action")

        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1, "Expected one load more request")
        
        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1, "Expected no request while loading more")
        
        loader.completeLoadMore(lastPage: false, at: 0)
        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 2, "Expected request after load more completed with more pages")

        loader.completeLoadMoreWithError(at: 1)
        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 3, "Expected request after load more failure")

        loader.completeLoadMore(lastPage: true, at: 2)
        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 3, "Expected no request after loading all pages")
    }

    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "Expected loading indicator once view is loaded")

        loader.completeFeedLoading(at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "Expected no loading indicator once loading is completes sucessfuly")

        sut.simulateUserInitiaderReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "Expected loading indicator once user initiates a reload")

        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadingMoreIndicator_isVisibleWhileLoadingMore() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once view is loaded")

        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateLoadMoreFeedAction()
        XCTAssertTrue(sut.isShowingLoadMoreFeedIndicator, "Expected loading indicator on load more action")

        loader.completeLoadMore(at: 0)
        XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator loading completes successfully")
        
        sut.simulateLoadMoreFeedAction()
        XCTAssertTrue(sut.isShowingLoadMoreFeedIndicator, "Expected loading indicator on second load more action")
        
        loader.completeLoadMoreWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator loading completes with error")
    }

    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let image0 = makeImage(description: "a decription", location: "a location")
        let image1 = makeImage(description: nil, location: "another location")
        let image2 = makeImage(description: "another decription", location: nil)
        let image3 = makeImage(description: nil, location: nil)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeFeedLoading(with: [image0, image1], at: 0)
        assertThat(sut, isRendering: [image0, image1])
        
        sut.simulateLoadMoreFeedAction()
        loader.completeLoadMore(with: [image0, image1, image2, image3], at: 0)
        assertThat(sut, isRendering: [image0, image1, image2, image3])
        
        sut.simulateUserInitiaderReload()
        loader.completeFeedLoading(with: [image0, image1], at: 1)
        assertThat(sut, isRendering: [image0, image1])
    }

    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeImage()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiaderReload()
        loader.completeFeedLoadingWithError(at: 1)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateLoadMoreFeedAction()
        loader.completeLoadMoreWithError(at: 0)
        assertThat(sut, isRendering: [image0])
    }

    func test_feedImageView_loadsImageURLWhenVisible() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0, image1], at: 0)
        
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until view becomes visible")
        
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url], "Expected first image URL request once first view becomes visible")

        sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected first image URL request once first view becomes visible")
    }

    func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0, image1], at: 0)
        
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no image URL requests until view becomes visible")
        
        sut.simulateFeedImageViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url], "Expected first image URL request once first view becomes visible")

        sut.simulateFeedImageViewNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url, image1.url], "Expected first image URL request once first view becomes visible")
    }

    func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [makeImage(), makeImage()], at: 0)
        
        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second view while loading second image")
        
        loader.completeImageLoading(at: 0)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfuly")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfuly")

        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")
    }

    func test_feedImageView_rendersImageLoadedFromURL() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [makeImage(), makeImage()], at: 0)
        
        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading second image")
        
        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for first view once first image loading completessuccessfully")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image state change for second view once first image loadingcompletes successfully")
        
        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected no image state change for first view once second imageloading completes successfully")
        XCTAssertEqual(view1?.renderedImage, imageData1, "Expected image for second view once second image loading completes successfully")
    }

    func test_feedImageViewRetryButton_isVisibleOnImageURLLoadError() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [makeImage(), makeImage()], at: 0)
        
        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view while loading first image")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no no retry action for second view while loading second image")
        
        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action state change for second view once first image loading completes successfully")

        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingRetryAction, true, "Expected retry action for second view once second image loading completes with error")
    }

    func test_feedImageRetryButton_isVisibleOnInvalidImageData() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [makeImage()], at: 0)
        
        let view = sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(view?.isShowingRetryAction, false, "Expected no retry action while loading image")
        
        let invalidImageData = Data("invalid image data".utf8)
        loader.completeImageLoading(with: invalidImageData, at: 0)
        XCTAssertEqual(view?.isShowingRetryAction, true, "Expected retry action once image loading completes with invalid image data")
    }

    func test_feedImageViewRetryAction_retriesImageLoad() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0, image1], at: 0)
        
        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected two image URL request for the two visible views")
        
        loader.completeImageLoadingWithError(at: 0)
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected only two image URL request before retry action")
        
        view0?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url, image0.url], "Expected third imageURL request after first view retry action")
        
        view1?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url, image0.url, image1.url], "Expected fourth imageURL request after second view retry action")
    }

    func test_feedImageView_preloadsImageURLWhenNearVisible() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0, image1], at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until image is near visible")
        
        sut.simulateFeedImageViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url], "Expected first image URL request once first image is near visible")
        
        sut.simulateFeedImageViewNearVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected second image URL request once second image is near visible")
    }

    func test_feedImageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0, image1], at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no cancelled image URL requests until image is not near visible")
        
        sut.simulateFeedImageViewNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url], "Expected first cancelled image URL request once first image is not near visible anymore")

        sut.simulateFeedImageViewNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url, image1.url], "Expected second cancelled image URL request once second image is not near visible anymore")
    }

    func test_feedImageView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [makeImage()], at: 0)
        
        let view = sut.simulateFeedImageViewNotVisible(at: 0)
        loader.completeImageLoading(with: anyFeedImageData(), at: 0)
        
        XCTAssertNil(view?.renderedImage, "Expected no rendered image when an image load finishes after the view is not visible anymore")
    }

    func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeFeedLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_loadImageDataCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [makeImage()], at: 0)
        _ = sut.simulateFeedImageViewVisible(at: 0)
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(with: self.anyFeedImageData(), at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadMoreCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(at: 0)
        sut.simulateLoadMoreFeedAction()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeLoadMore()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_errorView_doesNotRenderErrorOnLoad() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.errorMessage, nil)
    }

    func test_loadFeedCompletion_rendersErrorMessageOnError() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeFeedLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
    }

    func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeFeedLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)

        sut.simulateUserInitiaderReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }

    func test_loadMoreCompletion_rendersErrorMessageOnError() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(at: 0)
        sut.simulateLoadMoreFeedAction()
        
        XCTAssertEqual(sut.loadMoreErrorMessage, nil)

        loader.completeLoadMoreWithError(at: 0)
        XCTAssertEqual(sut.loadMoreErrorMessage, loadError)

        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(sut.loadMoreErrorMessage, nil)
    }

    func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeFeedLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)

        sut.simulateErrorViewTap()
        XCTAssertEqual(sut.errorMessage, nil)
    }

    func test_tapOnLoadMoreErrorView_loadsMore() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(at: 0)
        
        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1)

        sut.simulateTapOnLoadMoreFeedError()
        XCTAssertEqual(loader.loadMoreCallCount, 1)
        
        loader.completeLoadMoreWithError(at: 0)

        sut.simulateTapOnLoadMoreFeedError()
        XCTAssertEqual(loader.loadMoreCallCount, 2)
    }

    func test_loadFeedCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
        let image0 = makeImage()
        let image1 = makeImage()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateLoadMoreFeedAction()
        loader.completeLoadMore(with: [image0, image1], at: 0)
        assertThat(sut, isRendering: [image0, image1])

        sut.simulateUserInitiaderReload()
        loader.completeFeedLoading(with: [], at: 1)
        assertThat(sut, isRendering: [])
    }

    func test_imageSelection_notifiesHandler() {
        let image0 = makeImage()
        let image1 = makeImage()
        var selectedImages = [FeedImage]()
        let (sut, loader) = makeSUT(selection: { selectedImages.append($0) })

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0, image1], at: 0)
        assertThat(sut, isRendering: [image0, image1])

        XCTAssertEqual(selectedImages, [])
        
        sut.simulateTapOnFeedImage(at: 0)
        XCTAssertEqual(selectedImages, [image0])
        
        sut.simulateTapOnFeedImage(at: 1)
        XCTAssertEqual(selectedImages, [image0, image1])
    }

    func test_feedImageView_doesNotLoadImageAgainUntilPreviousRequestCompletes() {
        let image = makeImage(url: URL(string: "http://url-0.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image], at: 0)
        sut.simulateFeedImageViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image.url], "Expected first request when near visible")
        
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image.url], "Expected no request until previous completes")
        
        loader.completeImageLoading(at: 0)
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image.url, image.url], "Expected second request when visible after previous complete")
    
        sut.simulateFeedImageViewNotVisible(at: 0)
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image.url, image.url, image.url], "Expected third request when visible after cancelling previous request")
        
        sut.simulateLoadMoreFeedAction()
        loader.completeLoadMore(with: [image, makeImage()])
        
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image.url, image.url, image.url], "Expected no request until previous completes")
    }
    
    // MARK: - Helpers

    private func makeSUT(selection: @escaping (FeedImage) -> Void = { _ in }, file: StaticString = #file, line: UInt = #line) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedUIComposer.feedComposedWith(feedLoader: loader.loadPublisher, imageLoader: loader.loadImageDataPublisher, selection: selection)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    private func assertThat(_ sut: ListViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        sut.tableView.layoutIfNeeded()
        executeRunLoopToCleanUpReferences()
        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }
        
        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
        executeRunLoopToCleanUpReferences()
    }

    private func assertThat(_ sut: ListViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)
        
        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisible = (image.location != nil)
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected 'isShowingLocation' to be \(shouldLocationBeVisible) for image view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.locationText, image.location, "Expected location text to be \(String(describing: image.location)) for image view at index (\(index))", file: file, line: line)
    
        XCTAssertEqual(cell.descriptionText, image.description, "Expected description text to be \(String(describing: image.location)) for image view at index (\(index))", file: file, line: line)
    }

    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }

    private func anyFeedImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }

    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}

extension ListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        tableView.frame = .init(x: 0, y: 0, width: 1, height: 1)
    }
    
    func simulateUserInitiaderReload() {
        refreshControl?.simulatePullToRefresh()
    }

    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }

    func simulateErrorViewTap() {
        errorView.simulateTap()
    }

    func simulateTapOnLoadMoreFeedError() {
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }

    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }

    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImage
    }
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        return view
    }

    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    func simulateLoadMoreFeedAction() {
        guard let view = cell(row: 0, section: feedLoadMoreSection) else { return }
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, willDisplay: view, forRowAt: index)
    }

    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }

    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else { return nil }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

    var isShowingLoadMoreFeedIndicator: Bool {
        let view = cell(row: 0, section: feedLoadMoreSection) as? LoadMoreCell
        return view?.isLoading == true
    }

    func numberOfRenderedFeedImageViews() -> Int {
        tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: feedImageSection)
    }

    func numberOfRenderedComments() -> Int {
        tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: commentsSection)
    }

    func feedImageView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedFeedImageViews() > row else {
            return nil
        }
        
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImageSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    func commentMessage(at row: Int) -> String? {
        commentView(at: row)?.messageLabel.text
    }

    func commentDate(at row: Int) -> String? {
        commentView(at: row)?.dateLabel.text
    }

    func commentUsername(at row: Int) -> String? {
        commentView(at: row)?.usernameLabel.text
    }

    private func commentView(at row: Int) -> ImageCommentCell? {
        guard numberOfRenderedComments() > row else {
            return nil
        }
        
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: commentsSection)
        return ds?.tableView(tableView, cellForRowAt: index) as? ImageCommentCell
    }
    
    private var feedImageSection: Int {
        return 0
    }

    private var feedLoadMoreSection: Int {
        return 1
    }

    private var commentsSection: Int {
        return 0
    }

    var errorMessage: String? {
        return errorView.message
    }

    var loadMoreErrorMessage: String? {
        return loadMoreFeedCell()?.message
    }

    private func loadMoreFeedCell() -> LoadMoreCell? {
        let view = cell(row: 0, section: feedLoadMoreSection) as? LoadMoreCell
        return view
    }

    var canLoadMoreFeed: Bool {
        return loadMoreFeedCell() != nil
    }
}

extension FeedImageCell {
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }

    var isShowingImageLoadingIndicator: Bool {
        return feedImageContainer.isShimmering
    }

    var isShowingRetryAction: Bool {
        return !feedImageRetryButton.isHidden
    }
    
    var locationText: String? {
        return locationLabel.text
    }

    var descriptionText: String? {
        return descriptionLabel.text
    }

    var renderedImage: Data? {
        return feedImageView.image?.pngData()
    }

    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
}
private extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
