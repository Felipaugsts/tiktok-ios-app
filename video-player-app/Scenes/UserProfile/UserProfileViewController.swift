//
//  UserProfileViewController.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 28/11/23.
//  Copyright (c) 2023 Stockbit - ARI MUNANDAR. All rights reserved.

import UIKit

// MARK: - IUserProfileViewController

protocol UserProfileViewControllerProtocol: AnyObject {
    func displayScreenValues(_ values: UserProfileModel.ScreenValues)
}

// MARK: - UserProfileViewController

class UserProfileViewController: UIViewController {
    
    var presenter: UserProfilePresenterProtocol
    var interactor: (UserProfileInteractorProtocol & UserProfileDataStore)
    var router: (NSObjectProtocol & UserProfileRouterProtocol & UserProfileDataPassing)
    
    var userprofileLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(interactor: (UserProfileInteractorProtocol & UserProfileDataStore) = UserProfileInteractor(),
         presenter: UserProfilePresenterProtocol = UserProfilePresenter(),
         router: (NSObjectProtocol & UserProfileRouterProtocol & UserProfileDataPassing) = UserProfileRouter()) {
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        interactor.loadScreenValues()
        
        view.addSubview(userprofileLabel)
        userprofileLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: 50)
        userprofileLabel.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        swipeLeft()
    }
    
    private func setup() {
        interactor.presenter = presenter
        presenter.controller = self
        router.controller = self
        router.dataStore = interactor
    }
    
    private func swipeLeft() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    @objc func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            self.router.goToPlayerView()
        }
    }
}

// MARK: UserProfileViewControllerProtocol Implementation

extension UserProfileViewController: UserProfileViewControllerProtocol {
    
    func displayScreenValues(_ values: UserProfileModel.ScreenValues) {
        userprofileLabel.text = values.example
    }
}
