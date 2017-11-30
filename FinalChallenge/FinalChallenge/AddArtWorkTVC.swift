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
        self.artWork = ArtWork()
    }
    
    func setFooterView() {
        tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        tableFooter.addSubview(button)
        button.center = tableFooter.center
        button.titleLabel?.textAlignment  = .center
        button.setTitle("Salvar Obra", for: .normal)
        button.backgroundColor = UIColor.vitrineDarkBlue
        button.addTarget(self, action: #selector(AddArtWorkTVC.saveArtWork), for: .touchUpInside)
        
        self.tableView.tableFooterView = tableFooter

    }
    
    func setTableHeader() {
        tableHeader = AddArtWorkHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 260))
        self.tableView.tableHeaderView = tableHeader
        self.tableHeader.delegate = self
        self.tableHeader.parent = self

    }

    @objc private func saveArtWork() {
        
        let id = User.sharedInstance.id + Date().description
        
        self.artWork.id = id
        
        if ( (artWork.title == nil || artWork.descricao == nil || artWork.category == nil) || artWork.images.count == 0){
            print(artWork.title)
            print(artWork.descricao)
            print(artWork.category)
            print(artWork.images.count)

           print("preencher campos vazios")
        }
        else {
            DatabaseAccess.sharedInstance.databaseAccessWriteCreateArtwork(artwork: self.artWork, callback: { (success: Bool, response: String) in
                if success {
                    // 1
                    let optionMenu = UIAlertController(title: "Obra salva com sucesso!", message: "", preferredStyle: .alert)
                    
                    // 2
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
                        (alert: UIAlertAction!) -> Void in
                        self.navigationController?.popViewController(animated: true)
                        User.sharedInstance.didAddArtWork = true
 
                    })
                    // 3
                    optionMenu.addAction(okAction)
                    self.present(optionMenu, animated: true, completion: nil)

                } else {
                    self.showAlert(title: "Erro", message: "Não foi possível salvar sua obra no momento, tente de novo por favor")
                }
            })
        }
        
        
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
        cell.txtView.delegate = self
        cell.txtView.tag = indexPath.row
        cell.txtView.textAlignment = .center
        switch indexPath.row {
        case 0:
            cell.title.text = "Título"
        case 1:
            cell.title.text = "Descrição"
        case 2:
            cell.title.text = "Altura (cm)"
            cell.txtView.keyboardType = .decimalPad
        case 3:
            cell.title.text = "Largura (cm)"
            cell.txtView.keyboardType = .decimalPad
        case 4:
            cell.title.text = "Comprimento (cm)"
            cell.txtView.keyboardType = .decimalPad
        default:
            cell.title.text = "Valor (Opcional)"
            cell.txtView.keyboardType = .decimalPad
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 70
            
        case 1:
            return 140
            
        case 2:
            return 70

        case 3:
            return 70

        case 4:
            return 70

        default:
            return 70

        }
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

extension AddArtWorkTVC: UITextViewDelegate {

    
    func textViewDidChange(_ textView: UITextView) {
        switch textView.tag {
        case 0:
            artWork.title = textView.text!
        case 1:
            artWork.descricao = textView.text!
        case 2:
            artWork.height = Double(textView.text!)
        case 3:
            artWork.width = Double(textView.text!)
        case 4:
            print("Comprimento", Double(textView.text!) ?? 0)
        default:
            artWork.value = Double(textView.text!)

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
            selectedImageFromPicker = originalImage as? UIImage
        }
        else if let croppedImage = info["UIImagePickerControllerEditedImage"]{
            print((croppedImage as! UIImage).size)
            selectedImageFromPicker = croppedImage as? UIImage
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

extension AddArtWorkTVC: AddArtWorkHeaderDelegate {
    func didSelectCategory(category: String) {
        print(category)
        artWork.category = category
        print(artWork.category)
    }
    
    func didSelectAddPicture(vc: UIAlertController, index: Int) {
        self.present(vc, animated: true, completion: nil)
    }
    
    func didSelectDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
