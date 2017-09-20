//
//  SearchViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var tableView: UITableView!
    var arrayOfNames: [String] = ["Letícia Parente","Belchior","Eu","Belchior","Teste Parente","Bruno Parente","Valdo Parente","Gabriela Parente","Lia Parente","Letícia Parente","Letícia Parente","Belchior","Eu","Belchior","Teste Parente","Bruno Parente","Valdo Parente","Gabriela Parente","Lia Parente","Letícia Parente"]
    var abc = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","x","z"]
    var profileImage = [UIImage(named: "profileImage1.jpg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .grouped)
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
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
//
//
//extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return arrayOfNames.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
//        cell.textLabel?.text = arrayOfNames[indexPath.section]
//        return cell
//    }
//    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return abc
//    }
//    
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        
//        
//        let temp = abc as NSArray
//        return temp.index(of:title)
//        
//    }
//}
