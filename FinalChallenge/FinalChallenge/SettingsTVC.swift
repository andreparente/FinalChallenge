//
//  SettingsTVC.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 28/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    var textFieldEndEditingAction: ((String)->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.txtField.delegate = self

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension SettingsCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldEndEditingAction?(textField.text!)
    }
}

class SettingsTVC: UITableViewController {

    var headerView: HeaderSettings!
    var imagePicker: UIImagePickerController!
    var tel1: String!
    var tel2: String!
    var newName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.setHeader()
        self.navigationController?.isNavigationBarHidden = false
    }

    func setHeader() {
        headerView = HeaderSettings(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140))
        headerView.delegate = self
        self.tableView.tableHeaderView = headerView
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        switch indexPath.row {
        case 0:
            cell.label.text = "Nome: "
            cell.txtField.placeholder = User.sharedInstance.name
            cell.textFieldEndEditingAction = {
                (text) in
                if text == "" {
                    
                } else {
                    self.newName = text
                }
            }
        case 1:
            cell.label.text = "Telefone 1: "
            if User.sharedInstance.tel1 != nil{
                cell.txtField.placeholder = User.sharedInstance.tel1
            }
            cell.textFieldEndEditingAction = {
                (text) in
                if text == "" {
                    
                } else {
                    self.tel1 = text
                }
            }
        default:
            cell.label.text = "Telefone 2: "
            if User.sharedInstance.tel2 != nil{
                cell.txtField.placeholder = User.sharedInstance.tel2
            }
            
            cell.textFieldEndEditingAction = {
                (text) in
                if text == "" {
                    
                } else {
                    self.tel2 = text
                }
            }
        }

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsTVC: HeaderSettingsDelegate {
    
    func didTapSaveSettings() {
        var dict = [:] as! [String:Any]
        dict["name"] = newName
        dict["tel1"] = tel1
        dict["tel2"] = tel2
        
        DatabaseAccess.sharedInstance.updateUserProfile(dict: dict) { (success:Bool) in
            if success{
                print("update successful")
                self.showAlert(title: "Sucesso", message: "Seus dados foram atualizados com sucesso!")
            }
            else {
                print("update failed")
                self.showAlert(title: "Erro", message: "Não foi possível atualizar agora, tente novamente mais tarde")
                
            }
        }

    }
    
    func didTapChangePicture() {
        if (imagePicker) != nil {
            
        } else {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
        }
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        // 2
        let newPictureAction = UIAlertAction(title: "Take new Picture", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
            
        })
        
        let choosePictureAction = UIAlertAction(title: "Choose image from album", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        optionMenu.addAction(newPictureAction)
        optionMenu.addAction(choosePictureAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
}

extension SettingsTVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            DatabaseAccess.sharedInstance.uploadProfileImage(image: picture, callback: { (success: Bool, response: String) in
                if success {
                    //deu certo pra guardar imagem
                    ("img updated")
                    self.headerView.profileImageView.image = picture
                } else {
                    //deu ruim pra guardar imagem
                    self.showAlert(title: "Erro", message: "Não foi possível carregar sua imagem, tente novamente mais tarde")
                    
                }
            })
        }
    }
}

