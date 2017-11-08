//
//  ArtistTableViewCell.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 30/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class ArtistsTableViewCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    var collectionReuseIdentifier = "ArtistCollectionViewCell"
    var fatherController: HomeTVC!
    var arrayOfNames: [String] = ["Letícia Parente","Belchior","Eu","Letícia Parente","Letícia Parente","Letícia Parente","Letícia Parente","Letícia Parente","Letícia Parente","Letícia Parente"]
    var profileImage = [UIImage(named: "profileImage1.jpg")]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 207), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        let nib = UINib(nibName: collectionReuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: collectionReuseIdentifier)
        
        self.addSubview(collectionView)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}


extension ArtistsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatabaseAccess.sharedInstance.artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentifier, for: indexPath) as! ArtistCollectionViewCell
        cell.backgroundColor = .white
        
        cell.profileImage.layer.cornerRadius = 70
        cell.profileImage.layer.masksToBounds = true
        if let picture = DatabaseAccess.sharedInstance.artists[indexPath.item].profilePictureURL {
            cell.profileImage.downloadedFrom(link: picture, contentMode: .scaleAspectFill)
        }
        cell.nameLbl.text = DatabaseAccess.sharedInstance.artists[indexPath.item].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 207 ) //altura
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CGFloat(0), height: CGFloat(0))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //ir para a tela de videos da modalidade x
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalVC = storyboard.instantiateViewController(withIdentifier: "ArtistTVC") as! ArtistProfileViewController
        modalVC.artist = DatabaseAccess.sharedInstance.artists[indexPath.row]
        DatabaseAccess.sharedInstance.fetchArtWorksFor(artist: DatabaseAccess.sharedInstance.artists[indexPath.row]) { (success: Bool, response: String) in
            if success {
                self.fatherController.present(modalVC, animated: true, completion: nil)
            } else {
                print("erro no fetchArtworks for artist")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
