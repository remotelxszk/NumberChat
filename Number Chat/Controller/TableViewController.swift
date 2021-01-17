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
        
        title = "Choose your NumberChat!"
        
        // Make Sample Messages
        for i in chatBrain.chatNumbers {
            chatBrain.messages[i] = "Sample Message"
        }
        // LoadLastMessages
        self.loadLastMessages()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // Replace this with counting the number of collections from Firestore!
        return 10
    }

    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get Selected Chat Number
        self.currentChat = indexPath[1] + 1
        
        // Chat Segue for selected chat here
        self.performSegue(withIdentifier: Constants.chatSegue, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.chatSegue{
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
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        // Reload TableView data
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            let indexPath = IndexPath(row: (self.chatBrain.messages.count - 1), section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
