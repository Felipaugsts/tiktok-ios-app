//
//  HomePlayerInteractor.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 27/11/23.
//  Copyright (c) 2023 Stockbit 

import UIKit

// MARK: - HomePlayerInteractor Protocol

protocol HomePlayerInteractorProtocol: AnyObject {
    var presenter: HomePlayerPresenterProtocol? { get set }
    
    func loadScreenValues()
    func didLikePost(index: IndexPath, id: Int)
}

// MARK: - HomePlayerInteractor Implementation

class HomePlayerInteractor: HomePlayerInteractorProtocol {
    
    var worker: HomePlayerWorkerProtocol
    
    weak var presenter: HomePlayerPresenterProtocol?

    // MARK: - Initializer
    
    init(worker: HomePlayerWorkerProtocol = HomePlayerWorker()) {
        self.worker = worker
    }
    
    // MARK: - Public Methods
    
    func loadScreenValues() {
        
        guard let videos = worker.readLocalJSONFile(forName: "data") else { return }
        
        presenter?.presentScreenValues(with: videos.looks)
    }
    
    func didLikePost(index: IndexPath, id: Int) {
        worker.likePost(index: index, id: id) { didLike in
            if didLike {
                self.presenter?.presentLiked(index: index, id: id)
            }
        }
    }
}
