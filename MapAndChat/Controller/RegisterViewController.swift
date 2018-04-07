//
//  RegisterViewController.swift
//  MapAndChat
//
//  Created by Bilal on 2018-04-06.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn

class RegisterViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    
    
    

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        
       createGoogleButton()
        
        
    }

    func createGoogleButton(){
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: -4, y: 262, width: view.frame.width + 10, height: 40)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        SVProgressHUD.show()
        if error != nil {
            print("Failed to Sign in to Google:", error)
            return
        }
        
        print("Successfully Logged into Google", user)
        
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print("Failed to Signin to Google with credintials", error!)
            }else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToMainScreen", sender: self)
            }
            
        }
        
        
    }
    
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            SVProgressHUD.show()
            if error != nil {
                print("Failed To register the User", error!)
                SVProgressHUD.dismiss()
            }else {
                print("Registeration Successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToMainScreen", sender: self)
            }
            
        }
        
        
    }
    
    
    
    
 

   
}
