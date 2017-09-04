//
//  Database.swift
//  FinalChallenge
//
//  Created by Gustavo Fonseca Olenka on 03/09/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class DatabaseAccess {
    
    var addUserRef : DatabaseReference?
    
    init(){
        addUserRef = Database.database().reference()
        addUserRef = addUserRef?.child("users")
    }
    
    func databaseAccessWriteCreateUser(user:User) -> Bool{
        let userInfo = ["email": user.email as Any, "name": user.name as Any]
        addUserRef?.child((Auth.auth().currentUser?.uid)!).setValue(userInfo)
        return true
    }
}
