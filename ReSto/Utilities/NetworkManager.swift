//
//  NetworkManager.swift
//  ReSto
//
//  Created by Ivan Ganchev on 15.12.19.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static func getAll(descriptor: String, completion: @escaping (_ json: String) -> Void) {
        guard let t = token?.accessToken else { return }
        
        Alamofire.request(
            URL(string: serverIp + "/\(descriptor)")!,
            method: .get,
            headers: ["access-token": t])
            .validate()
            .responseString { (response) in
                guard response.result.isSuccess else {
                    print("Error response: \(String(describing: response.result.error))")
                    return
                }
                
                if let json = response.result.value {
                    completion(json)
                }
        }
    }
    
    static func getByID(descriptor: String, byID id: Int, completion: @escaping (_ json: String) -> Void) {
        guard let t = token?.accessToken else { return }
        
        Alamofire.request(
            URL(string: serverIp + "/\(descriptor)")!,
            method: .get,
            parameters: ["\(descriptor)id": id],
            headers: ["access-token": t])
            .validate()
            .responseString { (response) in
                guard response.result.isSuccess else {
                    print("Error response: \(String(describing: response.result.error))")
                    return
                }
                
                if let json = response.result.value {
                    completion(json)
                }
        }
    }
    
    static func authenticate(user: String, pass: String, completion: @escaping (_ json: String) -> Void) {        
        Alamofire.request(
            URL(string: serverIp + "/login")!,
            method: .get,
            parameters: ["user": user, "pass": pass])
            .validate()
            .responseString { (response) in
                guard response.result.isSuccess else {
                    print("Error response: \(String(describing: response.result.error))")
                    return
                }
                
                if let json = response.result.value {
                    completion(json)
                }
        }
    }
    
    static func getImage(fromURL URLString: String?, completion: @escaping (_ image: UIImage) -> ()) {
        let placeholder = UIImage(named: "placeholder")
        let imageView = UIImageView(image: placeholder)
        if let URLString = URLString {
            imageView.imageFromServerURL(URLString, placeHolder: placeholder, completion: completion)
        }
    }
    
    static func add(descriptor: String, parameters: Parameters, completion: @escaping (_ json: String) -> Void) {
        guard let t = token?.accessToken else { return }
        
        Alamofire.request(
            URL(string: serverIp + "/\(descriptor)")!,
            method: .get,
            parameters: parameters,
            headers: ["access-token": t])
            .validate()
            .responseString { (response) in
                guard response.result.isSuccess else {
                    print("Error response: \(String(describing: response.result.error))")
                    return
                }
        }
    }
    
    static func loadUser() {
        NetworkManager.getAll(descriptor: "userinfo") { json in
                   do {
                       let user = try User(json)
                       
                       NetworkManager.getImage(fromURL: user.imageStr) { image in
                           user.image = image
                           globalUser = user
                           
                           savedChanged = false
                       }
                   } catch {
                       print(error)
                       print("Could not parse response")
                   }
               }
    }
}
