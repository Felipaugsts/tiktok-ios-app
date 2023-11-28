//
//  UserProfileRouter.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 28/11/23.
//  Copyright (c) 2023 Stockbit - ARI MUNANDAR. All rights reserved.

import UIKit

// MARK: - UserProfileRouter Protocol

protocol UserProfileRouterProtocol: AnyObject {
    var controller: UIViewController? { get set }
    
    func goToPlayerView()
}

protocol UserProfileDataPassing: AnyObject {
    var dataStore: UserProfileDataStore? { get set}
}
// MARK: - UserProfileRouter Implementation

class UserProfileRouter: NSObject, UserProfileRouterProtocol, UserProfileDataPassing {
    weak var controller: UIViewController?

    var dataStore: UserProfileDataStore?
    
    // MARK: - Initializer
    
    override init() { }
    
    func goToPlayerView() {
        controller?.navigationController?.popViewController(animated: true)
    }
}
