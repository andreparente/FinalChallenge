//
//  FavoriteArtsTableViewCell.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 10/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class FavoriteArtsTableViewCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    var fatherController: HomeTVC!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        let nib = UINib(nibName: "ArtWorkCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ArtWorkCollectionViewCell")
        
        self.addSubview(collectionView)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
}

extension FavoriteArtsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of item in section to newestArts::::::: ", DatabaseAccess.sharedInstance.newestArts.count)
        return DatabaseAccess.sharedInstance.newestArts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtWorkCollectionViewCell", for: indexPath) as! ArtWorkCollectionViewCell
        
        print(DatabaseAccess.sharedInstance.newestArts[indexPath.row].urlPhotos.first!)
        cell.artWorkImage.isHidden = false
        
        if cell.artWorkImage.image != nil {
            
        } else {
            cell.artWorkImage.downloadedFrom(link: DatabaseAccess.sharedInstance.newestArts[indexPath.item].urlPhotos.first!, contentMode: .scaleAspectFill)
            
            cell.artWorkImage.layer.masksToBounds = true
            cell.artWorkImage.layer.cornerRadius = 7
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 180) //altura
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CGFloat(0), height: CGFloat(0))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "ArtWorkDetail") as! ArtWorkDetailViewController
        modal.art = DatabaseAccess.sharedInstance.newestArts[indexPath.item]
        self.fatherController.present(modal, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
