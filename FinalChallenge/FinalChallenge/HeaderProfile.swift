//
//  HeaderProfile.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class HeaderProfile: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var inboxButton: UIButton!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(Gradient.sharedInstance.bluePinkGradient(view: self, vertical: false))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.addSublayer(Gradient.sharedInstance.bluePinkGradient(view: self, vertical: false))
        commonInit()
    }

    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderProfile", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        print(User.sharedInstance.profilePictureURL)
        self.profileNameLbl.text = User.sharedInstance.name
        if let imageString = User.sharedInstance.profilePictureURL {
            
            if imageString == "" {
                
            } else {
                self.profileImage.downloadedFrom(url: URL(string: imageString)!)
            }
        }
    }
}


