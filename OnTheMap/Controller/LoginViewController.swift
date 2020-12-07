//
//  ViewController.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 18/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var textView: UITextView!


  override func viewDidLoad() {
    super.viewDidLoad()
    let attributedString = NSMutableAttributedString(string: "Don't have an account. Sign up")
    attributedString.addAttribute(.link, value: "https://auth.udacity.com/sign-up", range: NSRange(location: 23, length: 7))
    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.center
    attributedString.addAttributes([.paragraphStyle : style], range: NSRange(location: 0, length: 30))

    attributedString.addAttributes([.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 30))

    textView.attributedText = attributedString
    textView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    emailTextField.text = ""
    passwordTextField.text = ""
  }
  
  
  @IBAction func loginTapped(_ sender: Any) {
    setLoggIn(true)
    UdacityClient.createSessionId(emailTextField.text ?? "", passwordTextField.text ?? "", complation: handleSessionId)
  }

  private func handleSessionId(result: Bool, error: Error?){
    if result {
      UdacityClient.getStudentInfo (completion: handleGetStudentInfo)
    }else {
      self.showLoginFailure(message: error?.localizedDescription ?? "")
    }
  }

  private func handleGetStudentInfo(result: Bool, error: Error?){
    if result {
      DispatchQueue.main.async {
        self.setLoggIn(false)
        self.performSegue(withIdentifier: "completeLogin", sender: nil)
      }
    } else {
      self.showLoginFailure(message: error?.localizedDescription ?? "")
    }
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
  
  func showLoginFailure(message: String) {
    setLoggIn(false)
    let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertVC, animated: true, completion: nil)
  }

  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    UIApplication.shared.open(URL)
    return false
  }
  
}

