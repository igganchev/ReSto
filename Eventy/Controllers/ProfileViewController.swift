//
//  ProfileViewController.swift
//  Eventy
//
//  Created by Valentin Varbanov on 17.02.18.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var mainUser: User?
    
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let id = self.userId {
            loadUser(id: id) { [unowned self] in
                self.reloadData()
            }
        } else {
            loadProfile { [unowned self] in
                self.reloadData()
            }
        }
    }
    
    
    func loadProfile(completion: @escaping () -> Void) {
        guard let t = token?.accessToken else { return }
        
        Alamofire.request(
            URL(string: serverIp + "/userinfo")!,
            method: .get,
            headers: ["access-token" : t])
            .validate()
            .responseString { [unowned self] (response) -> Void in // ATTENTION [unowned self] to prevent reference cycle
                guard response.result.isSuccess else {
                    print("Error response: \(String(describing: response.result.error))")
                    completion()
                    return
                }
                
                do {
                    if let json = response.result.value {
                        self.mainUser = try User(json)
                        
                        self.nameLabel.text = self.mainUser!.name
                        
                        
                        let profilePicUrl = URL(string: self.mainUser!.profilePicPath)
                        
                        // load without blocking the UI
                        DispatchQueue.global().async {
                            let imageData: Data = try! Data(contentsOf: profilePicUrl!)
                            DispatchQueue.main.async { [unowned self] in
                                self.profileImage.image = UIImage(data: imageData)
                            }
                        }
                        
                        // add the used to the cache for later use
                        if let user = self.mainUser {
                            cachedUsers = cachedUsers.filter { $0.id != user.id }
                            cachedUsers.append(user)
                        }
                        
                    }
                } catch {
                    print("Could not parse response")
                }
                completion()
        }
    
    }
    
    func loadUser(id: Int, completion: @escaping () -> Void) {
        guard let t = token?.accessToken else { return }
        
        Alamofire.request(
            URL(string: serverIp + "/user")!,
            method: .get,
            parameters: ["userid": "\(id)"],
            headers: ["access-token" : t])
            .validate()
            .responseString { [unowned self] (response) -> Void in // ATTENTION [unowned self] to prevent reference cycle
                guard response.result.isSuccess else {
                    print("Error response: \(String(describing: response.result.error))")
                    completion()
                    return
                }
                
                do {
                    if let json = response.result.value {
                        self.mainUser = try User(json)
                        
                        self.nameLabel.text = self.mainUser!.name
                        
                        
                        let profilePicUrl = URL(string: self.mainUser!.profilePicPath)
                        
                        // load without blocking the UI
                        DispatchQueue.global().async {
                            let imageData: Data = try! Data(contentsOf: profilePicUrl!)
                            DispatchQueue.main.async { [unowned self] in
                                self.profileImage.image = UIImage(data: imageData)
                            }
                        }
                        
                        // add the used to the cache for later use
                        if let user = self.mainUser {
                            cachedUsers = cachedUsers.filter { $0.id != user.id }
                            cachedUsers.append(user)
                        }
                        
                    }
                } catch {
                    print("Cound not parse response")
                }
                completion()
        }
        
    }
    
    func loadEvent(id: Int, completion: @escaping () -> Void) {
        
        guard let t = token?.accessToken else { return }
        Alamofire.request(
            URL(string: serverIp + "/event")!,
            method: .get,
            parameters: ["eventid": "\(id)"],
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
                        let event = try Goal(json)
                        
                        cachedGoals = cachedGoals.filter { $0.id != event.id }
                        cachedGoals.append(event)
                    } else {
                        print("Could not get json")
                    }
                } catch {
                    print("Cound not parse response")
                }
                completion()
        }
    }
    
    func reloadCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.async { [unowned self] in
            if self.lastItemsInSection == (self.mainUser?.eventsIds.count ?? 0) {
                // just reload the cell with the info of the newly loaded event
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                // the section has wrong number of rows -> reload
                self.tableView.reloadSections([0], with: .automatic)
            }
            
        }
    }
    
    func reloadData() {
        if let events = self.mainUser?.eventsIds {
            for id in events {
                if cachedGoals.firstIndex(where: { $0.id == id }) != nil {
                    self.reloadCell(index: events.firstIndex(of: id)!)
                } else {
                    self.loadEvent(id: id) { [unowned self] in
                        self.reloadCell(index: events.firstIndex(of: id)!)
                    }
                }
            }
        }
    }
    
    // Table view:
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var lastItemsInSection = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        lastItemsInSection = self.mainUser?.eventsIds.count ?? 0
       
        return lastItemsInSection
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
                
        if let t = mainUser {
            let goal = cachedGoals.first(where: {$0.id == t.eventsIds[indexPath.row]})
            cell.textLabel?.text = goal?.name
            if let progress = goal?.progress {
                cell.detailTextLabel?.text = String(progress)
            }
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let indexPath = tableView.indexPathForSelectedRow{
            let eventId = mainUser?.eventsIds[indexPath.row]
            if let eventVC = segue.destination as? GoalViewController {
                eventVC.goalID = eventId
            }
        }
    }
    
}

