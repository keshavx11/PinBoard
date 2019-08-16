//
//  Utilities.swift
//  PinBoard
//
//  Created by Keshav Bansal on 14/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import UIKit

extension UIView {

    func addThinShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 6
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
}

extension UIColor {

    class func getColor(fromHexString hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        if hexString.hasPrefix("#") {
            var rgbValue: UInt32 = 0
            let scanner = Scanner(string: hexString)
            scanner.scanLocation = 1
            // bypass '#' character
            scanner.scanHexInt32(&rgbValue)
            return UIColor(red: CGFloat(Double(((Int(rgbValue) & 0xff0000) >> 16)) / 255.0), green: CGFloat(Double(((Int(rgbValue) & 0xff00) >> 8)) / 255.0), blue: CGFloat(Double((Int(rgbValue) & 0xff)) / 255.0), alpha: alpha)
        }
        return UIColor.black
    }
}
