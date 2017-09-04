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
    
    var usersRef: DatabaseReference?
    var artWorksRef: DatabaseReference?
    var artsRef: DatabaseReference?

    //Singleton!
    static let sharedInstance = DatabaseAccess()
    
    private init(){
        usersRef = Database.database().reference()
        usersRef = usersRef?.child("users")
        
        artWorksRef = Database.database().reference()
        artWorksRef = usersRef?.child("artWorks")
        
        artsRef = Database.database().reference()
        artsRef = usersRef?.child("arts")
    }
    
    func databaseAccessWriteCreateUser(user:User) {
        let userInfo = ["email": user.email as Any, "name": user.name as Any]
        usersRef?.child((Auth.auth().currentUser?.uid)!).setValue(userInfo)
        return
    }
    
    func fetchUserInfo(callback: @escaping((_ success: Bool)->())) {
        usersRef?.queryOrdered(byChild: "email").queryEqual(toValue: User.sharedInstance.email).observeSingleEvent(of: .value, with: { snapshot in
            let userDict = snapshot.value as? [String: Any] ?? [:]
            
            if !userDict.isEmpty {
                
                //preencher as infos no user local
                callback(true)
            } else {
                callback(false)
            }
        })
    }
}
