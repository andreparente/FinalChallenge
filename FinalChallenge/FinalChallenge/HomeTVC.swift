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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(ArtistsTableViewCell.self, forCellReuseIdentifier: artistsReuseIdentifier)
        
        DatabaseAccess.sharedInstance.fetchCategories { (success: Bool, response: String) in
            if success {
                self.tableView.reloadSections([0], with: .none)
                print(DatabaseAccess.sharedInstance.categories)
            } else {
                
            }
        }
        
        DatabaseAccess.sharedInstance.fetchArtists { (success: Bool, response: String) in
            if success {
                self.tableView.reloadSections([1], with: .none)
                //    print(DatabaseAccess.sharedInstance.artists)
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
            print("eventos")
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoriesTableViewCell
            cell.fatherController = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30))
        switch section {
        case 0:
            print("categorias")
            label.text = "Categorias"
        case 1:
            print("artistas")
            label.text = "Artistas"
        default:
            print("eventos")
            label.text = "Eventos"
        }
        label.textColor = .black
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            print("categorias")
            return 170
        case 1:
            print("artistas")
            return 207 //altura
        default:
            print("eventos")
            return 150
        }
    }
    
}
