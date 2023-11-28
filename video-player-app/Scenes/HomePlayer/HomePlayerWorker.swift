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
     // POST ON BACKEND
        completion(true)
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
