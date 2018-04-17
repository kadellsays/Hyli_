//
//  Connectivity.swift
//  HyLi
//
//  Created by Kadell on 1/29/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    static func isConnectedToInternet() -> Bool {
        guard let networkReachabilityManager = NetworkReachabilityManager() else {return false}
        return networkReachabilityManager.isReachable
    }
    
}
