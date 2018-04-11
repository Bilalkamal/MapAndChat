//
//  ViewController.swift
//  MapAndChat
//
//  Created by Bilal on 2018-04-05.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import ChameleonFramework



class WelcomeViewController: UIViewController,GIDSignInDelegate {
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
       
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor.flatSand
        view.backgroundColor = UIColor.flatSand
        registerButton.backgroundColor = UIColor.flatRedDark
        loginButton.backgroundColor = UIColor.flatBlueDark
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() || Auth.auth().currentUser != nil{
            
            self.performSegue(withIdentifier: "goToMainScreen", sender: self)

            
        }
    }

    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    


}

