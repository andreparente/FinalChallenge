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
    
    var storageRef: StorageReference?

    //Singleton!
    static let sharedInstance = DatabaseAccess()
    
    private init(){
        usersRef = Database.database().reference()
        usersRef = usersRef?.child("users")
        
        artWorksRef = Database.database().reference()
        artWorksRef = usersRef?.child("artWorks")
        
        artsRef = Database.database().reference()
        artsRef = usersRef?.child("arts")
        
        var storage = Storage.storage()
        self.storageRef = storage.reference()
    }
    
    func databaseAccessWriteCreateUser(user:User) {
        //verificacao com do profile picture URL para caso de login com facebook
        let userInfo = ["email": user.email as String, "name": user.name as String, "profilePictureURL": "" as String]
//        usersRef?.child((Auth.auth().currentUser?.uid)!).setValue(userInfo)
        usersRef?.child((Auth.auth().currentUser?.uid)!).child("email").setValue(user.email as String)
        usersRef?.child((Auth.auth().currentUser?.uid)!).child("name").setValue(user.name)
        usersRef?.child((Auth.auth().currentUser?.uid)!).child("profilePictureURL").setValue("")
        usersRef?.child((Auth.auth().currentUser?.uid)!).child("friendsId").setValue("")
        usersRef?.child((Auth.auth().currentUser?.uid)!).child("favoriteArts").setValue("")
        usersRef?.child((Auth.auth().currentUser?.uid)!).child("favoriteArtists").setValue("")


        
        User.sharedInstance.name = user.name
        User.sharedInstance.email = user.email
        return
    }
    
    func fetchUserInfo(email: String, callback: @escaping((_ success: Bool)->())) {
        usersRef?.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { snapshot in
            let userDict = snapshot.value as? [String: Any] ?? [:]
            
            if !userDict.isEmpty {
                print(userDict)
                //preencher as infos no user local
                User.sharedInstance.id = Auth.auth().currentUser?.uid
                let userDict2 = userDict[(Auth.auth().currentUser?.uid)!] as! [String: Any]
                User.sharedInstance.name = userDict2["name"] as! String
                User.sharedInstance.email = userDict2["email"] as! String
                User.sharedInstance.profilePictureURL = userDict2["profilePictureURL"] as! String
                //TODO FETCH friendsID/favoriteArts/favoriteArtists

                callback(true)
            } else {
                callback(false)
            }
        })
    }
    
    func uploadProfileImage(image: UIImage, callback: @escaping((_ success: Bool, _ response: String)->())) {
        
        var dataToUpload = UIImagePNGRepresentation(image)
        
        storageRef = DatabaseAccess.sharedInstance.storageRef!
        print(storageRef)
        storageRef = storageRef?.child(User.sharedInstance.id).child("profilePicture.png")
        
        storageRef?.putData(dataToUpload!, metadata: nil, completion: {(metadata, error) in
            if error != nil{
                print (error)
                callback(false,(error?.localizedDescription)!)
                return
            }
            else{
                print(metadata)
                User.sharedInstance.profilePictureURL = metadata?.downloadURL()?.absoluteString
              //  self.usersRef?.child((Auth.auth().currentUser?.uid)!).setValue(User.sharedInstance.profilePictureURL, forKey: "profilePictureURL")
                self.usersRef?.child(User.sharedInstance.id).child("profilePictureURL").setValue(User.sharedInstance.profilePictureURL)
                
                
                
                callback(true,"True")
            }
        })
    }
}
