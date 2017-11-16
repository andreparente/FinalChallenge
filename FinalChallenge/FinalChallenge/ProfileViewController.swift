//
//  ProfileViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    
    var headerView: HeaderProfile!
    var middleView: MiddleProfile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setHeaderView()
        self.tableView.tableHeaderView = headerView
        self.tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    func setHeaderView() {
        self.headerView = HeaderProfile(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
        self.headerView.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.pickImg)))
    }
    
    func setMiddleView() {
        self.middleView = MiddleProfile(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        self.middleView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.fatherController = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(self.view.frame.height)
        return (self.view.frame.height - 50)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.setMiddleView()
        return middleView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
        
    }
}

extension ProfileViewController: MiddleProfileDelegate {
    
    func artWorksSelected() {
        //  carregar as artes do proprio usuário, se ele tiver.
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        
    }
    
    func favArtistsSelected() {
        //   mostrar os artistas que ele segue/favoritou
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .top)

        
    }
    
    func favArtWorksSelected() {
        //  mostrar as obras que ele curtiu!
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .top)

    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickImg(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: {})
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            print((originalImage as! UIImage).size)
            selectedImageFromPicker = originalImage as? UIImage
        }
        else if let croppedImage = info["UIImagePickerControllerEditedImage"]{
            print((croppedImage as! UIImage).size)
            selectedImageFromPicker = croppedImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            DatabaseAccess.sharedInstance.uploadProfileImage(image: selectedImage, callback: { (success: Bool, response: String) in
                if success {
                    //deu certo pra guardar imagem
                    
                } else {
                    //deu ruim pra guardar imagem
                    
                }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picking image cancelled")
    }
}
