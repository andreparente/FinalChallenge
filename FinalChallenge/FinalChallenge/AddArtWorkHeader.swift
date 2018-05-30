//
//  AddArtWorkHeader.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 09/10/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class AddArtWorkHeader: UIView {

    var modelAccess = ModelAccessFacade.init()

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: AddArtWorkHeaderDelegate?
    var imagePicker: UIImagePickerController!
    var parent: AddArtWorkTVC!
    var pictureIndexSelected: Int!
    var indexPathSelected: IndexPath!
    
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
        delegate?.didSelectDismiss()
    }
    
    func buttonClicked(sender:UIButton) {
        //chamar funcão para carregar imagem
        self.indexPathSelected = IndexPath(item: sender.tag, section: 0)
        self.pictureIndexSelected = sender.tag
        if (imagePicker) != nil {
            
        } else {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
        }

        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        // 2
        let newPictureAction = UIAlertAction(title: "Take new Picture", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.parent.present(self.imagePicker, animated: true, completion: nil)
            
        })
        
        let choosePictureAction = UIAlertAction(title: "Choose image from album", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.parent.present(self.imagePicker, animated: true, completion: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        optionMenu.addAction(newPictureAction)
        optionMenu.addAction(choosePictureAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.delegate?.didSelectAddPicture(vc: optionMenu, index: sender.tag)
    }
}


extension AddArtWorkHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(picturesCollectionView) {
            return 3
        } else {
            return modelAccess.totalNumberOfCategories()
//            return DatabaseAccess.sharedInstance.categories.count
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
            if self.parent.artWork.images[indexPath.item] == nil {
                cell.artWorkImage.isHidden = true
                cell.addButton.isHidden = false
                cell.addButton.tag = indexPath.item
                cell.addButton.addTarget(self, action: #selector(self.buttonClicked(sender:)),
                                         for: UIControlEvents.touchUpInside)
            } else {
                cell.addButton.isHidden = true
                cell.artWorkImage.isHidden = false
                cell.artWorkImage.layer.masksToBounds = true
                cell.artWorkImage.contentMode = .scaleAspectFill
                cell.artWorkImage.image = self.parent.artWork.images[indexPath.row]
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddArtWorkCategoriesCVC", for: indexPath) as! AddArtWorkCategoriesCVC
            cell.title.text = modelAccess.getCategoryAt(index: indexPath.row)
//            cell.title.text = DatabaseAccess.sharedInstance.categories[indexPath.row]
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.vitrineDarkBlue.cgColor
            
            if cell.isSelected {
                cell.backgroundColor = UIColor.vitrineDarkBlue
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
                cell.backgroundColor = UIColor.vitrineDarkBlue
                cell.title.textColor = .white
            } else {
                cell.backgroundColor = .white
                cell.title.textColor = .black
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.isEqual(picturesCollectionView) {
            return CGSize(width: 100, height: 100)
        } else {
            return CGSize(width: self.modelAccess.getCategoryAt(index: indexPath.row).width(withConstraintedHeight: 0, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)) + 30, height: self.modelAccess.getCategoryAt(index: indexPath.row).height(withConstrainedWidth: 0, font: UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)) + 15)
//            return CGSize(width: DatabaseAccess.sharedInstance.categories[indexPath.row].width(withConstraintedHeight: 0, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)) + 30, height: DatabaseAccess.sharedInstance.categories[indexPath.row].height(withConstrainedWidth: 0, font: UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)) + 15)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(picturesCollectionView) {
            self.pictureIndexSelected = indexPath.item
            self.indexPathSelected = indexPath
            //fetch pictures
            let cell = collectionView.cellForItem(at: indexPath) as! PictureCVC
            if (imagePicker) != nil {
                
            } else {
                imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
            }

            if cell.artWorkImage.isHidden {
                //chamar funcão para carregar imagem
                // 1
                let optionMenu = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
                
                // 2
                let newPictureAction = UIAlertAction(title: "Take new Picture", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.allowsEditing = true
                    self.parent.present(self.imagePicker, animated: true, completion: nil)
                    
                })
                
                let choosePictureAction = UIAlertAction(title: "Choose image from album", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.imagePicker.sourceType = .photoLibrary
                    self.imagePicker.allowsEditing = true
                    self.parent.present(self.imagePicker, animated: true, completion: nil)
                })
                
                //
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                    (alert: UIAlertAction!) -> Void in
                })
                
                
                // 4
                optionMenu.addAction(newPictureAction)
                optionMenu.addAction(choosePictureAction)
                optionMenu.addAction(cancelAction)
                
                // 5
                self.delegate?.didSelectAddPicture(vc: optionMenu, index: indexPath.item)
            } else {
                //chamar alert para perguntar se quer alterar a foto
            }
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! AddArtWorkCategoriesCVC
            cell.backgroundColor = UIColor.vitrineDarkBlue
            cell.title.textColor = .white
            delegate?.didSelectCategory(category: cell.title.text!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(picturesCollectionView) {
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? AddArtWorkCategoriesCVC {
                cell.backgroundColor = .white
                cell.title.textColor = .black
                delegate?.didSelectCategory(category: cell.title.text!)
            }
        }
    }

}


protocol AddArtWorkHeaderDelegate: class {
    func didSelectCategory(category: String)
    func didSelectAddPicture(vc: UIAlertController, index: Int)
    func didSelectDismiss()
}

extension AddArtWorkHeader: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            for i in 0 ..< self.parent.artWork.images.count {
                if self.parent.artWork.images[i] == nil {
                    if i == self.pictureIndexSelected {
                        self.parent.artWork.images[i] = picture
                       // self.picturesCollectionView.reloadData()
                        self.picturesCollectionView.reloadItems(at: [self.indexPathSelected])
                    }
                }
            }
        }
    }
}
