//
//  SettingsTesteViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 22/11/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit

class SettingsTesteViewController: UIViewController {

    @IBOutlet weak var nomeTxtField: UITextField!
    @IBOutlet weak var tel1TxtField: UITextField!
    @IBOutlet weak var tel2TxtField: UITextField!
    @IBOutlet weak var novaSenhaTxtField: UITextField!
    @IBOutlet weak var perfilImageView: UIImageView!
    
    var imagePicker: UIImagePickerController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perfilImageView.downloadedFrom(link: User.sharedInstance.profilePictureURL, contentMode: .scaleAspectFill)
        self.perfilImageView.layer.masksToBounds = true
        
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

    @IBAction func mudarFotoDePerfil(_ sender: Any) {
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
    
    @IBAction func salvarInfos(_ sender: Any) {
    }
    
    @IBAction func dismiss(_ sender: Any) {
    }
}

extension SettingsTesteViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //fazer algo OLENKA
        }
    }
}