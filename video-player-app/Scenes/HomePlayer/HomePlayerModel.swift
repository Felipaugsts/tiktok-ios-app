//
//  HomePlayerModel.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 27/11/23.
//  Copyright (c) 2023 Stockbit

import UIKit

// MARK: - HomePlayerModel

enum HomePlayerModel {
	struct ScreenValues {
        var videos: [HomePlayerModel.Look]
	}
    
    struct Look: Codable {
        var id: Int
        var songURL: String
        var body: String
        var profilePictureURL: String
        var username: String
        var compressedForIOSURL: String
        var likesCount: Int
        var liked: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case songURL = "song_url"
            case body
            case profilePictureURL = "profile_picture_url"
            case username
            case compressedForIOSURL = "compressed_for_ios_url"
            case likesCount
            case liked

        }
    }

    struct LooksData: Codable {
        var looks: [Look]
    }

}
