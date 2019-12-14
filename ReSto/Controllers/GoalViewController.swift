//
//  EventViewController.swift
//  Eventy
//
//  Created by Ivan Ganchev on 14.12.19.
//

import UIKit

class GoalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    @IBOutlet weak var imageTableView: UITableView! {
        didSet {
            imageTableView.delegate = self
            imageTableView.dataSource = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let id = goalID {
            goal = cachedGoals.first(where: { $0.id == id })
        }
        
        myTitle = goal?.name ?? ""
        
        if let progress = goal?.progress {
            progressLabel.text = String(progress)
        }
        
        mainImage.loadAsync(fromUrl: goal?.image.first)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        let image = UIImagePickerController();
        image.delegate = self
        // TODO: Implement upload from both album and camera
        image.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        image.allowsEditing = true
        
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            // TODO: Use image here
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let userIds = [1]
        if let userVC = segue.destination as? UsersTableViewController {
            userVC.userIds = userIds
            if let createdByUserId = goal?.createdById {
                userVC.createdByUserId = createdByUserId
            }
        }
        
    }
 
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max((goal?.image.count ?? 0) - 1, 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
                
        if let cell = cell as? ImageTableViewCell {
            cell.myImage.loadAsync(fromUrl: goal?.image[indexPath.row + 1])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.width / 2
    }

}


extension UIImageView {
    func loadAsync(fromUrl stringUrl: String?) {
        guard let stringUrl = stringUrl else { return }
        
        if let url = URL(string: stringUrl) {
            DispatchQueue.global().async {
                
                do {
                    let imageData: Data = try Data(contentsOf: url)
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage(data: imageData)
                    }
                } catch {
                    print("Could not load image from url: \(stringUrl)")
                }
            }
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
