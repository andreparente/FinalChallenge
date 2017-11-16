//
//  ProfileCollectionViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/09/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProfileCollectionViewCell"

class ProfileCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var hasChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if User.sharedInstance.favoriteArtists.isEmpty ||  User.sharedInstance.favoriteArtists.count == 0 {
            DatabaseAccess.sharedInstance.fetchFollowedArtistsFor(user: User.sharedInstance, callback: { (success: Bool, response: String) in
                if success{
                    for artist in User.sharedInstance.favoriteArtists{
                        print(artist.name)
                    }
                }
                else{
                    print("deu erro")
                }
            })
        }

        
        if User.sharedInstance.favoriteArts.isEmpty ||  User.sharedInstance.favoriteArts.count == 0 {
            DatabaseAccess.sharedInstance.fetchLikedArtWorksFor(user: User.sharedInstance, callback:   { ( success: Bool, response: String) in
                if success{
                    for arts in User.sharedInstance.favoriteArts{
                        print(arts.title)
                    }
                }
                else{
                    print("deu erro")
                }
            })
        }
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib(nibName: "CustomProfileHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "Header")
        self.collectionView?.register(UINib(nibName: "ProfileFooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "ProfileFooter")

        self.collectionView?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch indexSelected {
        case 0:
            return User.sharedInstance.artWorks.count
        case 1:
            return User.sharedInstance.favoriteArts.count
        default:
            return User.sharedInstance.favoriteArtists.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCollectionViewCell

        if hasChanged {
            cell.artWorkImage.image = nil
            cell.artistImage.image = nil
        }
        
        switch indexSelected {
        case 0:
            cell.artWorkImage.isHidden = false
            cell.artistImage.isHidden = true
            cell.artistNameLbl.isHidden = true
            cell.artWorkImage.layer.masksToBounds = true
        case 1:
            cell.artWorkImage.isHidden = false
            cell.artistImage.isHidden = true
            cell.artistNameLbl.isHidden = true
            cell.artWorkImage.layer.masksToBounds = true
            cell.artWorkImage.downloadedFrom(link: User.sharedInstance.favoriteArts[indexPath.item].urlPhotos.first!, contentMode: .scaleAspectFill)
        default:
            cell.artWorkImage.isHidden = true
            cell.artistImage.isHidden = false
            cell.artistNameLbl.isHidden = false
            cell.artistNameLbl.text = User.sharedInstance.favoriteArtists[indexPath.item].name
            cell.artistImage.downloadedFrom(link: User.sharedInstance.favoriteArtists[indexPath.item].profilePictureURL, contentMode: .scaleAspectFill)
            cell.artistImage.layer.masksToBounds = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexSelected {
        case 0:
            return CGSize(width: collectionView.frame.size.width/3 - 1, height: collectionView.frame.size.width/3)
        case 1:
            return CGSize(width: collectionView.frame.size.width/3 - 1, height: collectionView.frame.size.width/3)
        default:
            return CGSize(width: collectionView.frame.size.width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if indexSelected == 0 {
            if User.sharedInstance.artWorks.count < 3 {
                return CGSize(width: self.view.frame.width, height: 55)
            } else {
                return CGSize(width: 0, height: 0)
            }
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath as IndexPath) as! CustomProfileHeaderCollectionReusableView
            
            headerView.middleProfile.delegate = self
            headerView.middleProfile.numberOfArtWorksLbl.text = "\(User.sharedInstance.artWorks.count)"
            headerView.middleProfile.numberOfLikesLbl.text = "\(User.sharedInstance.favoriteArtsIds.count)"
            headerView.middleProfile.numberOfFavArtistsLbl.text = "\(User.sharedInstance.favoriteArtistsIds.count)"

            headerView.backgroundColor = .white
            return headerView
            
        case UICollectionElementKindSectionFooter:
            print(indexSelected)
            if indexSelected == 0 {
                if User.sharedInstance.artWorks.count < 3 {
                    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileFooter", for: indexPath as IndexPath) as! ProfileFooterCollectionReusableView
                    footerView.button.addTarget(self, action: #selector(addArtWork), for: .touchUpInside)
                    footerView.button.setTitleColor(UIColor.vitrineDarkBlue, for: .normal)
                    footerView.button.layer.cornerRadius = 10
                    footerView.button.layer.borderColor = UIColor.vitrineDarkBlue.cgColor
                    footerView.button.layer.borderWidth = 1
                    return footerView
                }
            }
            return UIView() as! UICollectionReusableView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func addArtWork() {
        self.performSegue(withIdentifier: "ProfileToAddArtWork", sender: self)
    }
}




// MARK: UICollectionViewDelegate

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
 return true
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
 return true
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
 return false
 }
 
 override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
 return false
 }
 
 override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
 
 }
 */

extension ProfileCollectionViewController: MiddleProfileDelegate {
    
    func artWorksSelected() {
        //  carregar as artes do proprio usuário, se ele tiver.
        self.hasChanged = true
        self.collectionView?.reloadData()
        
    }
    
    func favArtistsSelected() {
        //   mostrar os artistas que ele segue/favoritou
        self.hasChanged = true
        self.collectionView?.reloadData()
        
    }
    
    func favArtWorksSelected() {
        //  mostrar as obras que ele curtiu!
        self.hasChanged = true
        self.collectionView?.reloadData()
        
    }
    
}

extension ProfileCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickImg(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: {})
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            print((originalImage as! UIImage).size)
            selectedImageFromPicker = originalImage as? UIImage
        }
        else if let croppedImage = info["UIImagePickerControllerEditedImage"]{
            print((croppedImage as! UIImage).size)
            selectedImageFromPicker = croppedImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            DatabaseAccess.sharedInstance.uploadProfileImage(image: selectedImage, callback: { (success: Bool, response: String) in
                if success {
                    //deu certo pra guardar imagem
                    
                } else {
                    //deu ruim pra guardar imagem
                    
                }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picking image cancelled")
    }
}
