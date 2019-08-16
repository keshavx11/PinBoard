//
//  CacheHelper.swift
//  PinBoard
//
//  Created by Keshav Bansal on 17/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import UIKit
import KBCachier

class CacheHelper {
    
    class func configureCachier() {
        
        // Max cache size 10 MB
        Cachier.shared.isInMemoryCacheEnabled = true
        Cachier.shared.maxCacheSize = 10485760
        
        // Set log level
        Cachier.shared.logLevel = .warning
        
        // Set dispatchQueue for making api calls
        Cachier.shared.dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        
    }
    
}
