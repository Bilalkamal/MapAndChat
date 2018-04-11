//
//  LoginViewController.swift
//  MapAndChat
//
//  Created by Bilal on 2018-04-06.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn
import ChameleonFramework

class LoginViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginLabel: UILabel!
    
     let googleButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        createGoogleButton()
        
        navigationController?.navigationBar.tintColor = UIColor.flatBlueDark
        view.backgroundColor = UIColor.flatSandDark
        
        loginButton.backgroundColor = UIColor.flatBlueDark
        loginLabel.textColor = UIColor.flatBlueDark
        
        
        
    }

    
    func createGoogleButton(){
       
        googleButton.frame = CGRect(x: -4, y: 327, width: view.frame.width + 10, height: 40)
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
            }
            else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToMainScreen", sender: self)
            }
            
            
        }
        
        
    }
    
    
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField!.text!, password: passwordTextField!.text!) { (user, error) in
            
            if error != nil {
                print("error signing in", error!)
                SVProgressHUD.dismiss()
            }else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToMainScreen", sender: self)
            }
            
        }
        
        
    }
    
    

    
    
}
