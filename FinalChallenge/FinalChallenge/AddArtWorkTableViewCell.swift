//
//  AddArtWorkTableViewCell.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 09/10/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class AddArtWorkTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var txtView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtView.text = ""
        self.txtView.textColor = UIColor.lightGray
        self.txtView.delegate = self
        self.txtView.layer.borderColor = UIColor.vitrineDarkBlue.cgColor
        self.txtView.layer.cornerRadius = 10
        self.txtView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension AddArtWorkTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.text = ""
            textView.textColor = UIColor.lightGray
        } else {
        }
    }
}
