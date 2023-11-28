//
//  HomePlayerViewController.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 27/11/23.
//  Copyright (c) 2023 Stockbit 

import UIKit

// MARK: - IHomePlayerViewController

protocol HomePlayerViewControllerProtocol: AnyObject {
    func displayScreenValues(_ values: HomePlayerModel.ScreenValues)
    func displayLiked(index: IndexPath, id: Int)
    func displayProfile()
}

class HomePlayerViewController: UIViewController {
    
    // MARK: - Components
    
    override var prefersStatusBarHidden: Bool { return true }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        collection.backgroundColor = .black
        return collection
    }()
    
    // MARK: - Data
    
    var data: [HomePlayerModel.Look] = []
    
    // MARK: - Variables
    
    var visibleIndexPaths = [IndexPath]()
    var interactor: (HomePlayerInteractorProtocol & HomePlayerDataStore)
    var router: (NSObjectProtocol & HomePlayerRouterProtocol & HomePlayerDataPassing)
    var presenter: HomePlayerPresenterProtocol
    
    // MARK: - Initializer
    
    init(interactor: (HomePlayerInteractorProtocol & HomePlayerDataStore) = HomePlayerInteractor(),
         presenter: HomePlayerPresenterProtocol = HomePlayerPresenter(),
         router: (NSObjectProtocol & HomePlayerRouterProtocol & HomePlayerDataPassing) = HomePlayerRouter()) {
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        interactor.loadScreenValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    // MARK: - Private Methods
    
    private func setup() {
        interactor.presenter = presenter
        presenter.controller = self
        router.controller = self
        router.dataStore = interactor
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
}

// MARK: Protocol Implementation

extension HomePlayerViewController: HomePlayerViewControllerProtocol {
    
    func displayScreenValues(_ values: HomePlayerModel.ScreenValues) {
        data = values.videos
        collectionView.reloadData()
    }
    
    func displayLiked(index: IndexPath, id: Int) {
        guard let cell = collectionView.cellForItem(at: index) as? VideoCollectionViewCell,
        cell.videoModel?.id == id else { return }
        
        cell.didLikePost()
    }
}

// MARK: - Collection Delegate

extension HomePlayerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for:  indexPath) as? VideoCollectionViewCell else { return UICollectionViewCell() }
        
        let videoModel = data[indexPath.row]
        cell.configureVideoCell(with: videoModel, delegate: self)
        
        return cell
    }
    
    // MARK: - Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        for cell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: cell) {
                let cellRect = collectionView.layoutAttributesForItem(at: indexPath)?.frame ?? CGRect.zero
                let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
                
                let intersectRect = cellRect.intersection(visibleRect)
                let halfCellHeight = cellRect.size.height / 2.0
                let isAtLeastHalfVisible = intersectRect.height >= halfCellHeight
                
                if let videoCell = cell as? VideoCollectionViewCell {
                    videoCell.setIsVisible(isAtLeastHalfVisible)
                }
            }
        }
    }
}

extension HomePlayerViewController: VideoCollectionViewCellProtocol {
    func handleDoublePress(index: IndexPath, id: Int) {
        interactor.didLikePost(index: index, id: id)
    }
    
    func didSwipeLeft(index: IndexPath) {
        let cell = data[index.row]

        interactor.openUserProfile(with: cell)
    }
    
    func displayProfile() {
        router.routeToUserProfile()
    }
}
