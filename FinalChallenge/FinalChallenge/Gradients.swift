//
//  Gradients.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 28/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import Foundation
import UIKit

class Gradient {
    
    //singleton
    static let sharedInstance = Gradient()
    
    private init() {}
    
    func bluePinkGradient(view: UIView, vertical: Bool) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor.customLightBlue.cgColor, UIColor.customLightPink.cgColor]
        if vertical {
            gradient.startPoint = CGPoint(x: 1,y: 0)
            gradient.endPoint = CGPoint(x: 0,y: 1)
        } else {
            gradient.startPoint = CGPoint(x: 0,y: 0.5)
            gradient.endPoint = CGPoint(x: 1,y: 0.5)
        }
        
        
        return gradient
    }
    
//    func bluePinkGradient(view: UIView, vertical: Bool) -> CAGradientLayer {
//        let gradient = CAGradientLayer()
//        
//        gradient.frame = view.bounds
//        gradient.colors = [UIColor.customLightBlue.cgColor,UIColor.black.cgColor, UIColor.customLightPink.cgColor]
//        
//        if vertical {
//            gradient.startPoint = CGPoint(x: 0.5,y: 0)
//            gradient.endPoint = CGPoint(x: 0.5,y: 1)
//        } else {
//            gradient.startPoint = CGPoint(x: 0,y: 0.5)
//            gradient.endPoint = CGPoint(x: 1,y: 0.5)
//        }
//        
//        
//        return gradient
//    }
}
