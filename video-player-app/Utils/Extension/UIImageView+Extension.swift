//
//  UIImageView+Extension.swift
//  video-player-app
//
//  Created by Felipe Augusto Silva on 28/11/23.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
