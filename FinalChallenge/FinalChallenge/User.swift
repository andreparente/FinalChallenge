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
    var favoriteArtsIds: [String] = []
    var favoriteArtistsIds: [String] = []
    var favoriteArts: [ArtWork] = []
    var favoriteArtists: [Artist] = []
    var id: String!
    var profilePictureURL: String?
    var cachedImage: UIImage?
    var totalFollowers: Int!
    
    //Singleton!
    static let sharedInstance = User()
    var artWorks: [ArtWork] = []
    var typeOfGallery: String!
    var isArtist: Bool!
    
    var didAddArtWork: Bool = false
    var didLikeArtWork: Bool = false
    var didFavoriteArtist: Bool = false
    
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
    
    func removeValues() {
        self.artWorks = []
        self.cachedImage = nil
        self.favoriteArtists = []
        self.favoriteArts = []
        self.favoriteArtsIds = []
        self.favoriteArtistsIds = []
        self.totalFollowers = 0
        self.isArtist = false
        self.profilePictureURL = nil
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
