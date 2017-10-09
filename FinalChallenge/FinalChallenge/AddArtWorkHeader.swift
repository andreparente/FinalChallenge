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
    @IBOutlet weak var addPictureButton: UIButton!
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
    }
}
