//
//  Extensions.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import Foundation
import UIKit


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
    
    class var vitrineDarkBlue: UIColor {
        return UIColor(red:0.00, green:0.26, blue:0.96, alpha:1.0)
    }
    
    class var vitrineLightBlue: UIColor {
        return UIColor(red:0.47, green:0.58, blue:0.94, alpha:1.0)
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
        print(self.text ?? 0)
    }
}

extension UIImageView: URLSessionDelegate {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let loading = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loading.center = self.center
        loading.color = UIColor.blue
        loading.hidesWhenStopped = true
        loading.activityIndicatorViewStyle = .gray
        loading.startAnimating()
        self.addSubview(loading)
        
        session.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                
                else {
                    DispatchQueue.main.async() { () -> Void in
                        loading.stopAnimating()
                    }
                    return
                }
            DispatchQueue.main.async() { () -> Void in
                loading.stopAnimating()
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            challenge.sender?.use(credential, for: challenge)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        }
    }
}

extension UIImage {
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


extension UIViewController {
    
    func showAlert(title: String, message: String) {
//        let attributedString = NSAttributedString(string: title, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold),NSForegroundColorAttributeName : UIColor])
//        let attributedMessage = NSAttributedString(string: message, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 13),NSForegroundColorAttributeName : UIColor().lightBlue])
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.setValue(attributedString, forKey: "attributedTitle")
//        alert.setValue(attributedMessage, forKey: "attributedMessage")
//        alert.view.tintColor = UIColor().lightBlue
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
