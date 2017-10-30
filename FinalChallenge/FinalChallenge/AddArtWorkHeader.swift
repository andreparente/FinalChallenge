//
//  AddArtWorkHeader.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 09/10/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class AddArtWorkHeader: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: AddArtWorkHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("AddArtWorkHeader", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.allowsMultipleSelection = false
        categoriesCollectionView.register(UINib(nibName: "AddArtWorkCategoriesCVC", bundle: nil), forCellWithReuseIdentifier: "AddArtWorkCategoriesCVC")
        picturesCollectionView.register(UINib(nibName: "PictureCVC", bundle: nil), forCellWithReuseIdentifier: "PictureCell")
        
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
    }
}


extension AddArtWorkHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(picturesCollectionView) {
            return 3
        } else {
            return DatabaseAccess.sharedInstance.categories.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CGFloat(10), height: CGFloat(10))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.isEqual(picturesCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCVC
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddArtWorkCategoriesCVC", for: indexPath) as! AddArtWorkCategoriesCVC
            cell.title.text = DatabaseAccess.sharedInstance.categories[indexPath.row]
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.customLightBlue.cgColor
            
            if cell.isSelected {
                cell.backgroundColor = UIColor.customLightBlue
                cell.title.textColor = .white
            } else {
                cell.backgroundColor = .white
                cell.title.textColor = .black
            }
            return cell
        }
        
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView.isEqual(categoriesCollectionView) {
            let cell = cell as! AddArtWorkCategoriesCVC
            if cell.isSelected {
                cell.backgroundColor = UIColor.customLightBlue
                cell.title.textColor = .white
            } else {
                cell.backgroundColor = .white
                cell.title.textColor = .black
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.isEqual(picturesCollectionView) {
            return CGSize(width: 90, height: 110)
        } else {
            return CGSize(width: DatabaseAccess.sharedInstance.categories[indexPath.row].width(withConstraintedHeight: 0, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)) + 30, height: DatabaseAccess.sharedInstance.categories[indexPath.row].height(withConstrainedWidth: 0, font: UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)) + 15)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(picturesCollectionView) {
            //fetch pictures
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! AddArtWorkCategoriesCVC
            cell.backgroundColor = UIColor.customLightBlue
            cell.title.textColor = .white
            delegate?.didSelectCategory(category: cell.title.text!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(picturesCollectionView) {
            //fetch pictures
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? AddArtWorkCategoriesCVC {
                cell.backgroundColor = .white
                cell.title.textColor = .black
            }
        }
    }

}


protocol AddArtWorkHeaderDelegate: class {
    func didSelectCategory(category: String)
}
