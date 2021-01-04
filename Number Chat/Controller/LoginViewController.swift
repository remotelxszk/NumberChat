//
//  ViewController.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 30/12/2020.
//

import UIKit

import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var signInChatNumber: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var chatSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round button edges
        loginButton.layer.cornerRadius = 10.0
        
        // Set default chat to 1
        chatSlider.value = 1
        signInChatNumber.text = "1"
        
    }

    //MARK: - SignIn
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let e = error {
                print(e)
            } else {
                self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
            }
        }
    }
    
    //MARK: - ChatSlider
    
    @IBAction func chatSliderChanged(_ sender: UISlider) {
        signInChatNumber.text = String(format: "%.0f", sender.value)
    }
    
    //MARK: - PassSelectedChatAndDisplayNavBar
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.loginSegue{
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.currentChat = String(format: "%.0f", chatSlider.value)
            
            // Reenable navigation controller in the next view
            navigationController?.isNavigationBarHidden = false
        }
    }
    
    //MARK: - HideNavigationBar
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide Navigation Bar
        navigationController?.isNavigationBarHidden = true
        
    }
}

