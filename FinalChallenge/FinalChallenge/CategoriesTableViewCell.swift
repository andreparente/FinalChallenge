//
//  CategoriesTableViewCell.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    var collectionView: UICollectionView!
    var collectionReuseIdentifier = "CategoryCollectionViewCell"
    var fatherController: HomeTVC!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.frame.size.height = 100
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 100), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UINib(nibName: "AddArtWorkCategoriesCVC", bundle: nil), forCellWithReuseIdentifier: "AddArtWorkCategoriesCVC")
        collectionView.isPagingEnabled = true
        self.addSubview(collectionView)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}


extension CategoriesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatabaseAccess.sharedInstance.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddArtWorkCategoriesCVC", for: indexPath) as! AddArtWorkCategoriesCVC
        
        
        cell.title.text = DatabaseAccess.sharedInstance.categories[indexPath.row]
        cell.layer.cornerRadius = 7

        
        
        // ESTHER, mudar a cor para branco
        cell.title.textColor = UIColor.white
        cell.title.font = UIFont(name: "Lato-Medium", size: 18)
        
        
        // ESTHER, adicionar a imagem aqui
        cell.backgroundImage.image = DatabaseAccess.sharedInstance.categoriesImages[indexPath.row]
        cell.backgroundImage.layer.masksToBounds = true
        cell.backgroundImage.contentMode = .scaleAspectFill
        
//        
//        if let layers = cell.layer.sublayers {
//            if layers.count > 1 {
//                
//            } else {
//                cell.layer.insertSublayer(Gradient.sharedInstance.bluePinkGradient(view: cell, horizontal: true), at: 0)
//            }
//        } else {
//            cell.layer.insertSublayer(Gradient.sharedInstance.bluePinkGradient(view: cell, horizontal: true), at: 0)
//        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.fatherController.view.frame.width/2 - 10, height: 90)
     //   return CGSize(width: DatabaseAccess.sharedInstance.categories[indexPath.item].width(withConstraintedHeight: 0, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)) + 30, height: DatabaseAccess.sharedInstance.categories[indexPath.item].height(withConstrainedWidth: 0, font: UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)) + 15)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CGFloat(0), height: CGFloat(0))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //ir para a tela de videos da modalidade x
        
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) {
            let bounds = selectedCell.contentView.bounds
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [.curveEaseIn, .curveEaseOut], animations: {
                    
                    selectedCell.bounds = CGRect(x: bounds.origin.x - 5, y: bounds.origin.y, width: bounds.size.width + 5, height: bounds.size.height)
                    
                }) { (success: Bool) in
                    if success {
                        selectedCell.bounds = bounds
                        self.fatherController.categorySelected = DatabaseAccess.sharedInstance.categories[indexPath.row]
                        self.fatherController.performSegue(withIdentifier: "HomeToCategory", sender: self.fatherController)
                    }
                }
            
        }
        
        

        

        
        

        

    }
}
