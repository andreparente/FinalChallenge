
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
    
    var nameTxtField: KaedeTextField!
    var emailTxtField: KaedeTextField!
    var passwordTxtField: KaedeTextField!
    var fbLoginButton: FBSDKLoginButton!
    var loginButton: UIButton!
    
    var nameRegisterTxtField: KaedeTextField!
    var emailRegisterTxtField: KaedeTextField!
    var passwordRegisterTxtField: KaedeTextField!
    var fbRegisterButton: FBSDKLoginButton!
    var registerButton: UIButton!
    
    var loginView: UIView!
    var registerView: UIView!
    
    var entrarLbl: UILabel!
    var registrarLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoginView()
        setRegisterView()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setLoginView() {
        loginView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.height))
        self.loginView.backgroundColor = .lightGray
        self.loginView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.loginSelected)))
        self.view.addSubview(loginView)
        entrarLbl = UILabel(frame: CGRect(x: 15, y: 30, width: 2.5*self.loginView.frame.width/3, height: 50))
        entrarLbl.text = "Entrar"
        entrarLbl.makeHorizontal()
        entrarLbl.center.x = loginView.center.x
        self.loginView.addSubview(entrarLbl)
        
        emailTxtField = KaedeTextField()
        emailTxtField.foregroundColor = .red
        emailTxtField.backgroundColor = .blue
        emailTxtField.placeholderFontScale = 9
        emailTxtField.placeholderColor = UIColor.customLightBlue
        emailTxtField.placeholderLabel.text = "email"
        emailTxtField.frame.size.width = 200
        emailTxtField.frame.size.height = 25
        emailTxtField.center.y = entrarLbl.center.y - 40
        emailTxtField.frame.origin.x = entrarLbl.frame.maxX + 10
        emailTxtField.alpha = 0
        //        emailTxtField.placeholder = "insira seu email"
        self.loginView.addSubview(emailTxtField)
        
        passwordTxtField = KaedeTextField()
        passwordTxtField.frame.size.width = 200
        passwordTxtField.frame.size.height = 25
        passwordTxtField.center.y = emailTxtField.center.y + 40
        passwordTxtField.center.x = emailTxtField.center.x
        passwordTxtField.alpha = 0
        passwordTxtField.placeholder = "insira sua senha"
        self.loginView.addSubview(passwordTxtField)
        
        loginButton = UIButton()
        loginButton.frame.size.width = 200
        loginButton.frame.size.height = 30
        loginButton.center.x = passwordTxtField.center.x
        loginButton.center.y = passwordTxtField.center.y + 40
        loginButton.alpha = 0
        loginButton.backgroundColor = .gray
        loginButton.setTitle("entrar", for: .normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.login), for: .touchUpInside)
        self.loginView.addSubview(loginButton)
        
        
        fbLoginButton = FBSDKLoginButton()
        fbLoginButton.readPermissions = ["email","public_profile"]
        fbLoginButton.delegate = self
        fbLoginButton.center.x = loginButton.center.x
        fbLoginButton.center.y = loginButton.center.y + 40
        fbLoginButton.alpha = 0
        self.loginView.addSubview(fbLoginButton)
        
    }
    
    func loginSelected(){
        UIView.animate(withDuration: 0.5) {
            self.view.bringSubview(toFront: self.loginView)
            self.loginView.frame.size.width = self.view.frame.width
            self.fbLoginButton.alpha = 1
            self.emailTxtField.alpha = 1
            self.passwordTxtField.alpha = 1
            self.loginButton.alpha = 1
            
        }
    }
    
    func setRegisterView() {
        registerView = UIView(frame: CGRect(x: self.view.frame.width/2, y: 0, width: self.view.frame.width/2, height: self.view.frame.height))
        self.registerView.backgroundColor = UIColor.customLightBlue
        self.registerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.registerSelected)))
        self.view.addSubview(registerView)
        registrarLbl = UILabel(frame: CGRect(x: 15, y: 30, width: 2.5*self.loginView.frame.width/3, height: 50))
        registrarLbl.text = "Registrar"
        registrarLbl.makeHorizontal()
        self.registerView.addSubview(registrarLbl)
        registrarLbl.center.x = registerView.frame.width/2
        
        
        nameRegisterTxtField = KaedeTextField()
        nameRegisterTxtField.frame.size.width = 200
        nameRegisterTxtField.frame.size.height = 25
        nameRegisterTxtField.center.y = registrarLbl.center.y - 40
        nameRegisterTxtField.frame.origin.x = registrarLbl.frame.maxX + 10
        nameRegisterTxtField.alpha = 0
        nameRegisterTxtField.placeholder = "insira seu nome"
        self.registerView.addSubview(nameRegisterTxtField)
        
        emailRegisterTxtField = KaedeTextField()
        emailRegisterTxtField.frame.size.width = 200
        emailRegisterTxtField.frame.size.height = 25
        emailRegisterTxtField.center.y = nameRegisterTxtField.center.y + 40
        emailRegisterTxtField.center.x = nameRegisterTxtField.center.x
        emailRegisterTxtField.alpha = 0
        emailRegisterTxtField.placeholder = "insira seu email"
        self.registerView.addSubview(emailRegisterTxtField)
        
        passwordRegisterTxtField = KaedeTextField()
        passwordRegisterTxtField.frame.size.width = 200
        passwordRegisterTxtField.frame.size.height = 25
        passwordRegisterTxtField.center.y = emailRegisterTxtField.center.y + 40
        passwordRegisterTxtField.center.x = emailRegisterTxtField.center.x
        passwordRegisterTxtField.alpha = 0
        passwordRegisterTxtField.placeholder = "insira sua senha"
        self.registerView.addSubview(passwordRegisterTxtField)
        
        registerButton = UIButton()
        registerButton.frame.size.width = 200
        registerButton.frame.size.height = 30
        registerButton.center.x = passwordRegisterTxtField.center.x
        registerButton.center.y = passwordRegisterTxtField.center.y + 40
        registerButton.alpha = 0
        registerButton.backgroundColor = .gray
        registerButton.setTitle("entrar", for: .normal)
        registerButton.addTarget(self, action: #selector(LoginViewController.register), for: .touchUpInside)
        self.registerView.addSubview(registerButton)
        
        
        fbRegisterButton = FBSDKLoginButton()
        fbRegisterButton.readPermissions = ["email","public_profile"]
        fbRegisterButton.delegate = self
        fbRegisterButton.center.x = registerButton.center.x
        fbRegisterButton.center.y = registerButton.center.y + 40
        fbRegisterButton.alpha = 0
        self.registerView.addSubview(fbRegisterButton)
        
    }
    
    func registerSelected() {
        UIView.animate(withDuration: 0.5) {
            self.view.bringSubview(toFront: self.registerView)
            self.registerView.frame.origin.x = 0
            self.registerView.frame.size.width = self.view.frame.width
            self.fbRegisterButton.alpha = 1
            self.registerButton.alpha = 1
            self.passwordRegisterTxtField.alpha = 1
            self.emailRegisterTxtField.alpha = 1
            self.nameRegisterTxtField.alpha = 1
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            if user != nil {
                //user logado com sucesso
                //puxar infos do database do us
                
                
                
                DatabaseAccess.sharedInstance.fetchUserInfo(email: self.emailTxtField.text!, callback: { (success: Bool) in
                    if success {
                        self.performSegue(withIdentifier: "LoginToMain", sender: self)
                    } else {
                        
                    }
                })
                
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            if user != nil {
                //adiciona email e nome ao path do Uid (ok)
                let user = User(name: self.nameTxtField.text!, email: Auth.auth().currentUser!.email!)
                
                DatabaseAccess.sharedInstance.databaseAccessWriteCreateUser(user: user)
                
                //self.performSegue(withIdentifier: "LoginToMain", sender: self)
                
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
                                    User.sharedInstance.name = resultado["name"] as! String
                                    User.sharedInstance.email = resultado["email"] as! String
                                    DatabaseAccess.sharedInstance.databaseAccessWriteCreateUser(user: user)
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


