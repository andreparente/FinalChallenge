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
    var artists: [Artist] = []
    
    var usersRef: DatabaseReference?
    var artWorksRef: DatabaseReference?
    var artsRef: DatabaseReference?
    var storageRef: StorageReference?
    var followedByRef: DatabaseReference?
    var likedByRef: DatabaseReference?
    
    
    //Singleton!
    static let sharedInstance = DatabaseAccess()
    
    private init(){
        usersRef = Database.database().reference()
        usersRef = usersRef?.child("users")
        
        artWorksRef = Database.database().reference()
        artWorksRef = Database.database().reference().child("artWorks")
        
        artsRef = Database.database().reference()
        artsRef = Database.database().reference().child("Arte")
        
        followedByRef = Database.database().reference()
        followedByRef = Database.database().reference().child("FollowedBy")
        
        likedByRef = Database.database().reference()
        likedByRef = Database.database().reference().child("LikedBy")
        
        let storage = Storage.storage()
        self.storageRef = storage.reference()
    }
    
    
    
    func databaseAccessWriteCreateUser(user:User) {
        //verificacao com do profile picture URL para caso de login com facebook
        let userDict: [String : String] = ["email":user.email as String, "name" : user.name, "profilePictureURL":"", "friendsId" : "", "favoriteArts" : "", "favoriteArtists" : ""]
        usersRef?.child((Auth.auth().currentUser?.uid)!).setValue(userDict, withCompletionBlock: { (error: Error?, reference: DatabaseReference) in
            if error == nil {
                
                //callback
                User.sharedInstance.name = user.name
                User.sharedInstance.email = user.email
                User.sharedInstance.id = Auth.auth().currentUser?.uid
            } else {
                print(error?.localizedDescription ?? 0)
            }
        })
        
        
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
                //TODO FETCH friendsID/favoriteArts/favoriteArtists/totalFollowers
                
                if userDict2["isArtist"] != nil {
                    for art in (userDict2["artsId"] as? [String: String])! {
                        let artWork = ArtWork()
                        artWork.id = art.key
                        User.sharedInstance.artWorks.append(artWork)
                    }

                } else {
                    //
                }
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
                self.artWorksRef?.child(artwork.id!).child("pictures").child("pic" + String(pictureNumber)).setValue(metadata?.downloadURL()?.absoluteString)
                //  self.usersRef?.child((Auth.auth().currentUser?.uid)!).setValue(User.sharedInstance.profilePictureURL, forKey: "profilePictureURL")
                //                self.usersRef?.child(User.sharedInstance.id).child("profilePictureURL").setValue(User.sharedInstance.profilePictureURL)
                
                
                
                callback(true,"True")
            }
        })
    }
    
    func databaseAccessWriteCreateArtwork(artwork:ArtWork,  callback: @escaping((_ success: Bool, _ response: String)->())) {
        
        var totalCount = 0
        for image in artwork.images {
            if image != nil {
                totalCount += 1
            }
        }
        
        let artDict =
            [
                "title" : artwork.title,
                "description" : artwork.descricao,
                "category" : artwork.category,
                "value" : artwork.value,
                "height" : artwork.height,
                "width" : artwork.width,
                "creator" : (Auth.auth().currentUser?.uid)!,
                "creatorName" : User.sharedInstance.name,
                "likes" : 0
                ] as [String : Any]
        //
        //        //ArtWork node
        //        artWorksRef?.child(artwork.id).child("title").setValue(artwork.title)
        //        artWorksRef?.child(artwork.id).child("description").setValue(artwork.descricao)
        //        artWorksRef?.child(artwork.id).child("category").setValue(artwork.category)
        //
        //
        //        if(artwork.value == nil){
        //            artWorksRef?.child(artwork.id).child("value").setValue(0)
        //        }
        //        else{
        //            artWorksRef?.child(artwork.id).child("value").setValue(artwork.value)
        //        }
        //        if(artwork.height == nil){
        //            artWorksRef?.child(artwork.id).child("height").setValue(0)
        //        }
        //        else{
        //            artWorksRef?.child(artwork.id).child("height").setValue(artwork.height)
        //        }
        //        if(artwork.width == nil){
        //            artWorksRef?.child(artwork.id).child("width").setValue(0)
        //        }
        //        else{
        //            artWorksRef?.child(artwork.id).child("width").setValue(artwork.width)
        //        }
        //
        //        artWorksRef?.child(artwork.id).child("creator").setValue((Auth.auth().currentUser?.uid)!)
        //        artWorksRef?.child(artwork.id).child("creatorName").setValue(User.sharedInstance.name)
        //        artWorksRef?.child(artwork.id).child("likes").setValue(0)
        
        artWorksRef?.child(artwork.id).setValue(artDict, withCompletionBlock: { (error: Error?, reference: DatabaseReference) in
            if error == nil {
                //success
                print("sucesso na gravação da artwork")
                //User node
                self.usersRef?.child((Auth.auth().currentUser?.uid)!).child("artsId").child(artwork.id).setValue(artwork.id)
                self.usersRef?.child((Auth.auth().currentUser?.uid)!).child("isArtist").setValue(true)
                
                //Arts node
                //        self.artsRef?.child(artwork.category).child(artwork.id).setValue(artwork.id)
                self.artsRef?.child(artwork.category).child(artwork.id).setValue(artwork.id)
                
                var i = 1
                for img in artwork.images{
                    
                    if let image = img {
                        self.uploadArtworkImage(image: image, artwork: artwork, pictureNumber: i, callback: {(success: Bool, response: String) in
                            if success{
                                if i == totalCount {
                                    callback(true,"DEU CERTO")
                                }
                            }
                            else {
                                print("erro")
                                callback(false,(error?.localizedDescription)!)

                            }
                        })
                        i = i+1
                    }
                }
                
            } else {
                print(error?.localizedDescription ?? 0)
                callback(false,(error?.localizedDescription)!)

            }
        })
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
            for artist in userDict {
                let aux = artist.value as! [String: Any]
                let artistAux = Artist(name: aux["name"] as! String, email: aux["email"] as! String, picture: aux["profilePictureURL"] as! String)
                
                //TEST HERE
                if(aux["followers"] != nil){
                    artistAux.totalFollowers = aux["followers"] as! Int
                }
                else{
                    self.usersRef?.child(artist.key).child("followers").setValue(0)
                }
                //TEST END HERE
                
                artistAux.typeOfGallery = aux["typeOfGallery"] as? String
                artistAux.id = artist.key
                
                for art in (aux["artsId"] as? [String: String])! {
                    let artWork = ArtWork()
                    artWork.id = art.key
                    artistAux.artWorks.append(artWork)
                }
                
                self.artists.append(artistAux)
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
    
    func databaseAccessWriteFollowArtist(user:User, artist:Artist, callback: @escaping((_ success: Bool, _ response: String)->())){
        
        self.usersRef?.child(artist.id).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
            
            print(snapshot.value ?? 0)
            print(snapshot.description)
            let artistDict = snapshot.value as! [String:Any]
            print(artistDict)
            //TEST HERE
            if(artistDict["followers"] != nil){
                artist.totalFollowers = artistDict["followers"] as! Int
                artist.totalFollowers = artist.totalFollowers + 1
            }
            else{
                self.usersRef?.child(artist.id).child("followers").setValue(0)
            }
            //TEST END HERE
            
            //Adicionar no Node do usuario, o artista que ele segue
            self.usersRef?.child(user.id).child("favoriteArtists").child(artist.id).setValue(artist.id)
            
            //Adicionar no Node Followed by o usuario que segue o artista
            self.followedByRef?.child(artist.id).child(user.id).setValue(user.id)
            
            //Incrementar o contador de followers do artist(dentro do caminho dos usuarios)
            self.usersRef?.child(artist.id).child("followers").setValue(artist.totalFollowers)
            
            callback(true, "funcionou")
            
        }, withCancel: { (error:Error) in
            print(error.localizedDescription)
            callback(false, error.localizedDescription)
        })
        
        
        
        return
    }
    
    func databaseAccessWriteLikeArtWork(artwork: ArtWork, callback: @escaping((_ success: Bool, _ response: String)->())){
        
        self.artWorksRef?.child(artwork.id).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
            
            let artDict = snapshot.value as! [String:Any]
            
            //TEST HERE
            if(artDict["likes"] != nil){
                artwork.totalLikes = artDict["likes"] as! Int
                artwork.totalLikes = artwork.totalLikes + 1
            }
            else{
                self.artWorksRef?.child(artwork.id).child("likes").setValue(0)
            }
            //TEST END HERE
            
            //Adiciona no Node do usuario que ele deu like em uma obra
            self.usersRef?.child(User.sharedInstance.id).child("favoriteArts").child(artwork.id).setValue(artwork.id)
            
            //Adiciona no Node Artworks, o usuario que deu like
            self.artWorksRef?.child(artwork.id).child("likedBy").child(User.sharedInstance.id).setValue(User.sharedInstance.id)
            
            //Incrementar o contador de likes do artwork(dentro do caminho das arts)
            self.artWorksRef?.child(artwork.id).child("lLikes").setValue(artwork.totalLikes)
            
            callback(true, "funcionou")
            
        }, withCancel: { (error:Error) in
            print(error.localizedDescription)
            callback(false, error.localizedDescription)
        })
        
        
        return
    }
    
    func fetchFollowedArtistsIdsFor(user: User, callback: @escaping((_ success: Bool, _ response: String)->())){
        usersRef?.child(user.id!).child("favoriteArtists").observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            if let artistDict = snapshot.value as? [String: String] {
                let artistsArray = Array(artistDict.keys)
                print(artistsArray)
                user.favoriteArtistsIds = artistsArray
                callback(true, "funcionou")
            } else {
                user.favoriteArtistsIds = []
                callback(true,"")
            }
            
            
        }, withCancel: { (error: Error) in
            print(error.localizedDescription)
            callback(false, error.localizedDescription)
        })
    }
    
    func fetchFollowedArtistsFor(user:User, callback: @escaping((_ success: Bool, _ response: String)->())){
        
        for artistId in user.favoriteArtistsIds{
            self.usersRef?.child(artistId).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                
                let artistDict = snapshot.value as! [String:Any]
                
                // possible to add other attributes from dictionary
                let artist = Artist()
                artist.name = artistDict["name"] as! String
                artist.profilePictureURL = artistDict["email"] as! String
                artist.id = artistId
                
                //TEST HERE
                if(artistDict["followers"] != nil){
                    artist.totalFollowers = artistDict["followers"] as! Int
                }
                else{
                    self.usersRef?.child(artist.id).child("followers").setValue(0)
                }
                //TEST END HERE
                
                user.favoriteArtists.append(artist)
                
                if(artistId == user.favoriteArtistsIds.last){
                    callback(true, "funcionou")
                }
                
            }, withCancel: { (error:Error) in
                print(error.localizedDescription)
                callback(false, error.localizedDescription)
            })
        }
    }
    
    func fetchLikedArtWorksIdsFor(user: User, callback: @escaping((_ success: Bool, _ response: String)->())){
        usersRef?.child(user.id!).child("favoriteArts").observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            
            if let artDict = snapshot.value as? [String: String] {
                let artArray = Array(artDict.keys)
                print(artArray)
                user.favoriteArtsIds = artArray
                callback(true, "funcionou")
            } else {
                user.favoriteArtsIds = []
                callback(true,"")
            }
            
        }, withCancel: { (error: Error) in
            print(error.localizedDescription)
            callback(false, error.localizedDescription)
        })
    }
    
    func fetchLikedArtWorksFor(user:User, callback: @escaping((_ success: Bool, _ response: String)->())){
        
        for artId in user.favoriteArtsIds{
            self.artWorksRef?.child(artId).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                
                let artDict = snapshot.value as! [String:Any]
                
                // possible to add other attributes from dictionary
                let artWork = ArtWork()
                artWork.title = artDict["title"] as! String
                artWork.id = artId
                
                //TEST
                if(artDict["totalLikes"] != nil){
                    artWork.totalLikes = artDict["totalLikes"] as! Int
                }
                else{
                    self.artWorksRef?.child(artWork.id).child("totalLikes").setValue(0)
                }
                if(artDict["creatorName"] != nil){
                    artWork.creatorName = artDict["creatorName"] as! String
                }
                else{
                    //tratar pegando snapshot com id do artista dentro de userref
                    //                    self.artsRef?.child(artWork.id).child("totalLikes").setValue(0)
                }
                //END TEST
                
                let pictDict = artDict["pictures"] as! [String:String]
                print(pictDict)
                
                let picNum = 1
                for _ in pictDict{
                    let picURL = pictDict["pic" + String(picNum)]!
                    artWork.urlPhotos.append(picURL)
                }
                
                user.favoriteArts.append(artWork)
                print(artWork)
                
                if(artId == user.favoriteArtsIds.last){
                    callback(true, "funcionou")
                }
            }, withCancel: { (error:Error) in
                print(error.localizedDescription)
                callback(false, error.localizedDescription)
            })
        }
        
    }
    
    
    
    func fetchArtWorksFor(artist: Artist, callback: @escaping((_ success: Bool, _ response: String)->())) {
        
        for art in artist.artWorks {
            
            artWorksRef?.child(art.id!).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                print(snapshot.description)
                let artDict = snapshot.value as! [String: Any]
                
                //guardar resultado de find artworkbyid para nao fazer a mesma busca varias vzs
                artist.findArtWorkById(id: art.id!)?.category = artDict["category"] as? String
                artist.findArtWorkById(id: art.id!)?.descricao = artDict["description"] as? String
                artist.findArtWorkById(id: art.id!)?.title = artDict["title"] as? String
                
                //ajeitar esse codigo de preencher as imagens, provavelmente um for entre as keys..
                if let pictDict = artDict["pictures"] as? [String:String] {
                    print(pictDict)
                    artist.findArtWorkById(id: art.id!)?.urlPhotos.append(pictDict.values.first!)
                }
                
                if (art.id == artist.artWorks.last?.id) {
                    print("entrou no call back success")
                    callback(true,"Deu certo")
                }
                
            }, withCancel: { (error: Error) in
                print(error.localizedDescription)
                callback(false, error.localizedDescription)
            })
        }
    }
    
    
    func fetchArtWorksFor(category: String, callback: @escaping((_ success: Bool, _ response: String, _ artWorks: [ArtWork])->())) {
        var returnedArtWorks: [ArtWork] = []
        var ids: [String] = []
        //fetch nos IDS
        artsRef?.child(category).queryLimited(toFirst: 10).observe(.value, with: { (snapshot: DataSnapshot) in
            
            if snapshot != nil {
                let dict = snapshot.value as! [String: String]
                for each in dict {
                    ids.append(each.key)
                }
                
                let totalArts = ids.count
                var count = 0
                for id in ids {
                    let artAux = ArtWork()
                    self.artWorksRef?.child(id).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                        print(snapshot.description)
                        let artDict = snapshot.value as! [String: Any]
                        
                        //guardar resultado de find artworkbyid para nao fazer a mesma busca varias vzs
                        artAux.category = artDict["category"] as? String
                        artAux.descricao = artDict["description"] as? String
                        artAux.title = artDict["title"] as? String
                        
                        //ajeitar esse codigo de preencher as imagens, provavelmente um for entre as keys..
                        let pictDict = artDict["pictures"] as! [String:String]
                        print(pictDict)
                        artAux.urlPhotos.append(pictDict.values.first!)
                        artAux.id = id
                        returnedArtWorks.append(artAux)
                        count += 1
                        
                        if count == totalArts {
                            callback(true, "", returnedArtWorks)
                        } else {
                        }
                        
                    }, withCancel: { (error: Error) in
                        print(error.localizedDescription)
                        callback(false, error.localizedDescription, returnedArtWorks)
                    })
                    
                }
            }
        }, withCancel: { (error: Error) in
            print(error.localizedDescription)
            callback(false, error.localizedDescription, returnedArtWorks)
        })
    }
    
    
}
