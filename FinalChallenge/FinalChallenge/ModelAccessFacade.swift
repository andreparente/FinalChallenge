//
//  ModelAccessFacade.swift
//  FinalChallenge
//
//  Created by Gustavo Fonseca Olenka on 21/05/18.
//  Copyright © 2018 Andre Machado Parente. All rights reserved.
//

import Foundation
import UIKit

class ModelAccessFacade {
    
    var databaseReference = DatabaseAccess.sharedInstance
    var userReference = User.sharedInstance
//    var artworReference = ArtWork.share
    //var databaseReference = DatabaseAccess.sharedInstance
    
    //Singleton!
    
    
    
    init (){
    }
    
    // USER
    func fetchUserInfoBy(id: String, callback: @escaping((_ success: Bool)->())) {
        userReference.fetchUserInfoBy(id: id, callback: { (success: Bool) in
            if success {
                callback(true)
            } else {
                callback(false)
            }
        })
    }
    
    func fetchUserInfo(email: String, callback: @escaping((_ success: Bool)->())) {
        userReference.fetchUserInfo(email: email, callback: { (success: Bool) in
            if success {
                callback(true)
            } else {
                callback(false)
            }
        })
    }
    
    func databaseAccessWriteCreateUser(user:User) {
        userReference.databaseAccessWriteCreateUser(user: user)
    }
    
    func updateUserProfile(dict: [String:Any], callback: @escaping((_ success: Bool)->())){
        
        self.databaseReference.updateUserProfile(dict: dict, callback: { (success :Bool) in
            if success {
                callback(true)
            } else {
                callback(false)
            }
        })
    }
    
    func uploadProfileImage(image: UIImage, callback: @escaping((_ success: Bool, _ response: String)->())) {
        
        self.databaseReference.uploadProfileImage(image: image, callback: { (success: Bool, response: String) in
            if success {
                callback(true, response)
            } else {
                callback(false, response)
            }
        })
    }
    
    func getUserProfilePictureUrl() -> String? {
        return userReference.profilePictureURL
    }
    
    func getUserFavoriteArtistsIds() -> [String]{
        return userReference.favoriteArtistsIds
    }
    
    func getUserCachedImage() -> UIImage? {
        return userReference.cachedImage
    }
    
    func setUserCachedImage(image:UIImage) {
        self.userReference.cachedImage = image
    }
    
    // ARTWORK
    func fetchNewestArtWorks(callback: @escaping((_ success: Bool, _ response: String)->())) {
        databaseReference.fetchNewestArtWorks(callback: { (success: Bool, response: String) in
            if success {
                callback(true, "sucesso")
            } else {
                callback(false, "erro")
            }
        })
    }
    
    func databaseAccessWriteCreateArtwork(artwork:ArtWork,  callback: @escaping((_ success: Bool, _ response: String)->())) {
        
        databaseReference.databaseAccessWriteCreateArtwork(artwork: artwork, callback: { (success: Bool, response: String) in
            if success {
                callback(true, "sucesso")
            } else {
                callback(false, "erro")
            }
        })
    }
    
    func databaseAccessWriteLikeArtWork(artwork: ArtWork, callback: @escaping((_ success: Bool, _ response: String)->())){
        
        databaseReference.databaseAccessWriteLikeArtWork(artwork: artwork, callback: { (success: Bool, response: String) in
            if success {
                callback(true, "sucesso")
            } else {
                callback(false, "erro")
            }
        })
    }
    
    func fetchArtWorksFor(artist: Artist, callback: @escaping((_ success: Bool, _ response: String)->())) {
        databaseReference.fetchArtWorksFor(artist: artist, callback: { (success: Bool, response: String) in
            if success {
                callback(true, "sucesso")
            } else {
                callback(false, "erro")
            }
        })
    }
    
    func fetchArtWorksFor(category: String, callback: @escaping((_ success: Bool, _ response: String, _ artWorks: [ArtWork])->())) {
        databaseReference.fetchArtWorksFor(category: category, callback: { (success: Bool, response: String, auxArtWorks: [ArtWork]) in
            if success {
                callback(true, "sucesso", auxArtWorks)
            } else {
                callback(false, "erro", auxArtWorks)
            }
        })
    }
    
