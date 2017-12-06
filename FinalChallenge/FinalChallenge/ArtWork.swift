//
//  ArtWork.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 15/09/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import Foundation
import UIKit

class ArtWork: NSObject {
    
    var title: String!
    var descricao: String!
    var urlPhotos: [String] = []
    var images: [UIImage?] = [nil,nil,nil]
    var value: Double!
    var height: Double!
    var width: Double!
    var category: String!
    var id: String!
    var totalLikes: Int!
    var creatorName: String!
    var currentImage: UIImage?
    
    
   // var
    override init() {
        
    }
    
    
    init(dict: [String: Any]) {
        print(dict)
        self.title = dict["title"] as! String
        self.descricao = dict["description"] as! String
        if let pictures = dict["pictures"] as? [String] {
            self.urlPhotos =  pictures
        }
        
        if let value = dict["value"] as? Double {
            self.value = Double(value)
        }
        let value = dict["value"] as? NSNumber
  //      let height = dict["height"] as? NSNumber
     //   self.height = Double(height)
    }
}
