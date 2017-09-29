//
//  MiddleProfile.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

var indexSelected: Int = 0
class MiddleProfile: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var artWorksView: UIView!
    @IBOutlet weak var numberOfArtWorksLbl: UILabel!
    @IBOutlet weak var artWorksLbl: UILabel!
    @IBOutlet weak var favArtsView: UIView!
    @IBOutlet weak var numberOfLikesLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var favArtists: UIView!
    @IBOutlet weak var numberOfFavArtistsLbl: UILabel!
    @IBOutlet weak var favoriteArtistsLbl: UILabel!
    
    weak var delegate: MiddleProfileDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MiddleProfile", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.artWorksView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MiddleProfile.setArtWorksSelected)))
        self.favArtsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MiddleProfile.setFavArtWorksSelected)))
        self.favArtists.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MiddleProfile.setFavArtistsSelected)))
        indexSelected = 0
        
        self.artWorksLbl.textColor = UIColor(red: 54/255, green: 94/255, blue: 219/255, alpha: 1)
        self.numberOfArtWorksLbl.textColor = UIColor(red: 54/255, green: 94/255, blue: 219/255, alpha: 1)
        
        self.favoriteArtistsLbl.textColor = UIColor.lightGray
        self.numberOfFavArtistsLbl.textColor = UIColor.lightGray
        
        self.likesLbl.textColor = UIColor.lightGray
        self.numberOfLikesLbl.textColor = UIColor.lightGray

    }
    
    
    func setArtWorksSelected() {
        
        indexSelected = 0

        self.artWorksLbl.textColor = UIColor(red: 54/255, green: 94/255, blue: 219/255, alpha: 1)
        self.numberOfArtWorksLbl.textColor = UIColor(red: 54/255, green: 94/255, blue: 219/255, alpha: 1)

        self.favoriteArtistsLbl.textColor = UIColor.lightGray
        self.numberOfFavArtistsLbl.textColor = UIColor.lightGray
        
        self.likesLbl.textColor = UIColor.lightGray
        self.numberOfLikesLbl.textColor = UIColor.lightGray
        
        self.delegate?.artWorksSelected()
    }
    
    func setFavArtWorksSelected() {
        
        indexSelected = 1

        self.artWorksLbl.textColor = UIColor.lightGray
        self.numberOfArtWorksLbl.textColor = UIColor.lightGray
        
        self.favoriteArtistsLbl.textColor = UIColor.lightGray
        self.numberOfFavArtistsLbl.textColor = UIColor.lightGray
        
        self.likesLbl.textColor = UIColor(red: 54/255, green: 94/255, blue: 219/255, alpha: 1)
        self.numberOfLikesLbl.textColor = UIColor(red: 54/255, green: 94/255, blue: 219/255, alpha: 1)
        
        self.delegate?.favArtWorksSelected()
    }
    
    func setFavArtistsSelected() {
        
        indexSelected = 2

        self.artWorksLbl.textColor = UIColor.lightGray
        self.numberOfArtWorksLbl.textColor = UIColor.lightGray
        
        self.favoriteArtistsLbl.textColor = UIColor(red: 54/255, green: 94/255, blue: 219/255, alpha: 1)
        self.numberOfFavArtistsLbl.textColor = UIColor(red: 54/255, green: 94/255, blue: 219/255, alpha: 1)
        
        self.likesLbl.textColor = UIColor.lightGray
        self.numberOfLikesLbl.textColor = UIColor.lightGray
        self.delegate?.favArtistsSelected()
    }
}


protocol MiddleProfileDelegate: class {
    func artWorksSelected()
    func favArtistsSelected()
    func favArtWorksSelected()
}
