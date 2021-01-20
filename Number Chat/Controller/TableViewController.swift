//
//  TableViewController.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 15/01/2021.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {
    
    var currentChat: Int?
    var chatBrain = NumberChatBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title for the navigation controller
        title = "Choose your NumberChat!"
        
        // Make Sample Messages
        for i in chatBrain.chatNumbers {
            chatBrain.messages[i] = "Sample Message"
        }

        self.loadLastMessages()

    }

    // MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Replace this with counting the number of collections from Firestore!
        return 10
    }

    //MARK: - TableViewCell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create Subtitle Style Cell
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "ChatCell")
        

        cell.textLabel?.text = chatBrain.messages[indexPath[1] + 1]
        cell.textLabel?.textColor = .white
        
        cell.detailTextLabel?.text = "Chat \(indexPath[1] + 1)"
        cell.detailTextLabel?.textColor = .white
        
        cell.backgroundColor = .secondaryLabel

        return cell
    }
    
    //MARK: - UserClickedTableViewRow
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Flash Clicked Row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get Selected Chat Number
        self.currentChat = indexPath[1] + 1
        
        // Chat Segue for selected chat here
        self.performSegue(withIdentifier: Constants.chatSegue, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.chatSegue{
            
            // Pass selected chat to next view
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.currentChat = String(self.currentChat!)

            // Reenable navigation controller in the next view
            navigationController?.isNavigationBarHidden = false
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

//MARK: - GetNewMessagesFromFirestore

extension TableViewController {
    func loadLastMessages() {
        // Download documents from this collectionName order by time sent
        // and listen in real time for changes
        for chatNumber in chatBrain.chatNumbers {
            chatBrain.db.collection(Constants.FireStore.collection + "\(chatNumber)")
                .order(by: Constants.FireStore.dateField)
                .addSnapshotListener { (querySnapshot, error) in
                    // Print an error if there is one
                    if let e = error {
                        print("There was an issue retrieving data from Firestore. \(e)")
                        self.chatBrain.messages[chatNumber] = "Error retrieving data"
                    } else {
                        // If there are no errors get documents
                        if let snapshotDocuments = querySnapshot?.documents {
                            // Get last document for this chats
                            self.chatBrain.messages[chatNumber] = (snapshotDocuments.last?.data()[Constants.FireStore.bodyField] ?? "No messages in this chat yet") as? String
                        }
                    }
                    self.reloadMessagesInTableView()
                }
        }
    }
}

//MARK: - ReloadDataInTableView

extension TableViewController {
    func reloadMessagesInTableView() {
        DispatchQueue.main.async {
            // Reload TableView data
            self.tableView.reloadData()
            
            let indexPath = IndexPath(row: (self.chatBrain.messages.count - 1), section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
