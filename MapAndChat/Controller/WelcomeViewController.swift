//
//  ViewController.swift
//  MapAndChat
//
//  Created by Bilal on 2018-04-05.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import GoogleSignIn




class WelcomeViewController: UIViewController,GIDSignInDelegate {
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
       
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            
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

