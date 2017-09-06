//
//  HeaderViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 06/09/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderProfile!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.profileNameLbl.text = "André Parente"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
