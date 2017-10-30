//
//  USER.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import Foundation
import iCarousel

class User {
    
    var name: String!
    var email: String!
    // var obras: [Obra] = []
    var friendsId: [String] = []
    var favoriteArts: [String] = []
    var favoriteArtists: [String] = []
    var id: String!
    var profilePictureURL: String!
    //Singleton!
    static let sharedInstance = User()
    var artWorks: [ArtWork] = []
    var typeOfGallery: String!
    
    private init() {
        self.name = ""
        self.email = ""
    }
    
    init (name:String, email: String){
        self.name = name
        self.email = email
    }
    
    init (name:String, email: String, picture: String){
        self.name = name
        self.email = email
        self.profilePictureURL = picture
    }
    
    func getGalleryStyle() -> iCarouselType {
        switch typeOfGallery {
        case "Linear":
            return iCarouselType.linear
        case "Rotary":
            return iCarouselType.rotary
        case "InvertedRotary":
            return iCarouselType.invertedRotary
        case "Cylinder":
            return iCarouselType.cylinder
        case "InvertedCylinder":
            return iCarouselType.invertedCylinder
        case "Wheel":
            return iCarouselType.wheel
        case "InvertedWheel":
            return iCarouselType.invertedWheel
        case "CoverFlow":
            return iCarouselType.coverFlow
        case "CoverFlow2":
            return iCarouselType.coverFlow2
        case "TimeMachine":
            return iCarouselType.timeMachine
        default:
            return iCarouselType.invertedTimeMachine
        }
    }
}
