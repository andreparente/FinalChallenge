//
//  USER.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import Foundation
import iCarousel

class Artist {
    
    var name: String!
    var email: String!
    // var obras: [Obra] = []
    var friendsId: [String] = []
    var favoriteArtsIds: [String] = []
    var favoriteArtistsIds: [String] = []
    var favoriteArts: [ArtWork] = []
    var favoriteArtists: [User] = []
    var id: String!
    var profilePictureURL: String!
    var totalFollowers: Int!
    //Singleton!
    var artWorks: [ArtWork] = []
    var artWorksIds: [String] = []
    var typeOfGallery: String!
    
    init() {
        
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
    
    func getGalleryStyle() -> iCarouselType? {
        
        if typeOfGallery != nil {
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
        } else {
            return nil
        }
        
    }
    
    func findArtWorkById(id: String) -> ArtWork? {
        for art in self.artWorks {
            if art.id == id {
                return art
            }
        }
        return nil
    }
}

