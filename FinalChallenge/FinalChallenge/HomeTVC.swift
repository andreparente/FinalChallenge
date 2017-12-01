//
//  HomeViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class HomeTVC: UITableViewController {

    var reuseIdentifier = "CategoriesTableViewCell"
    var artistsReuseIdentifier = "ArtistsTableViewCell"
    var favoriteArtsReuseIdentifier = "FavoriteArtsTableViewCell"
    var categorySelected = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .white
        self.view.backgroundColor = .white
        tableView.separatorStyle = .none
        
        self.tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(ArtistsTableViewCell.self, forCellReuseIdentifier: artistsReuseIdentifier)
        self.tableView.register(FavoriteArtsTableViewCell.self, forCellReuseIdentifier: favoriteArtsReuseIdentifier)

        DatabaseAccess.sharedInstance.fetchCategories { (success: Bool, response: String) in
            if success {
                self.tableView.reloadSections([0], with: .fade)
            } else {
                
            }
        }
        
        DatabaseAccess.sharedInstance.fetchArtists { (success: Bool, response: String) in
            if success {
                self.tableView.reloadSections([1], with: .fade)
            } else {
                
            }
        }
        
        DatabaseAccess.sharedInstance.fetchFollowedArtistsIdsFor(user: User.sharedInstance){ (success: Bool, response: String) in
            if success {
//                print(User.sharedInstance.favoriteArtistsIds)
            } else {
            print("deu erro")
            }
        }
    
 
        
        DatabaseAccess.sharedInstance.fetchNewestArtWorks { (success: Bool, response: String) in
            if success {
                self.tableView.reloadSections([2], with: .fade)
            } else {
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension HomeTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            print("categorias")
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoriesTableViewCell
            cell.fatherController = self
            return cell
        case 1:
            print("artistas")
            let cell = tableView.dequeueReusableCell(withIdentifier: artistsReuseIdentifier, for: indexPath) as! ArtistsTableViewCell
            cell.fatherController = self
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: favoriteArtsReuseIdentifier, for: indexPath) as! FavoriteArtsTableViewCell
            cell.fatherController = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 15, y: 0, width: self.view.frame.width, height: 35))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: 2*view.frame.width/3, height: 35))
        label.textColor = .blue
        label.font = UIFont(name: "Helvetica", size: 16)
        view.addSubview(label)

        switch section {
        case 0:
            label.text = "Categorias"
            return view
        case 1:
            let button = UIButton(frame: CGRect(x: label.frame.maxX, y: 0, width: view.frame.width/3, height: 35))
            button.setTitle("See All", for: .normal)
            button.titleLabel?.textAlignment = .right
            button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 14)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(HomeTVC.goToArtists), for: .touchUpInside)
            view.addSubview(button)
            label.text = "Artistas"
            return view
        default:
            label.text = "Novas Obras"
            return view
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 170 //altura
        default:
            //novas obras
            return 180
        }
    }
    
    func goToArtists() {
        print("goToArtists")
        self.performSegue(withIdentifier: "HomeToArtists", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCategory" {
            let vc = segue.destination as! CategoryCollectionViewController
            vc.categoryName = self.categorySelected
        }
    }
}
