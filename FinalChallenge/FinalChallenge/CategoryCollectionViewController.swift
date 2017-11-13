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

    var categoryArtWorks: [ArtWork] = []
    var isList: Bool = true
    var categoryName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "ArtWorkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArtWorkCollectionViewCell")
        self.collectionView!.register(UINib(nibName: "CategoryHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "CategoryHeader")
        

        self.navigationController?.navigationBar.isHidden = true
        
        DatabaseAccess.sharedInstance.fetchArtWorksFor(category: categoryName) { (success: Bool, response: String, auxArtWorks: [ArtWork]) in
            if success {
                self.categoryArtWorks = auxArtWorks
                self.collectionView?.reloadSections([0])
            } else {
                print(response)
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
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArtWorks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtWorkCollectionViewCell", for: indexPath) as! ArtWorkCollectionViewCell
    
        // Configure the cell
        if let picture = categoryArtWorks[indexPath.item].urlPhotos.first {
            cell.artWorkImage.downloadedFrom(link: picture, contentMode: .scaleAspectFill)
            cell.artWorkImage.layer.masksToBounds = true

        }
        
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoryHeader", for: indexPath as IndexPath) as! CategoryHeaderCollectionReusableView
            headerView.categoryLbl.text = self.categoryName
            headerView.delegate = self
            headerView.backgroundColor = .white
            return headerView
            
        case UICollectionElementKindSectionFooter:
            return UIView() as! UICollectionReusableView
            
        default:
            
            assert(false, "Unexpected element kind")
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
        return  CGSize(width: self.view.frame.width, height: 180)
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
        self.collectionView?.reloadSections([0])
    }
    
    func didTapSquareVisualization() {
        //setar para 3 quadrados por linha, diminuir tamanho da celula
        self.isList = false
        self.collectionView?.reloadSections([0])
    }
}
