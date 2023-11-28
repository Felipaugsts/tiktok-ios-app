//
//  VideosCollectionViewCell.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 27/11/23.
//

import UIKit
import AVFoundation

protocol VideoCollectionViewCellProtocol: AnyObject {
    func handleDoublePress(index: IndexPath, id: Int)
    func didSwipeLeft(index: IndexPath)
}

class VideoCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "videoCollectionViewCell"
    
    var videoPlayer = LoopedVideoPlayerView()
    var videoModel: HomePlayerModel.Look?
    
    weak var delegate: VideoCollectionViewCellProtocol?
    
    // MARK: - Components
    
    var pausedIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "play")
        icon.tintColor = .white
        return icon
    }()
    
    var likedIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "heart.fill")
        icon.tintColor = .red // Change the color to red
        icon.isHidden = true
        return icon
    }()
    
    var likesCount: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "heart")
        icon.tintColor = .white // Change the color to red
        return icon
    }()
    
    var likesCountValue: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        return label
    }()
    
    lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    var isVisible = false {
        didSet {
            if isVisible {
                videoPlayer.restartPlayer()
                pausedIcon.isHidden = true
            } else {
                videoPlayer.pause()
                pausedIcon.isHidden = false
            }
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        configureTap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - Public Method
    
    func configureVideoCell(with model: HomePlayerModel.Look, delegate: VideoCollectionViewCellProtocol?) {
        self.delegate = delegate
        videoModel = model
        configureVideo(with: model)
        configureProfileImage(model: model)
        
        configureLayout()
        setLikedPost()
    }
    
    func configureLayout() {
        contentView.addSubview(pausedIcon)
        pausedIcon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        pausedIcon.center = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
        
        contentView.addSubview(likedIcon)
        likedIcon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        likedIcon.center = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
        
        contentView.addSubview(avatarImage)
        avatarImage.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        avatarImage.frame.origin = CGPoint(x: 30, y: 30)
        
        contentView.addSubview(likesCount)
        likesCount.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        likesCount.frame.origin = CGPoint(x: 15, y: self.frame.height / 2 - 20)
        
        contentView.addSubview(likesCountValue)
        likesCountValue.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        likesCountValue.frame.origin = CGPoint(x: 20, y: self.frame.height / 2 + 10)
        
        likesCountValue.text = String(videoModel?.likesCount ?? 0)
    }
    
    func pausePlay() {
        videoPlayer.pauseOrPlay(paused: &pausedIcon.isHidden)
    }
    
    func setIsVisible(_ visible: Bool) {
        isVisible = visible
    }
    
    // MARK: - Private Method
    
    private func configureVideo(with model: HomePlayerModel.Look) {
        guard let url = URL(string: model.compressedForIOSURL) else { return }
        contentView.addSubview(videoPlayer)
        videoPlayer.frame = contentView.bounds
        videoPlayer.prepareVideo(url)
        videoPlayer.playAudioFromURL(audioURL: model.songURL)
    }
    
    private func configureTap() {
        swipeLeft()
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    private func swipeLeft() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeftGesture.direction = .left
        contentView.addGestureRecognizer(swipeLeftGesture)
    }
    
    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            guard let index = getIndexPath() else { return }
            delegate?.didSwipeLeft(index: index)
            videoPlayer.pause()
            pausedIcon.isHidden = false
        }
    }
    
    // MARK: - Handle Actions
    
    @objc
    func handleSingleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            videoPlayer.pauseOrPlay(paused: &pausedIcon.isHidden)
        }
    }
    
    @objc
    func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let index = getIndexPath()
            
            delegate?.handleDoublePress(index: index!, id: videoModel?.id ?? 0)
        }
    }
    
    func didLikePost() {
        guard let likesCountText = likesCountValue.text,
              var likes = Int(likesCountText) else {
            return
        }
        
        if videoModel?.liked ?? false {
            likes -= 1
            likesCountValue.text = String(likes)
            videoModel?.liked = false
            setLikedPost()
            return
        }
        
        // This should come from backend after POST and reload collectionView
        likes += 1
        videoModel?.liked = true
        
        
        likedIcon.isHidden = false
        likesCountValue.text = String(likes)
        setLikedPost()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.likedIcon.isHidden = true
        }
    }
    
    func setLikedPost() {
        if videoModel?.liked ?? false {
            likesCount.image = UIImage(systemName: "heart.fill")
            likesCount.tintColor = .red
            return
        }
        
        likesCount.image = UIImage(systemName: "heart")
        likesCount.tintColor = .white
    }
    
    func getIndexPath() -> IndexPath? {
        // Check if the cell belongs to a collection view
        guard let collectionView = superview as? UICollectionView else {
            return nil
        }
        
        // Get the index path of the cell
        let indexPath = collectionView.indexPath(for: self)
        return indexPath
    }
    
    // MARK: - Configure Image Profile
    
    func configureProfileImage(model: HomePlayerModel.Look) {
        getImageFromURL(model.profilePictureURL) { image in
            DispatchQueue.main.async {
                self.avatarImage.image = image
                self.avatarImage.makeRounded()
            }
        }
    }
    
    func getImageFromURL(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image from URL: \(error)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}
