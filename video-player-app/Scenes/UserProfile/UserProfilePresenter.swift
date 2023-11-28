//
//  UserProfilePresenter.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 28/11/23.
//  Copyright (c) 2023 Stockbit - ARI MUNANDAR. All rights reserved.

import UIKit

// MARK: - UserProfilePresenter Protocol

protocol UserProfilePresenterProtocol: AnyObject {
    var controller: UserProfileViewControllerProtocol? { get set }
    
    func presentScreenValues(with user: HomePlayerModel.User?)
}

// MARK: - UserProfilePresenter Implementation

class UserProfilePresenter: UserProfilePresenterProtocol {
    weak var controller: UserProfileViewControllerProtocol?

    // MARK: - Initializer
    
    init() { }
    
    // MARK: - Public Methods
    
    func presentScreenValues(with user: HomePlayerModel.User?) {
        if let username = user?.username {
            let values = UserProfileModel.ScreenValues(example: "User Profile, \(username)")
            controller?.displayScreenValues(values)
        }
    }
}
