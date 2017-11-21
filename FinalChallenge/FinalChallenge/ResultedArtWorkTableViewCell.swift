//
//  ResultedArtWorkTableViewCell.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 21/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class ResultedArtWorkTableViewCell: UITableViewCell {

    @IBOutlet weak var artWorkImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creatorName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
