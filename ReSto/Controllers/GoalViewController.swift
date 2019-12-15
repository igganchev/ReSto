//
//  EventViewController.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import UIKit

class GoalViewController: UIViewController, UINavigationControllerDelegate {
    
    var goalID: Int? = nil
    var goal: Goal?
    
    var myTitle: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            navigationBar.title = newValue
            titleLabel.text = newValue
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let id = goalID {
            goal = cachedGoals.first(where: { $0.id == id })
        }
        
        myTitle = goal?.name ?? ""
        
        if let goalSum = goal?.goalSum, let currentSum = goal?.currentSum {
            progressLabel.text = "\(String(currentSum)) from \(String(goalSum))"
        }
        
        if let URLString = goal?.image.first {
            let placeholder = UIImage(named: "placeholder")
            mainImage.imageFromServerURL(URLString, placeHolder: placeholder)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userIds = [1]
        if let userVC = segue.destination as? UsersTableViewController {
            userVC.userIds = userIds
            if let createdByUserId = goal?.createdById {
                userVC.createdByUserId = createdByUserId
            }
        }
        
    }
}
