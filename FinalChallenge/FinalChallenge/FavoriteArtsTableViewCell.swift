//
//  FavoriteArtsTableViewCell.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 10/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class FavoriteArtsTableViewCell: UITableViewCell {
    
    var modelAccess = ModelAccessFacade.init()

    
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
        //let nib = UINib(nibName: "ArtWorkCollectionViewCell", bundle: nil)
        let nib = UINib.init(nibName: "ArtWorkCollectionViewCell", bundle: nil)
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
//        var totalArts = DatabaseAccess.sharedInstance.newestArts.count
//        var totalArts = modelAccess.databaseReference.newestArts.count
        var totalArts = modelAccess.totalNumberOfArtworks()
        print("number of item in section to newestArts::::::: ", totalArts)
//        for newArts in DatabaseAccess.sharedInstance.newestArts{
//        for newArts in modelAccess.databaseReference.newestArts{
        for newArts in modelAccess.getArtworks(){
            print(newArts.title )
            print(newArts.urlPhotos)
            print("\n")
        }
        return totalArts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtWorkCollectionViewCell", for: indexPath) as! ArtWorkCollectionViewCell
  
        print(modelAccess.getArtworkAt(index: indexPath.row).title)
//        print(modelAccess.databaseReference.newestArts[indexPath.row].title)
//        print(DatabaseAccess.sharedInstance.newestArts[indexPath.row].title)
////        print(DatabaseAccess.sharedInstance.newestArts[indexPath.row].urlPhotos.first!)
        cell.artWorkImage.isHidden = false
        
//        if cell.artWorkImage.image != nil {
//
//        } else {
//        cell.artWorkImage.downloadedFrom(link: DatabaseAccess.sharedInstance.newestArts[indexPath.row].urlPhotos.first!, contentMode: .scaleAspectFill)
        cell.artWorkImage.downloadedFrom(link: modelAccess.getArtworkAt(index: indexPath.row).urlPhotos.first!, contentMode: .scaleAspectFill)
//        cell.artWorkImage.downloadedFrom(link: modelAccess.databaseReference.newestArts[indexPath.row].urlPhotos.first!, contentMode: .scaleAspectFill)
        
        
        print("row: " + String(indexPath.row))
        print("count: " + String(indexPath.count))
        print("item: " + String(indexPath.item))
        print("section: " + String(indexPath.section))
        print("max: " + String(describing: indexPath.max()))


            
        cell.artWorkImage.layer.masksToBounds = true
        cell.artWorkImage.layer.cornerRadius = 7
//        }
        
        return cell
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
//        modal.art = DatabaseAccess.sharedInstance.newestArts[indexPath.row]
//        modal.art = modelAccess.databaseReference.newestArts[indexPath.row] //replaced newestArts[indexPath.row] to modelAccess.getArtoworkAt(index)
        modal.art = modelAccess.getArtworkAt(index: indexPath.row)
        self.fatherController.present(modal, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}
