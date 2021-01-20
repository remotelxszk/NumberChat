//
//  ChatViewController.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 31/12/2020.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth

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
        messageTableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()
        
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
        cell.textSenderID.text = message.id
        
        // This is a message from the current user
        if message.id == Auth.auth().currentUser?.uid {
            cell.textSenderID.isHidden = true
            cell.textBubble.backgroundColor = UIColor.systemGray
            
            cell.RightViewPlaceholder.isHidden = true
            cell.LeftViewPlaceholder.isHidden = false
        } else {
            cell.textSenderID.isHidden = false
            cell.textBubble.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            
            cell.RightViewPlaceholder.isHidden = false
            cell.LeftViewPlaceholder.isHidden = true
        }
        return cell
    }
    
    
}

//MARK: - LoadMessages

extension ChatViewController {
    func loadMessages() {
        
        // Download documents from this collectionName order by time sent
        // and listen in real time for changes
        db.collection(Constants.FireStore.collection + "\(currentChat!)")
            .order(by: Constants.FireStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            // Print an error if there is one
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                // If there are no errors get documents
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    // Empty array
                    self.messages = []
                    
                    // For every document in documents
                    for document in snapshotDocuments {
                        // Get document data
                        let data = document.data()
                        // If document data is not empty pass both as a string to these variables
                        if let messageSender = data[Constants.FireStore.senderID] as? String, let messageBody = data[Constants.FireStore.bodyField] as? String {
                            
                            // Create a new message and add it to the message array
                            let newMessage = TextMessage(id: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            // Reload TableView data
                            DispatchQueue.main.async {
                                self.messageTableView.reloadData()
                                
                                let indexPath = IndexPath(row: (self.messages.count - 1), section: 0)
                                self.messageTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
