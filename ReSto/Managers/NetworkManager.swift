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
}
