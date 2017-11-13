//
//  CategoryHeaderCollectionReusableView.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 10/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class CategoryHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var categoryLbl: UILabel!
    
    weak var delegate: CategoryHeaderDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReturnView)))
    }
    
    @IBAction func didTapSquare(_ sender: UIButton) {
        //fazer as mudanças dos botoes aqui dentro
        self.delegate?.didTapSquareVisualization()
        self.listButton.isSelected = false
        self.squareButton.isSelected = true

    }
    
    @IBAction func didTapList(_ sender: UIButton) {
        //fazer as mudancas dos botoes aqui dentro
        self.delegate?.didTapListVisualization()
        self.squareButton.isSelected = false
        self.listButton.isSelected = true

    }
    
    func didTapReturnView() {
        self.delegate?.didTapReturnView()
    }
}

protocol CategoryHeaderDelegate: class {
    func didTapSquareVisualization()
    func didTapListVisualization()
    func didTapReturnView()
}
