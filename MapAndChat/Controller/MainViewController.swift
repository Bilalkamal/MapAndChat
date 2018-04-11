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
import ChameleonFramework

class MainViewController: UIViewController {

    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.flatSandDark
        
        setupButtons()
        
        
    }
    
    fileprivate func setupButtons() {
        
        mapButton.backgroundColor = UIColor.flatSkyBlueDark
        chatButton.backgroundColor = UIColor.flatGreenDark
        logoutButton.backgroundColor = UIColor.flatBlack
        
        mapButton.layer.cornerRadius = 10
        mapButton.clipsToBounds = true
        
        chatButton.layer.cornerRadius = 10
        chatButton.clipsToBounds = true
        
        logoutButton.layer.cornerRadius = 10
        logoutButton.clipsToBounds = true
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
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToChat", sender: self)
    }
    
    

}
