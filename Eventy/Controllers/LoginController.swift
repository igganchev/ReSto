//
//  ViewController.swift
//  Eventy
//
//  Created by Valentin Varbanov on 15.01.18.
//

import UIKit
import Alamofire

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
        
        Alamofire.request(
            URL(string: serverIp + "/login")!,
            method: .get,
            parameters: ["user": user, "pass": pass])
            .validate()
            .responseString { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error response: \(String(describing: response.result.error))")
                    completion()
                    return
                }
                
                do {                    
                    if let json = response.result.value {
                        token = try Token(json)
                    }
                } catch {
                    print("Cound not parse response")
                }
                completion()
        }
    }
    
}

