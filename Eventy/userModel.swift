//
//  userModel.swift
//  Eventy
//
//  Created by Ivan Ganchev on 17/02/2018.
//

import Foundation
import Alamofire


class userModel {
    
    private var _name: String?
    private var _id: Int?
    private var _events: [Int]?
    private var _profilePic: String?
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    
    func downloadData(completed: @escaping ()-> ()) {
        
        let url = URL(string: "http://localhost:8080/userinfo")!
        
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard, let main = dict["main"] as? JSONStandard, let name = main["name"] as? String {
                
                print(name)
                
                self._name = name;
            }
            
            completed()
        })
    }
    
    var name: String {
        return _name ?? "Invalid name"
    }
}
