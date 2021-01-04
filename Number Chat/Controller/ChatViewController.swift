//
//  ChatViewController.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 31/12/2020.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    
    // Firestore instance
    let db = Firestore.firestore()
    
    // Pass the current chat to this string from LoginViewController
    var currentChat : String?
    
    var messages: [TextMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        title = "Chat \(currentChat!)"
        
        // Register Custom xib file
        messageTableView.register(UINib(nibName: "TextMessage", bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
    }

    //MARK: - SendingAMessage
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if let messageBody = chatTextField.text, let sender = Auth.auth().currentUser?.uid {
            // Add a document to Firestore with the message data
            
            db.collection(Constants.FireStore.collection + "\(currentChat!)").addDocument(data: [
                Constants.FireStore.senderID: sender,
                Constants.FireStore.bodyField: messageBody,
                Constants.FireStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                // Catch errors
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data to firestore.")
                    self.chatTextField.text = ""
                }
            }
        }
    }
    
    //MARK: - Logout
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            // Go back to the main screen
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

//MARK: - TableViewDelegate

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ...
    }
}

//MARK: - TableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! ChatCell
        cell.textBody.text = message.body
        
        // This is a message from the current user
        if message.id == Auth.auth().currentUser?.uid {
            cell.textSenderID.isHidden = true
        } else {
            cell.textSenderID.isHidden = false
        }
        return cell
    }
    
    
}
