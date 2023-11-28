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

// MARK: - UserProfileRouter Implementation

class UserProfileRouter: UserProfileRouterProtocol {
    weak var controller: UIViewController?

    // MARK: - Initializer
    
    init() { }
    
    func goToPlayerView() {
        controller?.navigationController?.popViewController(animated: true)
    }
}
