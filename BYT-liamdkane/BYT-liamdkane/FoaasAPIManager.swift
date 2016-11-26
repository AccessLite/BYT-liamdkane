//
//  FoaasAPIManager.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class FoaasAPIManager {
    
    private static let defaultSession: URLSession = URLSession(configuration: .default)
    private static let operationsURL: URL = URL(string: "https://www.foaas.com/operations")!
    private static func handle(_ error: Error?, and response: URLResponse?) {
        if let e = error{
            print(e.localizedDescription)
        }
        if let httpReponse = response as? HTTPURLResponse {
            print(httpReponse.statusCode)
        }
    }
    
    internal class func getFoaas(url: URL, completion: @escaping (Foaas?)->Void) {
        defaultSession.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            self.handle(error, and: response)
            if let d = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: d, options: []) as! [String: AnyObject]
                    completion(Foaas(json: json))
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    internal class func getOperations(completion: @escaping ([FoaasOperation]?)->Void ) {
        let request = URLRequest(url: self.operationsURL)
        
        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            self.handle(error, and: response)
            if let d = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: d, options: []) as! [[String: AnyObject]]
                    completion(json.flatMap{ FoaasOperation(json: $0) })
                }
                catch {
                    print(error.localizedDescription)
                }            }
        }.resume()
    }
}
