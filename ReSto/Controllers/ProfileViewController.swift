//
//  ProfileViewController.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController  {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var mainUser: User?
    var userId: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        loadProfile {}
        
        profileImage.layer.borderWidth = 0.5
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.gray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    func loadProfile(completion: @escaping () -> Void) {
        NetworkManager.getAll(descriptor: "userinfo") { [unowned self] json in
            do {
                self.mainUser = try User(json)

                self.nameLabel.text = self.mainUser?.name
                
                if let profilePicString = self.mainUser?.profilePicPath {
                    let placeholder = UIImage(named: "placeholder")
                    self.profileImage.imageFromServerURL(profilePicString, placeHolder: placeholder)
                }
                
                if let user = self.mainUser {
                    cachedUsers = cachedUsers.filter { $0.id != user.id }
                    cachedUsers.append(user)
                }
                
            } catch {
                print("Could not parse response")
            }
            completion()
        }
    }
}
