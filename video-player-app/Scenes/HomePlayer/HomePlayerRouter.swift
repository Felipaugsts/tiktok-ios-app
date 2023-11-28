//
//  HomePlayerRouter.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 27/11/23.
//  Copyright (c) 2023 Stockbit 

import UIKit

// MARK: - HomePlayerRouter Protocol

protocol HomePlayerRouterProtocol: AnyObject {
    var controller: UIViewController? { get set }
    
    func routeToUserProfile()
}

// MARK: - HomePlayerRouter Implementation

class HomePlayerRouter: HomePlayerRouterProtocol {
    weak var controller: UIViewController?

    // MARK: - Initializer
    
    init() { }
    
    func routeToUserProfile() {
        let destination = UserProfileViewController()
        controller?.navigationController?.pushViewController(destination, animated: true)
    }
}
