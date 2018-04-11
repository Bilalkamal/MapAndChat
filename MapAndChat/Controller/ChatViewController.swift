//
//  ChatViewController.swift
//  MapAndChat
//
//  Created by Bilal on 2018-04-10.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var messageArray : [Message] = [Message]()
    
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {

        
        messageTableView.delegate = self
        messageTableView.dataSource =  self

        
        messageTextField.delegate = self

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        
        

        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
        
        
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor.flatWhite
        navigationController?.navigationBar.tintColor = UIColor.flatGreenDark
        
        
        
    }
    
    
    
  
    

    
    //MARK: - TableView DataSource Methods


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        
        cell.cellView.backgroundColor = UIColor.flatWhite
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        let defaultImage = UIImage(named: "Default Photo")
        
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.height / 2

        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            
            cell.avatarImageView.backgroundColor = UIColor.yellow
            cell.messageBackground.backgroundColor = UIColor.flatGreen
            if let userImageUrl = Auth.auth().currentUser?.photoURL {
                
                
                let url = userImageUrl
                
                let data = try? Data(contentsOf: url)
                cell.avatarImageView.image = UIImage(data: data!)
                
                
                
            }else {
                cell.avatarImageView.image = defaultImage
            }
            
        } else {
            cell.avatarImageView.image = defaultImage
            cell.messageBackground.backgroundColor = UIColor.flatGray
            cell.messageBody.textColor = UIColor.flatBlackDark
        }
        
        return cell
    }
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
        
    }
    

    
    @objc func tableViewTapped() {
        
        messageTextField.endEditing(true)
        
    }

    
    func scrollToTheEnd(){
        if messageArray.count > 0 {
            messageTableView.scrollToRow(at: IndexPath(item:messageArray.count-1, section: 0), at: .bottom, animated: true)
        }else {
            return
        }
    }
    

    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    

    
    //MARK:- TextField Delegate Methods
    
        func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollToTheEnd()
        
        UIView.animate(withDuration: 0.5){
            
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5){
            
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    
    func sendOrPressedAction(){
        messageTextField.endEditing(true)
        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        
        if let message = messageTextField.text, message.count > 0  {
            
            let messageDB = Database.database().reference().child("Messages")
            
            let messageDictionary  = ["Sender": Auth.auth().currentUser?.email, "MessageBody": message]

            messageDB.childByAutoId().setValue(messageDictionary) { (error, reference) in
                
                if error != nil {
                    print(error!)
                } else {
                    print("Message Saved")
                    self.messageTextField.isEnabled = true
                    self.messageTextField.text = ""
                    self.sendButton.isEnabled = true
                    
                }
                
            }
        }else {
            messageTextField.isEnabled = true
            messageTextField.text = ""
            sendButton.isEnabled = true
            return
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendOrPressedAction()
        return true
    }
    

    @IBAction func sendPressed(_ sender: Any) {
        
       sendOrPressedAction()
        
        
        
    }
    
    

    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            self.scrollToTheEnd()
            
        })
        
    }
    
    
    

  

}
