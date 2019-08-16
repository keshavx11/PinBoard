//
//  Pin.swift
//  PinBoard
//
//  Created by Keshav Bansal on 12/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import UIKit

class Pin: Codable {
    
    var id: String?
    var user: PinUser?
    var likes: Int = 0
    var width: Int = 0
    var height: Int = 0
    var color: String?
    var urls: PinURLs?
    
    func getImageSize() -> CGSize {
        return CGSize(width: self.width, height: self.height)
    }
}

class PinURLs: Codable {
    var raw: String?
    var full: String?
    var regular: String?
    var small: String?
}

class PinUser: Codable {
    var name: String?
}
