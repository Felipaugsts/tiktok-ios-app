//
//  HomePlayerWorker.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 27/11/23.
//

import Foundation

protocol HomePlayerWorkerProtocol {
    func readLocalJSONFile(forName name: String) -> HomePlayerModel.LooksData?
    func likePost(index: IndexPath, id: Int, completion: @escaping (Bool) -> Void)
}

class HomePlayerWorker: HomePlayerWorkerProtocol {
    
    func readLocalJSONFile(forName name: String) -> HomePlayerModel.LooksData? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return decodeVideoData(with: data)
            }
        } catch {
            print("Error reading JSON file:", error.localizedDescription)
        }
        return nil
    }
    
    func likePost(index: IndexPath, id: Int, completion: @escaping (Bool) -> Void) {
        guard var videos = readLocalJSONFile(forName: "data") else {
            completion(false)
            return
        }
        
        if let postIndex = videos.looks.firstIndex(where: { $0.id == id }) {
            if !videos.looks[postIndex].liked {
                videos.looks[postIndex].liked = true
                videos.looks[postIndex].likesCount += 1
                
                do {
                    let updatedJsonData = try JSONEncoder().encode(videos)
                    try updatedJsonData.write(to: fileURLForDataJSON())
                    
                    print("Updated JSON data saved to Documents directory.")
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            } else {
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    private func decodeVideoData(with data: Data) -> HomePlayerModel.LooksData? {
        do {
            let decoder = JSONDecoder()
            let videos = try decoder.decode(HomePlayerModel.LooksData.self, from: data)
            return videos
        } catch {
            print("Error decoding JSON:", error.localizedDescription)
            return nil
        }
    }
    
    private func fileURLForDataJSON() -> URL {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentsDirectory.appendingPathComponent("data.json")
        }
        fatalError("Unable to access Documents directory.")
    }
}
