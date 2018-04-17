//
//  RecommendButton.swift
//  HyLi
//
//  Created by Kadell on 3/22/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import UIKit

class RecommendButton: UIView {

    @IBInspectable var fillColor: UIColor = UIColor(red: 181.0/255.0, green: 116.0/255.0, blue: 238.0/255.0, alpha: 0.5)
    
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
    }

}
