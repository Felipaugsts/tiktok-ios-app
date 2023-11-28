//
//  HomePlayerPresenter.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 27/11/23.
//  Copyright (c) 2023 Stockbit 

import UIKit

// MARK: - HomePlayerPresenter Protocol

protocol HomePlayerPresenterProtocol: AnyObject {
    var controller: HomePlayerViewControllerProtocol? { get set }
    
    func presentScreenValues(with model: [HomePlayerModel.Look])
    func presentLiked(index: IndexPath, id: Int)
    func presentProfile()
}

// MARK: - HomePlayerPresenter Implementation

class HomePlayerPresenter: HomePlayerPresenterProtocol {
    weak var controller: HomePlayerViewControllerProtocol?

    // MARK: - Initializer
    
    init() { }
    
    // MARK: - Public Methods
    
    func presentScreenValues(with model: [HomePlayerModel.Look]) {
        let values = HomePlayerModel.ScreenValues(videos: model)
        controller?.displayScreenValues(values)
    }
    
    func presentLiked(index: IndexPath, id: Int) {
        controller?.displayLiked(index: index, id: id)
    }
    
    func presentProfile() {
        controller?.displayProfile()
    }
}
