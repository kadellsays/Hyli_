//
//  SideMenuInformation.swift
//  HyLi
//
//  Created by Kadell on 3/1/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import Foundation
import UIKit

class SideMenuLabel {
    
    var name: String!
    var image: UIImage!
    
    init(name:String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    static func sideMenuAll() -> [SideMenuLabel] {
        return [
        SideMenuLabel(name: "STRAIN FINDER", image: UIImage(named: "buttonCircle")!),
        SideMenuLabel(name: "FAVORITES", image: UIImage(named: "Heart")!),
        SideMenuLabel(name: "SETTINGS", image: UIImage(named: "Settings")!)
        ]
    }
    
}
