//
//  ViewController.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import UIKit
import Alamofire

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
        authenticate { [unowned self] in
            if token != nil {
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
    }
    
    func authenticate(completion: @escaping () -> Void) {
        guard let user = usernameTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        
        NetworkManager.authenticate(user: user, pass: pass) { json in
            do {
                token = try Token(json)
            } catch {
                print("Could not parse response")
            }
            completion()
        }
    }
    
}

