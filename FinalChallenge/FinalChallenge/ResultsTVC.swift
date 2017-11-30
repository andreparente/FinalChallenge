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

    var isCategory: Bool!
    
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
        
        print("PALAVRA A PROCURAR:: ", word)

        
        if isCategory {
            
            DatabaseAccess.sharedInstance.fetchArtWorksFor(category: word, callback: { (success: Bool, response: String, artWorks: [ArtWork]) in
                if success {
                    print("entrou no callback")
                    print(artWorks)
                    self.artWorksResult = artWorks
                    self.tableView.reloadSections([0], with: .fade)
                } else {
                    
                }
            })
            
            
        } else {
            DatabaseAccess.sharedInstance.fetchArtWorksBy(text: word) { (success: Bool, artWorks: [ArtWork]) in
                if success {
                    print("entrou no callback")
                    print(artWorks)
                    self.artWorksResult = artWorks
                    self.tableView.reloadSections([1], with: .fade)
                } else {
                    
                }
            }
            
            DatabaseAccess.sharedInstance.fetchArtistBy(name: word) { (success: Bool, artists: [Artist]) in
                if success {
                    print("entrou no callback")
                    print(artists)
                    self.artistsResult = artists
                    self.tableView.reloadSections([0], with: .fade)
                } else {
                    
                }
            }
        }

        //query pra titulo de obra de arte
        // ---------------------------------------------------------------------------
        // CHAMAR NO CALLBACK:::: self.tableView.reloadSections([1], with: .none)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if isCategory {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isCategory {
            return artWorksResult.count
        } else {
            if section == 0 {
                return artistsResult.count
            } else {
                return artWorksResult.count
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isCategory {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultedArtWorkCell", for: indexPath) as! ResultedArtWorkTableViewCell
            cell.title.text = artWorksResult[indexPath.row].title
            cell.creatorName.text = artWorksResult[indexPath.row].creatorName
            cell.artWorkImage.downloadedFrom(link: artWorksResult[indexPath.row].urlPhotos.first!, contentMode: .scaleAspectFill)
            cell.artWorkImage.layer.masksToBounds = true
            return cell

        } else {
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
                
                if let picture = artistsResult[indexPath.row].profilePictureURL {
                    if artistsResult[indexPath.row].cachedImage != nil {
                        cell.picture.image = artistsResult[indexPath.row].cachedImage
                        cell.picture.contentMode = .scaleAspectFill
                    } else {
                        if picture == "" {
                            cell.picture.image = UIImage(named: "DefaultProfile")
                            self.artistsResult[indexPath.row].cachedImage = UIImage(named: "DefaultProfile")
                        } else {
                            cell.picture.downloadedFrom(url: URL(string: picture)!, contentMode: .scaleAspectFill) { (image: UIImage?) in
                                self.artistsResult[indexPath.row].cachedImage = image
                            }
                        }
                    }
                }
                cell.picture.layer.masksToBounds = true
                cell.picture.layer.cornerRadius = cell.picture.frame.width/2
                
                return cell
            }
        }
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isCategory {
            return 200
        } else {
            if indexPath.section == 0 {
                return 110
            } else {
                return 200
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isCategory {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
            let title = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.width - 30, height: 30))
            view.addSubview(title)
            title.textColor = UIColor.vitrineDarkBlue
            title.text = "Obras"
            title.font = UIFont(name: "Lato-Regular", size: 14)
            return view
        } else {
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
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCategory{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let modal = storyboard.instantiateViewController(withIdentifier: "ArtWorkDetail") as! ArtWorkDetailViewController
            modal.art = self.artWorksResult[indexPath.row]
            self.present(modal, animated: true, completion: nil)
        }
            
        else{
            if indexPath.section == 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let modal = storyboard.instantiateViewController(withIdentifier: "ArtistTVC") as! ArtistProfileViewController
                modal.artist = self.artistsResult[indexPath.row]
                self.present(modal, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let modal = storyboard.instantiateViewController(withIdentifier: "ArtWorkDetail") as! ArtWorkDetailViewController
                modal.art = self.artWorksResult[indexPath.row]
                self.present(modal, animated: true, completion: nil)
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismissView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
