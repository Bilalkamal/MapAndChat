//
//  MainViewController.swift
//  MapAndChat
//
//  Created by Bilal on 2018-04-06.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import Firebase


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
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }catch{
            print("Failed to Sign out", error)
        }
        
    }
    
    
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToMaps", sender: self)
        
    }
    
    

}
