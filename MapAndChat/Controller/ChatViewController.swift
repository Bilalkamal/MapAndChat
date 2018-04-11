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
        
    }
    

    
    //MARK: - TableView DataSource Methods
    
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            
            cell.avatarImageView.backgroundColor = UIColor.green
            cell.messageBackground.backgroundColor = UIColor.blue
        } else {
            cell.avatarImageView.backgroundColor = UIColor.red
            cell.messageBackground.backgroundColor = UIColor.gray
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
    
    
    

    @IBAction func sendPressed(_ sender: Any) {
        
        messageTextField.endEditing(true)
        

        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextField.text!]
        
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
