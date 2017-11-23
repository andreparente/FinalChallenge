//
//  AddArtWorkCategoriesCVC.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 25/10/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class AddArtWorkCategoriesCVC: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 8
    }

}
