//
//  LayerView.swift
//  HyLi
//
//  Created by Kadell on 3/19/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import UIKit

@IBDesignable class LayerView: UIView {
    
    private struct Constants {
        static let numberOfGlasses = 5
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    @IBInspectable var counterColor: UIColor = UIColor(red: 181.0/255.0, green: 116.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    
    
   
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let startAngle: CGFloat = .pi / 2
        let endAngle: CGFloat = .pi / 2 - 0.0000000000001
     
        
        
        let path = UIBezierPath(arcCenter: center,
                                radius: bounds.width/2.5,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        path.lineWidth = 2.0
        counterColor.setStroke()
        path.stroke()
        
    }


}
