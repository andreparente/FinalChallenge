//
//  LoginViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright © 2017 Andre Machado Parente. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit


class LoginViewController: UIViewController {

//    @IBOutlet weak var registerView: UIView!
//    @IBOutlet weak var loginView: UIView!
    let fbButton = FBSDKLoginButton()
    var databaseAccess : DatabaseAccess?
//    var dbFirebaseRef : DatabaseReference?
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseAccess = DatabaseAccess()
        fbLoginButton.readPermissions = ["email","public_profile"]
//        self.view.addSubview(fbButton)
        //fbLoginButton.center = self.view.center
        fbLoginButton.delegate = self

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
    
    func setLoginView() {
        
    }
    
    func setRegisterView() {
        
    }

    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            if user != nil {
                //user logado com sucesso
                self.performSegue(withIdentifier: "LoginToMain", sender: self)
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            if user != nil {
                //adiciona email e nome ao path do Uid (ok)
                
                let user = User(name: self.nameTxtField.text!, email: Auth.auth().currentUser!.email!)
                self.databaseAccess?.databaseAccessWriteCreateUser(user: user)
//                self.performSegue(withIdentifier: "LoginToMain", sender: self)

            }
        }
    }
    
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            if result != nil {
                
                //transform facebook's credential in  firebase's credential
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "name,picture,email"]).start(completionHandler: { (connection, result, error) in
                    if error != nil {
                        print((error?.localizedDescription)!)
                        return
                    }
                    if result != nil {
                        //agora sim fazer login com firebase
                        Auth.auth().signIn(with: credential) { (user, error) in
                            if let error = error {
                                print(error)
                                return
                            }
                            else {
                                //firebase user is finally logged
                                
                                if let resultado = result as? Dictionary<String,AnyObject> {
                                    print(resultado["name"] as! String)
                                    print(resultado["email"] as! String)
                                    let user = User(name: resultado["name"] as! String, email: resultado["email"] as! String)
                                    self.databaseAccess?.databaseAccessWriteCreateUser(user: user)
                                }
                                
                            }
                        }
                    }
                })
            }
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
    
