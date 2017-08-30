//
//  ProfileViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var fatherTableView: UITableView!
    var middleView: MiddleProfile!
    var headerView: HeaderProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTableView() {
        self.setHeaderView()
        self.setMiddleView()
        self.fatherTableView = UITableView(frame: self.view.frame, style: .plain)
        self.fatherTableView.delegate = self
        self.fatherTableView.dataSource = self
        self.fatherTableView.tableHeaderView = headerView
        
        self.view.addSubview(fatherTableView)
    }

    func setHeaderView() {
        self.headerView = HeaderProfile(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        self.headerView.profileNameLbl.text = "André Parente"
        self.headerView.bringSubview(toFront: self.headerView.profileImage)
        self.headerView.bringSubview(toFront: self.headerView.profileNameLbl)
        self.headerView.bringSubview(toFront: self.headerView.editProfileButton)
        self.headerView.bringSubview(toFront: self.headerView.inboxButton)

    }
    
    func setMiddleView() {
        self.middleView = MiddleProfile(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        self.middleView.favoriteArtsView.layer.addBorder(edge: .right, color: .lightGray, thickness: 1)
        self.middleView.favoriteArtsView.layer.addBorder(edge: .left, color: .lightGray, thickness: 1)
        self.middleView.artWorksView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.artWorksClicked)))
        
        self.middleView.favoriteArtistsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.favoriteArtistsClicked)))
        
        self.middleView.favoriteArtsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.likesClicked)))
        

        self.middleView.setArtWorksSelected()
    }

}


extension ProfileViewController {
    
    func artWorksClicked() {
        //fazer mudancas necessarias na table view, recarregar as celulas
        self.middleView.setArtWorksSelected()
        print(self.middleView.indexSelected)
    }
    
    func favoriteArtistsClicked() {
        //fazer mudancas necessarias na table view, recarregar as celulas
        self.middleView.setFavArtistsSelected()
        print(self.middleView.indexSelected)
    }
    
    func likesClicked() {
        //fazer mudancas necessarias na table view, recarregar as celulas
        self.middleView.setLikesSelected()
        print(self.middleView.indexSelected)
    }
    
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        //configurar as celulas de acordo com qual index foi escolhido
        switch self.middleView.indexSelected {
        case 0:
            print("artworks")
        case 1:
            print("curtidas")
        default:
            print("artistas")

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    //header da section -- MiddleView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return middleView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return middleView.frame.height
    }
}
