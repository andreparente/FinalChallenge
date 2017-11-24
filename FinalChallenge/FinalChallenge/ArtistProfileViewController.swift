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

    var artist: Artist!
    
    @IBOutlet weak var headerView: UIView!
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
        
        
        if User.sharedInstance.favoriteArtistsIds.contains(artist.id) {
            followButton.setTitle("Unfollow", for: .normal)
        }

        
        //aqui preencher de acordo com a escolha do cara
        if let estilo = artist.getGalleryStyle() {
            artWorkCarousel.type = estilo
        } else {
            artWorkCarousel.type = .linear
        }
        nameLbl.text = artist.name

        //chamar fetch para pegar as artes a partir de um user/ir no nó do user, pegar as ids das artes, ir no nó das artes, e recuperar as infos. [OLENKA]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapFollowArtist(_ sender: UIButton) {
        //fazer animação
        DatabaseAccess.sharedInstance.databaseAccessWriteFollowArtist(user: User.sharedInstance, artist: self.artist, callback: { (success: Bool, response: String) in
            if success {
                print(response)
            } else {
                print(response)
            }
        })
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
        let cellView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - self.headerView.frame.maxX))
        let artWorkImage = UIImageView(frame: CGRect(x: 15, y: 20, width: self.view.frame.width - 30, height: cellView.frame.height - 40))
        artWorkImage.downloadedFrom(link: artist.artWorks[index].urlPhotos[0], contentMode: .scaleAspectFill)
        artWorkImage.layer.masksToBounds = true
        let artWorkTitle = UILabel(frame: CGRect(x: 15, y: artWorkImage.frame.maxY + 5, width: artWorkImage.frame.width, height: 30))
        artWorkTitle.textColor = .black
        artWorkTitle.textAlignment = .right
        artWorkTitle.text = artist.artWorks[index].title
        cellView.addSubview(artWorkImage)
        cellView.addSubview(artWorkTitle)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap2.numberOfTapsRequired = 2

        cellView.addGestureRecognizer(tap2)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap1.numberOfTapsRequired = 1
        cellView.addGestureRecognizer(tap1)
        return cellView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func doubleTapped() {
        //fazer Animação
        DatabaseAccess.sharedInstance.databaseAccessWriteLikeArtWork(artwork: artist.artWorks[self.artWorkCarousel.currentItemIndex]) { (success: Bool, response: String) in
            if success {
                print("DEU CERTO PORRA")
            } else {
                print(response)
            }
        }
    }
    
    func singleTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyboard.instantiateViewController(withIdentifier: "ArtWorkDetail") as! ArtWorkDetailViewController
        modal.art = artist.artWorks[self.artWorkCarousel.currentItemIndex]
        self.present(modal, animated: true, completion: nil)
    }

}
