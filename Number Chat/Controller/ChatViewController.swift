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
    
    let db = Firestore.firestore()
    
    var currentChat : String?
    
    var messages: [TextMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chat \(currentChat!)"
    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if let messageBody = chatTextField.text, let sender = Auth.auth().currentUser?.uid {
            // Add a document to Firestore with the message data
            
            db.collection(Constants.FireStore.collection + "\(currentChat!)").addDocument(data: [
                Constants.FireStore.senderID: sender,
                Constants.FireStore.bodyField: messageBody,
                Constants.FireStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                // Catch error
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data to firestore.")
                    self.chatTextField.text = ""
                }
            }
        }
    }
    
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
