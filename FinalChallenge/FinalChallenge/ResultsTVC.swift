//
//  ResultsTVC.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 21/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ResultsTVC: UITableViewController {

    var word: String!
    
    var artistsResult: [Artist] = []
    var artWorksResult: [ArtWork] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.register(UINib(nibName: "ResultedArtWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultedArtWorkCell")
        self.tableView.register(UINib(nibName: "ArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "ArtistCell")
        
        //fazer funcao de query by string artists and artworks  OLENKA
        
        //query pra nome artista
        // ---------------------------------------------------------------------------
       // CHAMAR NO CALLBACK:::: self.tableView.reloadSections([0], with: .none)
        print("PALAVRA A PROCURAR:: ", word)
//        DatabaseAccess.sharedInstance.fetchArtWorksBy(title: word) { (success: Bool, artWorks: [ArtWork]) in
//            if success {
//                print("entrou no callback")
//                print(artWorks)
//                self.artWorksResult = artWorks
//                self.tableView.reloadSections([1], with: .fade)
//            } else {
//                
//            }
//        }
        
        DatabaseAccess.sharedInstance.fetchArtWorksBy(description: word) { (success: Bool, artWorks: [ArtWork]) in
            if success {
                print("entrou no callback")
                print(artWorks)
                self.artWorksResult = artWorks
                self.tableView.reloadSections([1], with: .fade)
            } else {
                
            }
        }
        
//        DatabaseAccess.sharedInstance.fetchArtistBy(name: word) { (success: Bool, artists: [Artist]) in
//            if success {
//                self.tableView.reloadSections([0], with: .fade)
//            } else {
//                
//            }
//        }
        
        
//        var ref: DocumentReference? = nil
//        ref = defaultStore.collection("artWorks").addDocument(data: [
//            "title": "ArteTeste",
//            "description": "Description teste vai que da",
//            "category": "Adorno"
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
        
                
//        artWorksRef.whereField("description", isGreaterThanOrEqualTo: "teste").addSnapshotListener { (snapshot: QuerySnapshot?, error: Error?) in
//            if error != nil {
//                print(error?.localizedDescription)
//            } else {
//                print(snapshot?.documents)
//            }
//        }
        //query pra titulo de obra de arte
        // ---------------------------------------------------------------------------
        // CHAMAR NO CALLBACK:::: self.tableView.reloadSections([1], with: .none)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return artistsResult.count
        } else {
            return artWorksResult.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "ResultedArtWorkCell", for: indexPath) as! ResultedArtWorkTableViewCell
            cell.title.text = artWorksResult[indexPath.row].title
            cell.creatorName.text = artWorksResult[indexPath.row].creatorName
            cell.artWorkImage.downloadedFrom(link: artWorksResult[indexPath.row].urlPhotos.first!, contentMode: .scaleAspectFill)
            cell.artWorkImage.layer.masksToBounds = true
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistTableViewCell
            cell.name.text = artistsResult[indexPath.row].name
            cell.picture?.downloadedFrom(link: artistsResult[indexPath.row].profilePictureURL, contentMode: .scaleAspectFill)
            cell.picture.layer.masksToBounds = true
            cell.picture.layer.cornerRadius = cell.picture.frame.width/2

            return cell
        }
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        } else {
            return 200
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        let title = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.width - 30, height: 30))
        view.addSubview(title)
        title.textColor = UIColor.vitrineDarkBlue
        if section == 0 {
            title.text = "Criadores"
        } else {
            title.text = "Obras"
        }
        title.font = UIFont(name: "Lato-Regular", size: 14)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
