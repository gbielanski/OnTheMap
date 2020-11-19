//
//  ViewController.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 18/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        setLoggIn(true)
    }
    
    func setLoggIn(_ login: Bool){
        if login {
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
        
        emailTextField.isEnabled = !login
        passwordTextField.isEnabled = !login
        loginButton.isEnabled = !login
    }
}

