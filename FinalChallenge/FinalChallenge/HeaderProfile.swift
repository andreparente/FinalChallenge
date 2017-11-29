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
 
    weak var delegate: HeaderProfileDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
                if User.sharedInstance.cachedImage != nil {
                    self.profileImage.image = User.sharedInstance.cachedImage
                } else {
                    self.profileImage.downloadedFrom(url: URL(string: imageString)!, contentMode: .scaleAspectFill) { (image: UIImage?) in
                        User.sharedInstance.cachedImage = image
                        }
                }
                self.profileImage.layer.masksToBounds = true
                self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
            }
        }
    }
    
    @IBAction func didTapLogOut(_ sender: Any) {
        delegate?.didTapLogOut()
    }
}

protocol HeaderProfileDelegate: class {
    func didTapLogOut()
}


