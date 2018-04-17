//
//  APIRequestManager.swift
//  HyLi
//
//  Created by Kadell on 11/7/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import Foundation


class APIRequestManager {
    
    static let manager: APIRequestManager = APIRequestManager()
    
    func getPOD(endPoint: String, callback: @escaping(Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    
    
    
    func getData(endPoint: String,postData: String, callback: @escaping(Data?) -> Void) {
         let postString = postData
        guard let myURL = URL(string: endPoint) else { return }
        
        var request = URLRequest(url: myURL)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
//        let session = URLSession(configuration: URLSessionConfiguration.default)
        let session = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    
    
}

