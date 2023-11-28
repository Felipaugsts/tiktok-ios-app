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

protocol HomePlayerDataPassing: AnyObject {
    var dataStore: HomePlayerDataStore? { get set}
}

// MARK: - HomePlayerRouter Implementation

class HomePlayerRouter: NSObject, HomePlayerRouterProtocol, HomePlayerDataPassing {
    weak var controller: UIViewController?
    var dataStore: HomePlayerDataStore?
    // MARK: - Initializer
    
    override init() { }
    
    func routeToUserProfile() {
        let destination = UserProfileViewController()
        var destinationDS = destination.router.dataStore
        passDataToProfile(dataStore: dataStore, destinationDS: &destinationDS)
        controller?.navigationController?.pushViewController(destination, animated: true)
    }
    
    private func passDataToProfile(dataStore: HomePlayerDataStore?, destinationDS: inout UserProfileDataStore?) {
        destinationDS?.userSelected = dataStore?.userSelected
    }
}
