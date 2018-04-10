//
//  MainViewController.swift
//  MapAndChat
//
//  Created by Bilal on 2018-04-06.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        
        do {
            SVProgressHUD.show()
            try Auth.auth().signOut()
            
            GIDSignIn.sharedInstance().signOut()
            
            
        }catch{
            print("Failed to Sign out", error)
            SVProgressHUD.dismiss()
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil else{
           
            SVProgressHUD.dismiss()
            print("No View Controllers to Pop off")
            return
        }
        SVProgressHUD.dismiss()
        
    }
    
    
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToMaps", sender: self)
        
    }
    
    

}
