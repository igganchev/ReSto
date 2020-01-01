//
//  TrendingTableViewController.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import Alamofire
import SwiftUI

class GoalsTableViewController: UIHostingController<GoalTable> {
    
    let dispatchGroup = DispatchGroup()
    
    var goalList: GoalsList?
    var goals: [Goal] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: GoalTable())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        loadData()
    }
    
    func loadGoals(completion: @escaping () -> Void) {
        NetworkManager.getAll(descriptor: "goals") { [weak self] json in
            do {
                self?.goalList = try GoalsList(json)
            } catch {
                print("Could not parse response")
            }
            completion()
        }
    }
    
    func loadGoal(id: Int) {
        dispatchGroup.enter()
        
        NetworkManager.getByID(descriptor: "goal", byID: id) { [weak self] json in
            do {
                let goal = try Goal(json)
                
                cachedGoals = cachedGoals.filter { $0.id != goal.id }
                cachedGoals.append(goal)
                
                NetworkManager.getImage(fromURL: goal.imageStr.first) { [weak self] image in
                    goal.image = image
                    self?.goals.append(goal)
                    self?.dispatchGroup.leave()
                }
            } catch {
                print("Could not parse response")
            }
        }
    }
    
    func loadData() {
        loadGoals { [weak self] in
            if let goalList = self?.goalList {
                if let goals = self?.goals, goalList.ids.containsSameElements(as: goals.map {$0.id}) {
                    self?.rootView = GoalTable(goals: goals)
                } else if let goals = self?.goals {
                    let difference = goalList.ids.difference(from: goals.map {$0.id})
                    
                    for goalID in difference {
                        self?.loadGoal(id: goalID)
                    }
                    
                    self?.dispatchGroup.notify(queue: .main) { [weak self] in
                        if let goals = self?.goals {
                            self?.rootView = GoalTable(goals: goals)
                        }
                    }
                } else {
                    self?.goals = []
                    
                    for goalID in goalList.ids {
                        self?.loadGoal(id: goalID)
                    }
                    
                    self?.dispatchGroup.notify(queue: .main) { [weak self] in
                        if let goals = self?.goals {
                            self?.rootView = GoalTable(goals: goals)
                        }
                    }
                }
            }
        }
    }
}
