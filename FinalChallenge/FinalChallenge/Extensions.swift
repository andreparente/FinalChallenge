//
//  Extensions.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


extension UIColor {
    
    class var customLightBlue: UIColor {
        return UIColor(red: 98 / 255.0, green: 240 / 255.0, blue: 233 / 255.0, alpha: 1.0)
    }
    
    class var customLightPink: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 164.0 / 255.0, blue: 193.0 / 255, alpha: 1.0)
    }
}


extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0,y: 0,width: self.frame.height,height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

extension UILabel {
    
    func makeHorizontal() {
        var count = 0
        var chars: [String] = []
        print("width original :: ",  (self.text?.width(withConstraintedHeight: 0, font: self.font))!)
        print("height original :: ",  (self.text?.height(withConstrainedWidth: 0, font: self.font))!)
        
        self.frame.size.height = (self.text?.width(withConstraintedHeight: 0, font: self.font))!
        self.frame.size.width  = (self.text?.height(withConstrainedWidth: 0, font: self.font))!
        
        print(self.frame.size.height)
        for index in (self.text?.characters.indices)! {
            count += 1
            chars.append((self.text?[(self.text?.index(index, offsetBy: 0))!...(self.text?.index(index, offsetBy: 0))!])!)
        }
        //        self.frame.size.height = (CGFloat(Int(self.frame.size.height) * count))/3
        self.numberOfLines = chars.count
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .center
        print(chars)
        self.text = chars.joined(separator: "\n")
        self.frame.size.height = (self.text?.height(withConstrainedWidth: 0, font: self.font))!
        print(self.text)
    }
}
