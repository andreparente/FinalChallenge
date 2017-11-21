//
//  ArtistsHeader.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 21/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class ArtistsHeader: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backView: UIView!
    
    weak var delegate: ArtistsHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ArtistsHeader", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReturnView)))
        
    }
    
    func didTapReturnView() {
        //delegar a funcao para a view controller\
        print("return to creators")
        self.delegate?.didTapReturnView()
    }
}

protocol ArtistsHeaderDelegate: class {
    func didTapReturnView()
}
