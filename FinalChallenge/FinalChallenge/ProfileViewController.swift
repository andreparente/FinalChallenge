//
//  ProfileViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class ProfileViewController: SJSegmentedViewController {

    var fatherTableView: UITableView!
    var view1 = UILabel()
    var view2 = UILabel()
    var view3 = UILabel()
    
    override func viewDidLoad() {
        self.sjViewControllerSetup()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sjViewControllerSetup() {
        if let storyboard = self.storyboard {
            
            let headerVC = storyboard.instantiateViewController(withIdentifier: "HeaderVC") as! HeaderViewController
            
            let likesVC = storyboard.instantiateViewController(withIdentifier: "LikesVC") as! LikesViewController
            
            // ------ isso é gambiarra pra teste
           
            view1.frame.size.width = 80
            view1.text = "n\nobras curtidas"
            view1.textAlignment = .center
            view1.numberOfLines = 2
            likesVC.navigationItem.titleView = view1
            // -------- end of gambiarra

            
            let followingVC = storyboard.instantiateViewController(withIdentifier: "FollowingVC") as! FollowingViewController
            
            // ------ isso é gambiarra pra teste
            
            view2.frame.size.width = 80
            view2.text = "n\nseguidores"
            view2.textAlignment = .center
            view2.numberOfLines = 2
            followingVC.navigationItem.titleView = view2
            // -------- end of gambiarra

            
            let artWorksVC = storyboard.instantiateViewController(withIdentifier: "ArtWorksVC") as! ArtWorksViewController
            
            // ------ isso é gambiarra pra teste

            view3.frame.size.width = 80
            view3.text = "n\nobras"
            view3.textAlignment = .center
            view3.numberOfLines = 2
            artWorksVC.navigationItem.titleView = view3
            // -------- end of gambiarra
            
            self.selectedSegmentViewColor = .gray
            self.headerViewController = headerVC
            self.headerViewHeight = 240
            self.segmentControllers = [likesVC, followingVC,artWorksVC]
            self.segmentViewHeight = 60
            self.delegate = self
            self.segmentShadow = .init(offset: CGSize(width: 0, height: 0), color: .clear, radius: 0, opacity: 0)
            self.selectedSegmentViewColor = .clear
        }
    }
}


extension ProfileViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        self.segments[index].frame.size.width = self.view.frame.width/3
        switch index {
        case 0:
            self.view1.textColor = UIColor.customLightBlue
            self.view2.textColor = .lightGray
            self.view3.textColor = .lightGray
        case 1:
            self.view1.textColor = .lightGray
            self.view2.textColor = UIColor.customLightBlue
            self.view3.textColor = .lightGray
        default:
            self.view1.textColor = .lightGray
            self.view2.textColor = .lightGray
            self.view3.textColor = UIColor.customLightBlue

        }
    }
}
