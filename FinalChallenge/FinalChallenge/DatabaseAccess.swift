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
    
    //local variables
    var categories: [String] = []
    var artists: [User] = []
    
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
        artWorksRef = Database.database().reference().child("artWorks")
        
        artsRef = Database.database().reference()
        artsRef = Database.database().reference().child("Arte")
        
        let storage = Storage.storage()
        self.storageRef = storage.reference()
    }
    
    func databaseAccessWriteCreateUser(user:User) {
        //verificacao com do profile picture URL para caso de login com facebook
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
        
        let dataToUpload = UIImagePNGRepresentation(image)
        
        storageRef = DatabaseAccess.sharedInstance.storageRef!
        print(storageRef ?? 0)
        var ref: StorageReference?
        ref = storageRef?.child(User.sharedInstance.id).child("profilePicture.png")
        
        ref?.putData(dataToUpload!, metadata: nil, completion: {(metadata, error) in
            if error != nil{
                print (error ?? 0)
                callback(false,(error?.localizedDescription)!)
                return
            }
            else{
                print(metadata ?? 0)
                User.sharedInstance.profilePictureURL = metadata?.downloadURL()?.absoluteString
              //  self.usersRef?.child((Auth.auth().currentUser?.uid)!).setValue(User.sharedInstance.profilePictureURL, forKey: "profilePictureURL")
                self.usersRef?.child(User.sharedInstance.id).child("profilePictureURL").setValue(User.sharedInstance.profilePictureURL)
                
                
                
                callback(true,"True")
            }
        })
    }
    
    func uploadArtworkImage(image: UIImage, artwork:ArtWork, pictureNumber: Int, callback: @escaping((_ success: Bool, _ response: String)->())) {
        
        let dataToUpload = UIImagePNGRepresentation(image)
        
        storageRef = DatabaseAccess.sharedInstance.storageRef!
        print(storageRef ?? 0)
        var ref: StorageReference?
        ref = storageRef?.child(User.sharedInstance.id).child(artwork.id).child(String(pictureNumber)+".png")
        
        ref?.putData(dataToUpload!, metadata: nil, completion: {(metadata, error) in
            if error != nil{
                print (error ?? 0)
                callback(false,(error?.localizedDescription)!)
                return
            }
            else{
                print(metadata ?? 0)
                self.usersRef?.child((Auth.auth().currentUser?.uid)!).child("artsId").child(artwork.id).child("pic" + String(pictureNumber)).setValue(metadata?.downloadURL()?.absoluteString)
                //  self.usersRef?.child((Auth.auth().currentUser?.uid)!).setValue(User.sharedInstance.profilePictureURL, forKey: "profilePictureURL")
//                self.usersRef?.child(User.sharedInstance.id).child("profilePictureURL").setValue(User.sharedInstance.profilePictureURL)
                
                
                
                callback(true,"True")
            }
        })
    }
    
    func databaseAccessWriteCreateArtwork(artwork:ArtWork) {
        
        
        //ArtWork node
        artWorksRef?.child(artwork.id).child("title").setValue(artwork.title)
        artWorksRef?.child(artwork.id).child("description").setValue(artwork.descricao)
        artWorksRef?.child(artwork.id).child("category").setValue(artwork.category)

        if(artwork.value == nil){
            artWorksRef?.child(artwork.id).child("value").setValue(0)
        }
        else{
            artWorksRef?.child(artwork.id).child("value").setValue(artwork.value)
        }
        if(artwork.height == nil){
            artWorksRef?.child(artwork.id).child("height").setValue(0)
        }
        else{
            artWorksRef?.child(artwork.id).child("height").setValue(artwork.height)
        }
        if(artwork.width == nil){
            artWorksRef?.child(artwork.id).child("width").setValue(0)
        }
        else{
            artWorksRef?.child(artwork.id).child("width").setValue(artwork.width)
        }
        artWorksRef?.child(artwork.id).child("creator").setValue((Auth.auth().currentUser?.uid)!)


        //User node
        self.usersRef?.child((Auth.auth().currentUser?.uid)!).child("artsId").child(artwork.id)

        var i = 1
        for img in artwork.images{
            uploadArtworkImage(image: img, artwork: artwork, pictureNumber: i, callback: {(success: Bool, response: String) in
                if success{

                }
                else{
                    print("erro")
                }
            })
            i = i+1
        }

        self.usersRef?.child((Auth.auth().currentUser?.uid)!).child("isArtist").setValue(true)

        //Arts node
//        self.artsRef?.child(artwork.category).child(artwork.id).setValue(artwork.id)
        self.artsRef?.child(artwork.category).childByAutoId().setValue(artwork.id)
        
        return
    }
    
    func fetchCategories(callback: @escaping((_ success: Bool, _ response: String)->())) {
        artsRef?.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            let arts = snapshot.value as! [String:Any]
            print(arts)
            for art in arts {
                self.categories.append(art.key)
            }
            callback(true, "")
        })
    }
    
    func fetchArtists(callback: @escaping((_ success: Bool, _ response: String)->())) {
        
        let query = usersRef?.queryOrdered(byChild: "isArtist").queryEqual(toValue: true)
        query?.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            let userDict = snapshot.value as? [String: Any] ?? [:]
            print(userDict)
            for user in userDict {
                let aux = user.value as! [String: Any]
//                self.artists.append(User(name: aux["name"] as! String, email: aux["email"] as! String, picture: aux["profilePictureURL"] as! String))
                print(aux["name"] as! String)
            }
            if userDict.isEmpty || self.artists.isEmpty || self.artists.count == 0 {
                callback(false, "")
            } else {
                callback(true, "")
            }
        }, withCancel: { (error: Error) in
            callback(true, error.localizedDescription)
        })
    }
    
}
