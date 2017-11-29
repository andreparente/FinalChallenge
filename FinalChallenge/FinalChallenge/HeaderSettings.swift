//
//  HeaderSettings.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 28/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class HeaderSettings: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!

    weak var delegate: HeaderSettingsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderSettings", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        if let imageString = User.sharedInstance.profilePictureURL {
            
            if imageString == "" {
                
            } else {
                self.profileImageView.downloadedFrom(link: imageString, contentMode: .scaleAspectFill)
                self.profileImageView.layer.masksToBounds = true
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width/2
            }
        }
    }

    @IBAction func changePicture(_ sender: Any) {
        delegate?.didTapChangePicture()
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        delegate?.didTapSaveSettings()
    }

}

protocol HeaderSettingsDelegate: class {
    func didTapChangePicture()
    func didTapSaveSettings()
}
