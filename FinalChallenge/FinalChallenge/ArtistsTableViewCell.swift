//
//  ArtistTableViewCell.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 30/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class ArtistsTableViewCell: UITableViewCell {
    
    var modelAccess = ModelAccessFacade.init()
    
    var collectionView: UICollectionView!
    var collectionReuseIdentifier = "ArtistCollectionViewCell"
    var fatherController: HomeTVC!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 170), collectionViewLayout: layout)
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
//        return DatabaseAccess.sharedInstance.artists.count
//        return modelAccess.databaseReference.artists.count
        return modelAccess.totalNumberOfArtists()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentifier, for: indexPath) as! ArtistCollectionViewCell
        cell.backgroundColor = .white
        
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        cell.profileImage.layer.masksToBounds = true
//        if let picture = DatabaseAccess.sharedInstance.artists[indexPath.item].profilePictureURL {
//        if let picture = modelAccess.databaseReference.artists[indexPath.item].profilePictureURL {
        if let picture = modelAccess.getArtistAt(index: indexPath.item).profilePictureURL {
            
//            if DatabaseAccess.sharedInstance.artists[indexPath.item].cachedImage != nil {
            if modelAccess.databaseReference.artists[indexPath.item].cachedImage != nil{
//                cell.profileImage.image = DatabaseAccess.sharedInstance.artists[indexPath.item].cachedImage
                cell.profileImage.image = modelAccess.getArtistAt(index: indexPath.item).cachedImage
                
                
            } else {
                
                if let url = URL(string: picture) {
                    cell.profileImage.downloadedFrom(url: url, contentMode: .scaleAspectFill) { (image: UIImage?) in
//                        DatabaseAccess.sharedInstance.artists[indexPath.item].cachedImage = image
//                        self.modelAccess.databaseReference.artists[indexPath.item].cachedImage = image
                        self.modelAccess.getArtistAt(index: indexPath.item).cachedImage = image
                    }
                } else {
                    cell.profileImage.image = UIImage(named: "DefaultProfile")
//                    DatabaseAccess.sharedInstance.artists[indexPath.item].cachedImage = UIImage(named: "DefaultProfile")
//                    self.modelAccess.databaseReference.artists[indexPath.item].cachedImage = UIImage(named: "DefaultProfile")
                    self.modelAccess.getArtistAt(index: indexPath.item).cachedImage = UIImage(named: "DefaultProfile")
                }
                
            }
        }
        
        
//        cell.nameLbl.text = DatabaseAccess.sharedInstance.artists[indexPath.item].name
//        cell.nameLbl.text = self.modelAccess.databaseReference.artists[indexPath.item].name
        cell.nameLbl.text = self.modelAccess.getArtistAt(index: indexPath.item).name
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 170 ) //altura
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
//        modalVC.artist = DatabaseAccess.sharedInstance.artists[indexPath.row]
//        modalVC.artist = modelAccess.databaseReference.artists[indexPath.row]
        modalVC.artist = modelAccess.getArtistAt(index: indexPath.row)
        self.fatherController.present(modalVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
