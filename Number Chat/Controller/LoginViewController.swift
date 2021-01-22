//
//  ViewController.swift
//  Number Chat
//
//  Created by Dominik Leszczyński on 30/12/2020.
//

import UIKit
import Firebase
import DWAnimatedLabel

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleLabel: DWAnimatedLabel!
    @IBOutlet weak var descriptionLabel: DWAnimatedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round button edges
        loginButton.layer.cornerRadius = 10.0
        
        // Add animations to the title screen
        titleLabel.animationType = .typewriter
        titleLabel.backgroundColor = .clear
        
        descriptionLabel.animationType = .shine
        descriptionLabel.backgroundColor = .clear
        
        // Prepare label to fit on smaller screens
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.2
        
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
        // Start titleLabel Animation and start descriptionLabel Animation after completion
        titleLabel.startAnimation(duration: 2, { () in
                                    self.descriptionLabel.startAnimation(duration: 5, nil); self.descriptionLabel.text = "Click the button above to log in anonymously." })
        
    }
}

