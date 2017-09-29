//
//  PerfilTableViewCell.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 27/09/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    var artsCollectionView: UICollectionView!
    var artistsCollectionView: UICollectionView!

    var fatherController: ProfileViewController!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("height da cell (deveria ser tudo menos 50) :: ", self.bounds.height)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        artsCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), collectionViewLayout: layout)
        artsCollectionView.delegate = self
        artsCollectionView.dataSource = self
        artsCollectionView.backgroundColor = UIColor.clear
        let nib = UINib(nibName: "ArtWorkCollectionViewCell", bundle: nil)
        artsCollectionView.register(nib, forCellWithReuseIdentifier: "ArtWorkCollectionViewCell")
        
        
        artistsCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 150), collectionViewLayout: layout)
        artistsCollectionView.delegate = self
        artistsCollectionView.dataSource = self
        artistsCollectionView.backgroundColor = UIColor.clear
        let nib2 = UINib(nibName: "ArtistCollectionViewCell", bundle: nil)
        artistsCollectionView.register(nib2, forCellWithReuseIdentifier: "ArtistCollectionViewCell")

        self.addSubview(artsCollectionView)
        artsCollectionView.isHidden = true
        self.addSubview(artistsCollectionView)
        artistsCollectionView.isHidden = true

        if indexSelected == 0 || indexSelected == 1 {
            if artistsCollectionView != nil {
                artistsCollectionView.isHidden = true
                artsCollectionView.isHidden = false
            }
        } else {
            if artsCollectionView != nil {
                artsCollectionView.isHidden = true
                artistsCollectionView.isHidden = false
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

extension ProfileTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if indexSelected == 0 || indexSelected == 1 {
            return 4
        } else {
            return 6

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexSelected == 0 || indexSelected == 1 {
            let cell = self.artsCollectionView.dequeueReusableCell(withReuseIdentifier: "ArtWorkCollectionViewCell", for: indexPath) as! ArtWorkCollectionViewCell
            cell.backgroundColor = .red
            return cell
        } else {
            let cell = self.artsCollectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCollectionViewCell", for: indexPath) as! ArtistCollectionViewCell
            cell.backgroundColor = .green
            cell.nameLbl.text = "André Parente"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexSelected == 0 || indexSelected == 1 {
            return(CGSize(width: 158, height: 158))
        } else {
            return(CGSize(width: self.frame.width/2 - 1, height: 200))
            
        }
    }
}
