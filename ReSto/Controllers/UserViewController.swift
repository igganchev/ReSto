//
//  UserViewController.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import SwiftUI
import Alamofire

class UserViewController: UIHostingController<UserView>  {
    
    var user: User?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: UserView(user: nil))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidLoad() {
        loadData()
    }
    
    func loadUser() {
        NetworkManager.getAll(descriptor: "userinfo") { [weak self] json in
            do {
                let user = try User(json)
                
                NetworkManager.getImage(fromURL: user.imageStr) { [weak self] image in                    
                    user.image = image
                    self?.user = user
                    self?.rootView = UserView(user: self?.user)
                    
                    savedChanged = false
                }
            } catch {
                print(error)
                print("Could not parse response")
            }
        }
    }
    
    func loadData() {
        if let user = self.user, !savedChanged {
            self.rootView = UserView(user: user)
        } else {
            loadUser()
        }
    }
}
