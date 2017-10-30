//
//  ArtistProfileViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 27/10/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit
import iCarousel

class ArtistProfileViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    var artist: User!
    
    @IBOutlet weak var artWorkCarousel: iCarousel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailButton.layer.shadowColor = UIColor.black.cgColor
        emailButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        emailButton.layer.shadowRadius = 3
        
        followButton.layer.shadowColor = UIColor.black.cgColor
        followButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        followButton.layer.shadowRadius = 3

        
        //aqui preencher de acordo com a escolha do cara
        artWorkCarousel.type = artist.getGalleryStyle()
        nameLbl.text = artist.name

        //chamar fetch para pegar as artes a partir de um user/ir no nó do user, pegar as ids das artes, ir no nó das artes, e recuperar as infos. [OLENKA]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapFollowArtist(_ sender: UIButton) {
    }

    @IBAction func didTapSendEmail(_ sender: UIButton) {
    }
    @IBAction func didTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return artist.artWorks.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
      //  label.text = "\(items[index])"
        
        //setar a view de acordo com a obra (será a foto inteira?) Esther
        var view = UIView()
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }

}
