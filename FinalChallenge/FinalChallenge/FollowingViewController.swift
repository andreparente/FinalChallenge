//
//  InteterestsViewController.swift
//  ChallengeSocial
//
//  Created by Gabriel Oliveira on 3/6/17.
//  Copyright © 2017 Gabriel Oliveira. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController {
    private var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewSetUp()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func tableViewSetUp() {
//        let tableViewRect = CGRect(x: 0, y: 0, width: width, height: height)
//        let tableViewCellNib = UINib(nibName: "CustomActivityCell", bundle: nil)
//        
//        self.tableView = UITableView(frame: tableViewRect , style: .plain)
//        self.tableView.dataSource = self
//        self.tableView.rowHeight = height / 8.4
//        self.tableView.register(tableViewCellNib, forCellReuseIdentifier: "idNormalCell")
//        self.tableView.clipsToBounds = true
//        
//        self.view.addSubview(tableView)
    }
}

//extension FollowingViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return currentUser.categories.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell: CustomActivityCell
//        let cellName = currentUser.categories[indexPath.row]
//        let cellImage = getCategory(cellName).icon
//        
//        cell = tableView.dequeueReusableCell(withIdentifier: "idNormalCell", for: indexPath as IndexPath) as! CustomActivityCell
//        cell.labelNome.text = cellName
//        cell.icon?.image = cellImage
//        cell.selectionStyle = .none
//        cell.check.isHidden = true
//        
//        return cell
//    }
//}
