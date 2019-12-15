//
//  GoalViewController.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import UIKit
import SwiftUI

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
    
    override func viewDidLoad() {
        if let id = goalID {
            goal = cachedGoals.first(where: { $0.id == id })
        }
        
        myTitle = goal?.name ?? ""
        
        if let goal = self.goal {
            let childView = UIHostingController(rootView: GoalView(goal: goal))
            addChild(childView)
            childView.view.frame = self.view.frame
            view.addSubview(childView.view)
            childView.didMove(toParent: self)
        }
    }
}
