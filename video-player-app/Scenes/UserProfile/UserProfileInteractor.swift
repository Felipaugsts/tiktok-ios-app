//
//  UserProfileInteractor.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 28/11/23.
//  Copyright (c) 2023 Stockbit - ARI MUNANDAR. All rights reserved.

import UIKit

// MARK: - UserProfileInteractor Protocol

protocol UserProfileInteractorProtocol: AnyObject {
    var presenter: UserProfilePresenterProtocol? { get set }
    
    func loadScreenValues()
}

// MARK: - UserProfileInteractor Implementation

class UserProfileInteractor: UserProfileInteractorProtocol {
    weak var presenter: UserProfilePresenterProtocol?

    // MARK: - Initializer
    
    init() { }
    
    // MARK: - Public Methods
    
    func loadScreenValues() {
        presenter?.presentScreenValues()
    }
}
