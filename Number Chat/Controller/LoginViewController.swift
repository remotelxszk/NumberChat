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

        loginButton.layer.cornerRadius = 10.0
        
        chatSlider.value = 1
        signInChatNumber.text = "1"
        
        // Hide Navigation Bar
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let e = error {
                print(e)
            } else {
                self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
            }
        }
    }
    @IBAction func chatSliderChanged(_ sender: UISlider) {
        signInChatNumber.text = String(format: "%.0f", sender.value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.loginSegue{
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.currentChat = String(format: "%.0f", chatSlider.value)
        }
    }
}

