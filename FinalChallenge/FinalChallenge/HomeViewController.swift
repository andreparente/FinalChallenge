//
//  HomeViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var fatherTableView: UITableView!
    var reuseIdentifier = "CustomCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        // Do any additional setup after loading the view.
    }
    
    func setTableView() {
        self.fatherTableView = UITableView(frame: CGRect(x: 15, y: 25, width: self.view.frame.width - 30, height: self.view.frame.height - 15)
, style: .plain)
        self.fatherTableView.delegate = self
        self.fatherTableView.dataSource = self
        fatherTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
      //  tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "NormalCell")
        self.fatherTableView.tableFooterView = UIView()
        self.view.addSubview(fatherTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CustomTableViewCell
        cell.fatherController = self
        switch indexPath.section {
        case 0:
            print("categorias")
        case 1:
            print("artistas")
        default:
            print("eventos")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30))
        switch section {
        case 0:
            print("categorias")
            label.text = "Categorias"
        case 1:
            print("artistas")
            label.text = "Artistas"
        default:
            print("eventos")
            label.text = "Eventos"
        }
        label.textColor = .black
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