    func fetchArtWorksBy(text: String, callback: @escaping((_ success: Bool, _ artWorks: [ArtWork])->())){
        databaseReference.fetchArtWorksBy(text: text, callback: { (success: Bool, auxArtWorks: [ArtWork]) in
            if success {
                callback(true, auxArtWorks)
            } else {
                callback(false, auxArtWorks)
            }
        })
    }
    
    func fetchLikedArtWorksIdsFor(user: User, callback: @escaping((_ success: Bool, _ response: String)->())){
        databaseReference.fetchLikedArtWorksIdsFor(user: user, callback: {(success: Bool, response: String) in
            if success{
                callback(true, response)
            } else {
                callback(false, response)
            }
        })
    }
    
    func fetchLikedArtWorksFor(user:User, callback: @escaping((_ success: Bool, _ response: String)->())){
        databaseReference.fetchLikedArtWorksFor(user: user, callback: {(success: Bool, response: String) in
            if success{
                callback(true, response)
            } else {
                callback(false, response)
            }
        })
    }
    
    
    func getArtworks() -> [ArtWork]{
        return databaseReference.newestArts
    }
    
    func getArtworkAt(index:Int) -> ArtWork{
        return databaseReference.newestArts[index]
    }
    
    func totalNumberOfArtworks() -> Int{
        return databaseReference.newestArts.count
    }
    
    // ARTIST
    func fetchArtists(callback: @escaping((_ success: Bool, _ response: String)->())) {
        databaseReference.fetchArtists(callback: { (success: Bool, response: String) in
            if success {
                callback(true, "sucesso")
            } else {
                callback(false, "erro")
            }
        })
    }
    
    func fetchArtistBy(name: String, callback: @escaping((_ success: Bool, _ artWorks: [Artist])->())) {
        databaseReference.fetchArtistBy(name: name, callback: { (success: Bool, artists: [Artist]) in
            if success {
                callback(true, artists)
            } else {
                callback(false, artists)
            }
        })
    }
    
    func fetchFollowedArtistsIdsFor(callback: @escaping((_ success: Bool, _ response: String)->())){
        userReference.fetchFollowedArtistsIdsFor( callback:{ (success: Bool, response: String) in
            if success {
                callback(true, "sucesso")
            } else {
                callback(false, "erro")
            }
        })
    }
    
    func fetchFollowedArtistsFor(user:User, callback: @escaping((_ success: Bool, _ response: String)->())){
        databaseReference.fetchFollowedArtistsFor(user: user, callback: { (success: Bool, response: String) in
            if success {
                callback(true, "sucesso")
            } else {
                callback(false, "erro")
            }
        })
    }
    
    func databaseAccessWriteFollowArtist(user:User, artist:Artist, callback: @escaping((_ success: Bool, _ response: String)->())){
        databaseReference.databaseAccessWriteFollowArtist(user: user, artist: artist, callback: { (success: Bool, response: String) in
            
            if success {
                callback(true, "sucesso")
            } else {
                callback(false, "erro")
            }
        })
    }
    
    func getArtistAt(index:Int) -> Artist{
        return databaseReference.artists[index]
    }
    
    func totalNumberOfArtists() -> Int{
        return databaseReference.artists.count
    }
    
    // Categories
    func fetchCategories(callback: @escaping((_ success: Bool, _ response: String)->())) {
        databaseReference.fetchCategories(callback: { (success: Bool, response: String) in
            if success {
                callback(true, "sucesso")
            } else {
                callback(false, "erro")
            }
        })
    }
    
    func getCategories() -> [String]{
        return databaseReference.categories
    }
    
    func getCategoryImageAt(index:Int) -> UIImage {
        return databaseReference.categoriesImages[index]
    }
    
    func getCategoryAt(index:Int) -> String{
        return databaseReference.categories[index]
    }
    
    func totalNumberOfCategories() -> Int {
        return databaseReference.categories.count
    }
    
}
