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
        self.headerView.profileNameLbl.text = User.sharedInstance.name
        self.headerView.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HeaderViewController.selectImage)))
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
    func selectImage() {
        pickImg()
    }

}


extension HeaderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
