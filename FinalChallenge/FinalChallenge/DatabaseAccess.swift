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
import FirebaseFirestore

class DatabaseAccess {
    
    //local variables
    var categories: [String] = []
    var artists: [Artist] = []
    var newestArts: [ArtWork] = []
    
    var usersRef: DatabaseReference?
    var artWorksRef: DatabaseReference?
    var artsRef: DatabaseReference?
    var storageRef: StorageReference?
    var followedByRef: DatabaseReference?
    var likedByRef: DatabaseReference?
    
    
    //Singleton!
    static let sharedInstance = DatabaseAccess()
    
    
    var categoriesImages: [UIImage] = []
    
    
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
    
    func removeValues() {
        self.categories = []
        self.newestArts = []
        self.artists = []
    }
    
    
    
    func databaseAccessWriteCreateUser(user:User) {
        //verificacao com do profile picture URL para caso de login com facebook
        let userDict: [String : Any] = ["email":user.email as String, "name" : user.name, "profilePictureURL":"", "friendsId" : "", "favoriteArts" : "", "favoriteArtists" : "", "isArtist": false]
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
                User.sharedInstance.profilePictureURL = userDict2["profilePictureURL"] as? String
                if userDict2["tel1"] != nil{
                    User.sharedInstance.tel1 = userDict2["tel1"] as? String
                }
                
                if userDict2["tel2"] != nil{
                    User.sharedInstance.tel2 = userDict2["tel2"] as? String
                }
                //TODO FETCH friendsID/favoriteArts/favoriteArtists/totalFollowers
                
                if userDict2["isArtist"] != nil {
                    User.sharedInstance.isArtist = userDict2["isArtist"] as! Bool
                    if let ids = userDict2["artsId"] as? [String: String] {
                        for art in ids {
                            let artWork = ArtWork()
                            artWork.id = art.key
                            User.sharedInstance.artWorks.append(artWork)
                        }
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
    
    func fetchUserInfoBy(id: String, callback: @escaping((_ success: Bool)->())) {
        
        usersRef?.queryOrderedByKey().queryEqual(toValue: id).observeSingleEvent(of: .value, with: { snapshot in
            let userDict = snapshot.value as? [String: Any] ?? [:]
            
            if !userDict.isEmpty {
                print(userDict)
                //preencher as infos no user local
                User.sharedInstance.id = Auth.auth().currentUser?.uid
                let userDict2 = userDict[(Auth.auth().currentUser?.uid)!] as! [String: Any]
                User.sharedInstance.name = userDict2["name"] as! String
                User.sharedInstance.email = userDict2["email"] as! String
                User.sharedInstance.profilePictureURL = userDict2["profilePictureURL"] as? String
                
                if userDict2["tel1"] != nil{
                    User.sharedInstance.tel1 = userDict2["tel1"] as? String
                }
                
                if userDict2["tel2"] != nil{
                    User.sharedInstance.tel2 = userDict2["tel2"] as? String
                }
                //TODO FETCH friendsID/favoriteArts/favoriteArtists/totalFollowers
                
                if userDict2["isArtist"] != nil {
                    User.sharedInstance.isArtist = userDict2["isArtist"] as! Bool
                    if let ids = userDict2["artsId"] as? [String: String] {
                        for art in ids {
                            let artWork = ArtWork()
                            artWork.id = art.key
                            User.sharedInstance.artWorks.append(artWork)
                        }
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
        
        let dataToUpload = UIImageJPEGRepresentation(image, 0.2)
        
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
        
        let dataToUpload = UIImageJPEGRepresentation(image, 0.2)
        
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
                artwork.urlPhotos.append((metadata?.downloadURL()?.absoluteString)!)
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
        
        var artDict =
            [
                "title" : artwork.title,
                "description" : artwork.descricao,
                "category" : artwork.category,
                "value" : artwork.value,
                "height" : artwork.height,
                "width" : artwork.width,
                "creator" : (Auth.auth().currentUser?.uid)!,
                "creatorName" : User.sharedInstance.name,
                "likes" : 0,
                "dateAdded" : Date().ticks
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
                print("sucesso na gravação dos metadados da artwork")
                //User node
                self.usersRef?.child((Auth.auth().currentUser?.uid)!).child("artsId").child(artwork.id).setValue(artwork.id)
                self.usersRef?.child((Auth.auth().currentUser?.uid)!).child("isArtist").setValue(true)
                
                //Arts node
                //        self.artsRef?.child(artwork.category).child(artwork.id).setValue(artwork.id)
                self.artsRef?.child(artwork.category).child(artwork.id).setValue(artwork.id)
                
                
                var i = 0
                for img in artwork.images {
                    
                    if let image = img {
                        self.uploadArtworkImage(image: image, artwork: artwork, pictureNumber: i, callback: {(success: Bool, response: String) in
                            if success {
                                
                                if i == totalCount { //acabaram as imagens
                                    artDict["pictures"] = artwork.urlPhotos
                                    //                                    self.defaultStore.collection("artWorks").document(artwork.id).setData(artDict, completion: { (error: Error?) in
                                    //                                        if error != nil {
                                    //                                            print(error?.localizedDescription ?? 0)
                                    //                                        } else {
                                    //                                            print("DEU CERTO O FIRESTORE")
                                    //                                            callback(true,"DEU CERTO")
                                    //                                        }
                                    //                                    })
                                    User.sharedInstance.artWorks.append(artwork)
                                    
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
            for art in arts {
                self.categories.append(art.key)
                print(art.key)
                if art.key == "Vestuário" {
                    self.categoriesImages.append(UIImage(named: "Vestuario")!)
                } else if art.key == "Mobiliário" {
                    self.categoriesImages.append(UIImage(named: "Mobiliario")!)
                } else if art.key == "Cerâmica" {
                    self.categoriesImages.append(UIImage(named: "Ceramica")!)
                } else {
                    self.categoriesImages.append(UIImage(named: art.key)!)
                }
            }
            callback(true, "")
        })
    }
    
    func fetchArtists(callback: @escaping((_ success: Bool, _ response: String)->())) {
        
        let query = usersRef?.queryOrdered(byChild: "isArtist").queryEqual(toValue: true).queryLimited(toFirst: 15)
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
                
                if aux["tel1"] != nil{
                    print(aux["tel1"] as? String)
                    artistAux.tel1 = aux["tel1"] as? String
                }
                
                if aux["tel2"] != nil{
                    artistAux.tel2 = aux["tel2"] as? String
                }
                    
                else {
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
    
    func fetchArtWorksFor(text: String, callback: @escaping((_ success: Bool, _ artWorks: [ArtWork])->())) {
        
        self.artWorksRef?.queryOrdered(byChild: "description").queryStarting(atValue: text).queryEnding(atValue: text+"\\uf8ff")
        
        self.artWorksRef?.queryOrdered(byChild: "description").queryStarting(atValue: "[a-zA-Z0-9]*", childKey: "description").queryEnding(atValue: text).observe(.value, with: { (snapshot: DataSnapshot) in
            print(snapshot.value ?? 0)
        }, withCancel: { (error: Error) in
            print(error.localizedDescription)
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
            
            User.sharedInstance.favoriteArtists.append(artist)
            
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
            self.artWorksRef?.child(artwork.id).child("likes").setValue(artwork.totalLikes)
            
            User.sharedInstance.favoriteArts.append(artwork)
            
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
        var auxArtists: [Artist] = []
        for artistId in user.favoriteArtistsIds{
            self.usersRef?.child(artistId).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                
                let artistDict = snapshot.value as! [String:Any]
                
                // possible to add other attributes from dictionary
                let artist = Artist()
                artist.name = artistDict["name"] as! String
                artist.email = artistDict["email"] as! String
                artist.id = artistId
                artist.profilePictureURL = artistDict["profilePictureURL"] as? String
                
                //TEST HERE
                if(artistDict["followers"] != nil){
                    artist.totalFollowers = artistDict["followers"] as! Int
                }
                else{
                    self.usersRef?.child(artist.id).child("followers").setValue(0)
                }
                //TEST END HERE
                
                if artistDict["tel1"] != nil{
                    artist.tel1 = artistDict["tel1"] as? String
                }
                
                if artistDict["tel2"] != nil{
                    artist.tel2 = artistDict["tel2"] as? String
                }
                
                for art in (artistDict["artsId"] as? [String: String])! {
                    let artWork = ArtWork()
                    artWork.id = art.key
                    artist.artWorks.append(artWork)
                }

                
                auxArtists.append(artist)
                if(artistId == user.favoriteArtistsIds.last){
                    user.favoriteArtists = auxArtists
                    callback(true, "funcionou")
                }
                
            }, withCancel: { (error:Error) in
                print(error.localizedDescription)
                callback(false, error.localizedDescription)
            })
        }
    }
    
    func fetchNewestArtWorks(callback: @escaping((_ success: Bool, _ response: String)->())) {
        
        
        artWorksRef?.queryOrdered(byChild: "dateAdded").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            
            if let FirebaseArts = snapshot.value as? [String : Any] {
                for art in FirebaseArts {
                    
                    let artWorkAux: ArtWork = ArtWork()
                    let artAux = art.value as! [String : Any]
                    print(artAux["title"] as! String)
                    artWorkAux.category = artAux["category"] as! String
                    artWorkAux.creatorName = artAux["creatorName"] as? String
                    artWorkAux.descricao = artAux["description"] as! String
                    artWorkAux.id = art.key
                    artWorkAux.title = artAux["title"] as! String
                    artWorkAux.totalLikes = artAux["likes"] as? Int ?? 0
                    artWorkAux.height = artAux["height"] as? Double
                    artWorkAux.value = artAux["value"] as? Double
                    artWorkAux.width = artAux["width"] as? Double
                    
                    //                    var index = 0
                    for pic in artAux["pictures"] as! [String: String] {
                        artWorkAux.urlPhotos.append(pic.value)
                        // index += 1
                    }
                    
                    self.newestArts.append(artWorkAux)
                }
                callback(true, "deu Certo")
            }
        }, withCancel: { (error: Error) in
            print(error.localizedDescription)
        })
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
        var auxArtWorks: [ArtWork] = []
        for artId in user.favoriteArtsIds {
            self.artWorksRef?.child(artId).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                
                let artDict = snapshot.value as! [String:Any]
                
                // possible to add other attributes from dictionary
                let artWork = ArtWork()
                artWork.title = artDict["title"] as! String
                artWork.id = artId
                
                //TEST
                if(artDict["likes"] != nil){
                    artWork.totalLikes = artDict["likes"] as! Int
                }
                else{
                    self.artWorksRef?.child(artWork.id).child("likes").setValue(0)
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
                
                for picUrl in pictDict{
                    let picURL = picUrl.value
                    artWork.urlPhotos.append(picURL)
                }
                auxArtWorks.append(artWork)
                print(artWork)
                
                if(artId == user.favoriteArtsIds.last){
                    user.favoriteArts = auxArtWorks
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
                
                artist.findArtWorkById(id: art.id!)?.creatorName = artDict["creatorName"] as? String
                artist.findArtWorkById(id: art.id!)?.totalLikes = artDict["likes"] as? Int ?? 0
                artist.findArtWorkById(id: art.id!)?.height = artDict["height"] as? Double
                artist.findArtWorkById(id: art.id!)?.value = artDict["value"] as? Double
                artist.findArtWorkById(id: art.id!)?.width = artDict["width"] as? Double
                
                //ajeitar esse codigo de preencher as imagens, provavelmente um for entre as keys..
                if let pictDict = artDict["pictures"] as? [String:String] {
                    print(pictDict)
                    for pic in pictDict{
                        artist.findArtWorkById(id: art.id!)?.urlPhotos.append(pic.value)
                    }
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
            
            if let dict = snapshot.value as? [String: String] {
                for each in dict {
                    ids.append(each.key)
                }
                
                let totalArts = ids.count
                var count = 0
                for id in ids {
                    let artAux = ArtWork()
                    self.artWorksRef?.child(id).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                        print(snapshot.description)
                        
                        if let artDict = snapshot.value as? [String: Any] {
                            //guardar resultado de find artworkbyid para nao fazer a mesma busca varias vzs
                            artAux.category = artDict["category"] as? String
                            artAux.descricao = artDict["description"] as? String
                            artAux.title = artDict["title"] as? String
                            
                            artAux.creatorName = artDict["creatorName"] as? String
                            artAux.id = id
                            artAux.totalLikes = artDict["likes"] as? Int ?? 0
                            artAux.height = artDict["height"] as? Double
                            artAux.value = artDict["value"] as? Double
                            artAux.width = artDict["width"] as? Double
                            
                            
                            //ajeitar esse codigo de preencher as imagens, provavelmente um for entre as keys..
                            if let pictDict = artDict["pictures"] as? [String:String] {
                                print(pictDict)
                                for pic in pictDict {
                                    artAux.urlPhotos.append(pic.value)
                                }
                            }
                            
                            artAux.id = id
                            returnedArtWorks.append(artAux)
                            count += 1
                            
                            if count == totalArts {
                                callback(true, "", returnedArtWorks)
                            } else {
                            }
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
    
    
    
    //mudar essas funcoes
    func fetchArtWorksBy(text: String, callback: @escaping((_ success: Bool, _ artWorks: [ArtWork])->())) {
        var resultedArtWorks: [ArtWork] = []
        
        artWorksRef?.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            let artWorksDict = snapshot.value as! [String: Any]
            let artWorksDictKeys = Array(artWorksDict.keys)
            
            for key in artWorksDictKeys {
                let artDict = artWorksDict[key] as! [String:Any]
                let artWork = ArtWork()
                artWork.descricao = artDict["description"] as! String
                artWork.title =  artDict["title"] as! String
                
                //verify strings
                let stringToLocate = text.uppercased()
                let stringToCheck = artWork.descricao.uppercased()
                let stringToCheck2 = artWork.title.uppercased()
                
                
                if(stringToCheck.range(of: stringToLocate) != nil || stringToCheck2.range(of: stringToLocate) != nil){
                    artWork.creatorName = artDict["creatorName"] as? String
                    artWork.category = artDict["category"] as? String
                    artWork.height = artDict["height"] as? Double
                    artWork.id = key
                    artWork.title =  artDict["title"] as? String
                    artWork.totalLikes = artDict["likes"] as? Int
                    artWork.value = artDict["value"] as? Double
                    artWork.width = artDict["width"] as? Double
                    
                    
                    if let picDict = artDict["pictures"] as? [String:String]{
                        for pic in picDict{
                            artWork.urlPhotos.append(pic.value)
                        }
                    }
                    
                    resultedArtWorks.append(artWork)
                }
                
            }
            
            callback(true, resultedArtWorks)
            
            
        }, withCancel: { (error: Error) in
            print(error.localizedDescription)
            let emptyArray = [ArtWork] ()
            callback(false, emptyArray)
        })
        
    }
    
    //mudar essas funcoes
    func fetchArtistBy(name: String, callback: @escaping((_ success: Bool, _ artWorks: [Artist])->())) {
        var resultedArtists: [Artist] = []
        
        usersRef?.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            let usersDict = snapshot.value as! [String: Any]
            let usersDictKeys = Array(usersDict.keys)
            
            for key in usersDictKeys {
                let artistDict = usersDict[key] as! [String:Any]
                let artist = Artist()
                
                if let isArtist = artistDict["isArtist"] as? Bool{
                    
                    if isArtist {
                        artist.name = artistDict["name"] as! String
                        
                        let stringToLocate = name.uppercased()
                        let stringToCheck = artist.name.uppercased()
                        
                        if(stringToCheck.range(of: stringToLocate) != nil) {
                            artist.email = artistDict["email"] as! String
                            artist.id = key
                            artist.profilePictureURL = artistDict["profilePictureURL"] as! String
                            artist.totalFollowers = artistDict["followers"] as! Int
                            
                            if artistDict["tel1"] != nil{
                                artist.tel1 = artistDict["tel1"] as? String
                            }
                            
                            if artistDict["tel2"] != nil{
                                artist.tel2 = artistDict["tel2"] as? String
                            }
                            
                            
//                            if let artWorksIdDic = artistDict["artsId"] as? [String:String]{
//                                for id in artWorksIdDic{
//                                    let artWork = ArtWork()
//                                    artWork.id = id.key
//                                    artist.artWorks.append(artWork)
//                                }
//                            }
                            
                            for art in (artistDict["artsId"] as? [String: String])! {
                                let artWork = ArtWork()
                                artWork.id = art.key
                                artist.artWorks.append(artWork)
                            }
                            
                            resultedArtists.append(artist)
                        }
                        
                    }
                }
            }
            callback(true, resultedArtists)
            
        }, withCancel: { (error: Error) in
            print(error.localizedDescription)
            callback(false, resultedArtists)
        })
    }
    
    func updateUserProfile(dict: [String:Any], callback: @escaping((_ success: Bool)->())){
        
        usersRef!.child(User.sharedInstance.id).updateChildValues(dict, withCompletionBlock: { (error: Error?, ref: DatabaseReference) in
            if error != nil {
                print(error?.localizedDescription ?? 0)
            } else {
                callback(true)
            }
        })
        
        
        
    }
    
}
