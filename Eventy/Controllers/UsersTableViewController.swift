//
//  UsersTableViewController.swift
//  Eventy
//
//  Created by Valentin Varbanov on 17.02.18.
//

import UIKit
import Alamofire

class UsersTableViewController: UITableViewController {
    
    var userIds: [Int]! = nil
    var createdByUserId: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadUser(id: Int, completion: @escaping () -> Void) {
        guard let t = token?.accessToken else { return }
        
        Alamofire.request(
            URL(string: serverIp + "/user")!,
            method: .get,
            parameters: ["userid": "\(id)"],
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
                        let user = try User(json)
                        
                        cachedUsers = cachedUsers.filter { $0.id != user.id }
                        cachedUsers.append(user)
                    }
                } catch {
                    print("Cound not parse response")
                }
                completion()
        }
    }
    
    func reloadData() {
        for id in userIds {
            if cachedUsers.firstIndex(where: { $0.id == id }) != nil {
                reloadCell(index: self.userIds.firstIndex(of: id)!)
            } else {
                loadUser(id: id) { [unowned self] in
                    self.reloadCell(index: self.userIds.firstIndex(of: id)!)
                }
            }
        }
    }
    
    func reloadCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIds.count
    }
    
    var imagesForUsers = [UIImage]()

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        if let user = cachedUsers.first(where: {$0.id == userIds[indexPath.row]}) {
            cell.textLabel?.text = user.name
            
            cell.detailTextLabel?.text = user.id == createdByUserId ?  "(creator)" : ""
            
            
            if let image = imagesForUsers[safe: indexPath.row] {
                cell.imageView?.image = image
            } else {
                if let url = URL(string: user.profilePicPath) {
                    DispatchQueue.global().async {
                        do {
                            let imageData: Data = try Data(contentsOf: url)
                            DispatchQueue.main.async { [weak self] in
                                guard let img = UIImage(data: imageData) else { return }
                                self?.imagesForUsers.reserveCapacity(indexPath.row)
                                self?.imagesForUsers.insert(img, at: indexPath.row)
                                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        } catch {
                            print("Could not load image from url: \(user.profilePicPath)")
                        }
                    }
                }
            }
            
            
        }

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let userId = userIds[indexPath.row]
            if let profileVC = segue.destination as? ProfileViewController {
                profileVC.userId = userId
            }
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
