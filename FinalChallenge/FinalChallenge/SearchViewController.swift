//
//  SearchViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit
import YNSearch


class SearchViewController: YNSearchViewController, YNSearchDelegate {
    
    var modelAccess = ModelAccessFacade.init()
    var searchText: String!

    var categoryButtonClicked: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let ynSearch = YNSearch()
//        ynSearch.setCategories(value: DatabaseAccess.sharedInstance.categories)
        ynSearch.setCategories(value: modelAccess.getCategories())
        
        self.ynSearchinit()

        self.delegate = self
        
        self.setYNCategoryButtonType(type: .border)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.categoryButtonClicked = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ynSearchListViewDidScroll() {
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
    }
    
    
    func ynSearchHistoryButtonClicked(text: String) {
        self.pushViewController(text: text)
        print(text)
    }
    
    func ynCategoryButtonClicked(text: String) {
        self.categoryButtonClicked = true
        self.pushViewController(text: text)
        print(text)
    }
    
    func ynSearchListViewClicked(key: String) {
        self.pushViewController(text: key)
        print(key)
    }
    
    func ynSearchListViewClicked(object: Any) {
        print(object)
    }
    
    func ynSearchListView(_ ynSearchListView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ynSearchView.ynSearchListView.dequeueReusableCell(withIdentifier: YNSearchListViewCell.ID)!
        cell.textLabel?.text = "teste"
        
        return cell
    }
    
    func ynSearchListView(_ ynSearchListView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ynmodel = self.ynSearchView.ynSearchListView.searchResultDatabase[indexPath.row] as? YNSearchModel, let key = ynmodel.key {
        self.ynSearchView.ynSearchListView.ynSearchListViewDelegate?.ynSearchListViewClicked(key: key)
        self.ynSearchView.ynSearchListView.ynSearchListViewDelegate?.ynSearchListViewClicked(object: self.ynSearchView.ynSearchListView.database[indexPath.row])
            
            self.ynSearchView.ynSearchListView.ynSearch.appendSearchHistories(value: key)
        }
    }
    
    func pushViewController(text:String) {
        
        self.searchText = text
        self.performSegue(withIdentifier: "SearchToResults", sender: self)
    }

    func ynSearchButtonClicked(text: String) {
        print("entrou aqui no delegate")
        pushViewController(text: text)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SearchToResults" {
            let vc = segue.destination as! ResultsTVC
            vc.isCategory = categoryButtonClicked
            vc.word = searchText
        }
    }
    

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
