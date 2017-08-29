//
//  USER.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import Foundation

class User {
    
    var name: String!
    var email: String!
   // var obras: [Obra] = []
    var friendsId: [String] = []
    var favoriteArts: [String] = []
    var favoriteArtists: [String] = []
    //Singleton!
    static let sharedInstance = User()
    
    private init() {
        self.name = ""
        self.email = ""
    }
}
