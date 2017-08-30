//
//  HomeViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var fatherTableView: UITableView!
    var reuseIdentifier = "CategoriesTableViewCell"
    var artistsReuseIdentifier = "ArtistsTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        // Do any additional setup after loading the view.
    }
    
    func setTableView() {
        self.fatherTableView = UITableView(frame: CGRect(x: 15, y: 25, width: self.view.frame.width - 30, height: self.view.frame.height - 15)
, style: .plain)
        self.fatherTableView.delegate = self
        self.fatherTableView.dataSource = self
        fatherTableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        fatherTableView.register(ArtistsTableViewCell.self, forCellReuseIdentifier: artistsReuseIdentifier)
        self.fatherTableView.tableFooterView = UIView()
        self.view.addSubview(fatherTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            print("categorias")
            return 150
        case 1:
            print("artistas")
            return 30
        default:
            print("eventos")
            return 150
        }
    }
    
}
