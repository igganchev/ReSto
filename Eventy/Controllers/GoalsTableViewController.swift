//
//  TrendingTableViewController.swift
//  Eventy
//
//  Created by Valentin Varbanov on 17.02.18.
//

import UIKit
import Alamofire

class GoalsTableViewController: UITableViewController {
    
    var goals: GoalsList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadGoals { [unowned self] in
            self.reloadData()
        }
    }
    
    func loadGoals(completion: @escaping () -> Void) {
        guard let t = token?.accessToken else { return }
        
        Alamofire.request(
            URL(string: serverIp + "/goals")!,
            method: .get,
            headers: ["access-token": t])
            .validate()
            .responseString { (response) in
                guard response.result.isSuccess else {
                    print("Error response: \(String(describing: response.result.error))")
                    completion()
                    return
                }
                do {
                    if let json = response.result.value {
                        self.goals = try GoalsList(json)
                    }
                } catch {
                    print("Could not parse response")
                }
                completion()
        }
        
    }
    
    func loadGoal(id: Int, completion: @escaping () -> Void) {
        guard let t = token?.accessToken else { return }
        Alamofire.request(
            URL(string: serverIp + "/goal")!,
            method: .get,
            parameters: ["goalid": "\(id)"],
            headers: ["access-token": t])
            .validate()
            .responseString { (response) in
                guard response.result.isSuccess else {
                    print("Error response: \(String(describing: response.result.error))")
                    completion()
                    return
                }
                do {
                    if let json = response.result.value {
                        let goal = try Goal(json)
                        
                        cachedGoals = cachedGoals.filter { $0.id != goal.id }
                        cachedGoals.append(goal)
                    }
                } catch {
                    print("Could not parse response")
                }
                completion()
        }
    }
    
    func reloadData() {
        guard let ids = goals?.ids else { return }
        for id in ids {
            if let indexToReload = cachedGoals.firstIndex(where: { $0.id == id }) {
                reloadCell(index: indexToReload)
            } else {
                loadGoal(id: id) { [unowned self] in
                    self.reloadCell(index: ids.firstIndex(of: id)!)
                }
            }
        }
    }
    
    func reloadCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.async { [unowned self] in
            if self.lastItemsInSection == (self.goals?.ids.count ?? 0) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                self.tableView.reloadSections([0], with: .automatic)
            }
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var lastItemsInSection = 0

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        lastItemsInSection = goals?.ids.count ?? 0
        
        return lastItemsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! GoalCell
        
        if let t = goals {
            let goal = cachedGoals.first(where: {$0.id == t.ids[indexPath.row]})
            cell.name.text = goal?.name
            cell.location.text = goal?.location
            if let count = goal?.participantIds.count {
                if (count == 1) { cell.participants.text = "\(count) Participant" }
                else { cell.participants.text = "\(count) Participants" }
            }
            cell.goalImage.layer.borderWidth = 1
            cell.goalImage.layer.masksToBounds = false
            cell.goalImage.layer.borderColor = UIColor.black.cgColor
            cell.goalImage.layer.cornerRadius = cell.goalImage.frame.height/2
            cell.goalImage.clipsToBounds = true
            if let imagePath = goal?.imagePaths[0] {
                let placeholder = UIImage(named: "placeholder")
                cell.goalImage.imageFromServerURL(imagePath, placeHolder: placeholder)
            }
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let goalID = goals?.ids[indexPath.row]
            if let goalVC = segue.destination as? GoalViewController {
                goalVC.eventId = goalID
            }
        }
    }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {

        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }

        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
