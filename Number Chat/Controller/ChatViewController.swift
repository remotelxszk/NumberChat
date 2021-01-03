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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chat \(1)" // 1 as placeholder
    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if let messageBody = chatTextField.text, let sender = Auth.auth().currentUser?.uid {
            // Add a document to Firestore with the message data
            
            // 1 as placeholder
            db.collection(Constants.FireStore.collection + "\(1)").addDocument(data: [
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
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
