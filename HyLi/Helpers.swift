//
//  Helpers.swift
//  HyLi
//
//  Created by Kadell on 10/27/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static func finalString(_ str: [String]) -> String {
        var finalStr = ""
        
        for crowd in str {
            finalStr  += " \(crowd)"
        }
        
        return finalStr
    }
    
    
    //MARK: ANIMATIONS
    
    static func shake(_ view: UIView ) {
        
//        UIView.animate(withDuration: 2.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: [.repeat,.autoreverse], animations: {
//            view.center.x += 15
//        }, completion: nil)
    
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3 , options: [.autoreverse], animations: {
            view.center.x += 0
        }) { (success) in
            
        }
    }
    
}

public extension UIView {
    
    func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTranslation translation : Float? = nil) {
        
        // You can change these values, so that you won't have to write a long function
        let defaultRepeatCount = 4
        let defaultTotalDuration = 0.5
        let defaultTranslation = -5
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.repeatCount = count ?? Float(defaultRepeatCount)
        animation.duration = (duration ?? defaultTotalDuration)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? defaultTranslation
        layer.add(animation, forKey: "shake")
        
    }
}
