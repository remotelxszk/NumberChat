//
//  ViewController.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 30/12/2020.
//

import UIKit

import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var signInUserNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func LoginButton(_ sender: UIButton) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let e = error {
                print(e)
            } else {
                self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
            }
        }
    }
    
}

