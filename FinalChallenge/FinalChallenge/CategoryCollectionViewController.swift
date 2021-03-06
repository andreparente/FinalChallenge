//
//  CategoryCollectionViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 10/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {

    var modelAccess : ModelAccessFacade!

    
    var categoryArtWorks: [ArtWork] = []
    var isList: Bool = true
    var categoryName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelAccess = ModelAccessFacade.init()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "ArtWorkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtWorkCollectionViewCell")
        self.collectionView!.register(UINib(nibName: "CategoryHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "CategoryHeader")
        
        self.collectionView!.register(UINib(nibName: "FooterCategoryCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "FooterCategory")

        self.navigationController?.navigationBar.isHidden = true
        
        modelAccess.fetchArtWorksFor(category: categoryName) { (success: Bool, response: String, auxArtWorks: [ArtWork]) in
            if success {
                self.categoryArtWorks = auxArtWorks
                if self.collectionView?.numberOfSections == 0 {
                    self.collectionView?.reloadData()
                } else {
                    self.collectionView?.reloadSections([0,auxArtWorks.count])
                }
            } else {
                print(response)
                self.showAlert(title: "Erro", message: "Não foi possível carregar as obras de \(self.categoryName), tente novamente mais tarde")

            }
        }
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
        return categoryArtWorks.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtWorkCollectionViewCell", for: indexPath) as! ArtWorkCollectionViewCell
    
        // Configure the cell
        if cell.artWorkImage.image == nil {
            if self.categoryArtWorks[indexPath.section].currentImage != nil {
                cell.artWorkImage.image = self.categoryArtWorks[indexPath.section].currentImage
                cell.artWorkImage.layer.masksToBounds = true
            } else {
                if let picture = categoryArtWorks[indexPath.section].urlPhotos.first {
                    if let url = URL(string: picture) {
                        cell.artWorkImage.downloadedFrom(url: url, contentMode: .scaleAspectFill, callback: { (image: UIImage?) in
                            self.categoryArtWorks[indexPath.section].currentImage = image
                        })
                    }
                }
            }
        }
        return cell
    }
    
    
    //footer with title and artist name
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            if indexPath.section == 0 {
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoryHeader", for: indexPath as IndexPath) as! CategoryHeaderCollectionReusableView
                headerView.categoryLbl.text = self.categoryName
                headerView.delegate = self
                headerView.backgroundColor = .white
                if isList {
                    headerView.listButton.isSelected = true
                    headerView.squareButton.isSelected = false
                } else {
                    headerView.listButton.isSelected = false
                    headerView.squareButton.isSelected = true
                    
                }
                return headerView
            } else {
                return UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            }
        case UICollectionElementKindSectionFooter:
            if isList {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterCategory", for: indexPath as IndexPath) as! FooterCategoryCollectionReusableView
                footerView.artistName.text = categoryArtWorks[indexPath.section].creatorName
                footerView.artWorkTitle.text = categoryArtWorks[indexPath.section].title
                return footerView
            } else {
                return UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            }
            
        default:
            assert(false, "Unexpected element kind")
            return UIView() as! UICollectionReusableView
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isList {
            return CGSize(width: self.view.frame.width, height: self.view.frame.width)
        } else {
            return CGSize(width: CGFloat(80), height: CGFloat(80))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return  CGSize(width: self.view.frame.width, height: 180)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isList {
            return CGSize(width: self.view.frame.width, height: 65)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "ArtWorkDetail") as! ArtWorkDetailViewController
        modal.art = categoryArtWorks[indexPath.section]
        self.present(modal, animated: true, completion: nil)
    }
    
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

}


extension CategoryCollectionViewController: CategoryHeaderDelegate {
    func didTapReturnView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapListVisualization() {
        //setar para visualização do tipo lista (aumentar o tamanho da celula praticamente)
        self.isList = true
        self.collectionView?.reloadData()
    }
    
    func didTapSquareVisualization() {
        //setar para 3 quadrados por linha, diminuir tamanho da celula
        self.isList = false
        self.collectionView?.reloadData()
    }
}
