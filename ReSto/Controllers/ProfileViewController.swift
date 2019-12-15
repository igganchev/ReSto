//
//  ProfileViewController.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UIPickerViewAccessibilityDelegate, UIPickerViewDataSource  {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var savedTotal: UILabel!
    @IBOutlet weak var numberOfTransactions: UILabel!
    @IBOutlet weak var roundingUps: UIPickerView!
    @IBOutlet weak var frequency: UIPickerView!
    
    var mainUser: User?
    var userId: Int?
    
    var frequencyOptions = ["Instant", "Dayly", "Weekly"]
    var roundingsUpOptions = ["Next $", "Next 5 $", "Next 10 $"]
    
    override func viewWillAppear(_ animated: Bool) {
        frequency.delegate = self
        frequency.dataSource = self
        roundingUps.delegate = self
        roundingUps.dataSource = self
        loadProfile {}
        setProfileImage()
    }
    
    func loadProfile(completion: @escaping () -> Void) {
        NetworkManager.getAll(descriptor: "userinfo") { [unowned self] json in
            do {
                self.mainUser = try User(json)

                self.nameLabel.text = self.mainUser?.name
                self.savedTotal.text = "Total saved \(self.mainUser?.savedTotal ?? 0) $"
                self.numberOfTransactions.text = "Number of transactions: \(self.mainUser?.numberOfTransactions ?? 0)"
                
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
    
    func setProfileImage() {
        profileImage.layer.borderWidth = 0.5
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.gray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == frequency {
            return frequencyOptions[row]
        }
        return roundingsUpOptions[row]
    }
}
