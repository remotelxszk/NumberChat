//
//  ViewController.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 30/12/2020.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round button edges
        loginButton.layer.cornerRadius = 10.0
        
        
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
    
    //MARK: - DisplayNavBarInNextTheView
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.loginSegue{
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

