//
//  AddArtWorkTVC.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 06/10/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class AddArtWorkTVC: UITableViewController {

    var tableHeader: AddArtWorkHeader!
    var tableFooter: UIView!
    var artWork: ArtWork!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.setTableHeader()
        self.setFooterView()
        self.tableView.register(UINib(nibName: "AddArtWorkTableViewCell", bundle: nil), forCellReuseIdentifier: "AddArtWorkCell")
        self.tableView.tableHeaderView = tableHeader
        self.tableView.tableFooterView = tableFooter
        self.artWork = ArtWork()
    }
    
    func setFooterView() {
        tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 40))
        tableFooter.addSubview(button)
        button.center = tableFooter.center
        button.setTitle("Salvar Obra!", for: .normal)
        button.backgroundColor = UIColor.customLightBlue
        button.addTarget(self, action: #selector(AddArtWorkTVC.saveArtWork), for: .touchUpInside)
    }
    
    func setTableHeader() {
        tableHeader = AddArtWorkHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        self.tableHeader.addPictureButton.addTarget(self, action: #selector(AddArtWorkTVC.pickImg), for: .touchUpInside)
    }

    @objc private func saveArtWork() {
        //funcao do olenka!
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddArtWorkCell", for: indexPath) as! AddArtWorkTableViewCell

        // Configure the cell...
        cell.txtField.delegate = self
        cell.txtField.tag = indexPath.row

        switch indexPath.row {
        case 0:
            cell.txtField.placeholder = "Título"
            
        case 1:
            cell.txtField.placeholder = "Descrição"
        case 2:
            cell.txtField.placeholder = "Valor"
            cell.txtField.keyboardType = .decimalPad
        case 3:
            cell.txtField.placeholder = "Largura (em cm)"
            cell.txtField.keyboardType = .decimalPad
        case 4:
            cell.txtField.placeholder = "Altura (em cm)"
            cell.txtField.keyboardType = .decimalPad
        default:
            cell.txtField.placeholder = "Categoria"
            
        }
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

extension AddArtWorkTVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            artWork.title = textField.text!
        case 1:
            artWork.descricao = textField.text!
        case 2:
            artWork.value = Double(textField.text!)
        case 3:
            artWork.width = Double(textField.text!)
        case 4:
            artWork.height = Double(textField.text!)
        default:
            artWork.category = textField.text!
        }
    }
}

extension AddArtWorkTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            selectedImageFromPicker = originalImage as! UIImage
        }
        else if let croppedImage = info["UIImagePickerControllerEditedImage"]{
            print((croppedImage as! UIImage).size)
            selectedImageFromPicker = croppedImage as! UIImage
        }
        
        //aqui adiciono no vetor de imagens
        artWork.images.append(selectedImageFromPicker!)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picking image cancelled")
        dismiss(animated: true, completion: nil)
    }
}
