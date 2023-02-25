//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Michał Kasprzyk on 27/12/2022.
//

import UIKit
import Combine
import CoreData
import EssentialFeed
import EssentialFeedAPI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(storeURL: NSPersistentContainer.defaultDirectoryURL().appendingPathExtension("feed-store.sqlite"))
    }()

    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()

    private lazy var navigationController: UINavigationController = {
        UINavigationController(
            rootViewController: FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback,
            selection: showComments)
        )
    }()

    private lazy var baseURL: URL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func showComments(for image: FeedImage) {
        let url = ImageCommentsEndpoint.get(image.id).url(baseURL: baseURL)
        let comments = CommentsUIComposer.commentsComposedWith(commentsLoader: makeRemoteCommentsLoader(url: url))
        navigationController.pushViewController(comments, animated: true)
    }

    private func makeRemoteCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
        return { [httpClient] in
            return httpClient
                .getPublisher(from: url)
                .tryMap(ImageCommentsMapper.map)
                .eraseToAnyPublisher()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }

    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
        let url = FeedEndpoint.get().url(baseURL: baseURL)
        return httpClient
            .getPublisher(from: url)
            .tryMap(FeedImagesMapper.map)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map { items in
                Paginated(items: items, loadMorePublisher: self.makeRemoteLoadMoreLoader(items: items, last: items.last))
            }
            .eraseToAnyPublisher()
    }

    private func makeRemoteLoadMoreLoader(items: [FeedImage], last: FeedImage?) -> (() -> AnyPublisher<Paginated<FeedImage>, Error>)? {
        return last.map { lastItem in
            let url = FeedEndpoint.get(after: lastItem).url(baseURL: baseURL)
            return { [httpClient, localFeedLoader] in
                httpClient
                    .getPublisher(from: url)
                    .tryMap(FeedImagesMapper.map)
                    .map { newItems in
                        let allItems = items + newItems
                        return Paginated(items: allItems, loadMorePublisher: self.makeRemoteLoadMoreLoader(items: allItems, last: newItems.last))
                    }
                    .caching(to: localFeedLoader)
                    .eraseToAnyPublisher()
            }
        }
    }

    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let localImageLoader = LocalFeedImageDataLoader(store: store)

        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient] in
                httpClient
                    .getPublisher(from: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
            })
    }
}
