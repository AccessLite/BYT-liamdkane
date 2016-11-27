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
    private static func setRequest (url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    internal class func getFoaas(url: URL, completion: @escaping (Foaas?)->Void) {
        let request = self.setRequest(url: url)
        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
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
        let request = self.setRequest(url: URL(string: "https://www.foaas.com/operations")!)
        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            self.handle(error, and: response)
            if let d = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: d, options: []) as! [[String: AnyObject]]
                    completion(json.flatMap{ FoaasOperation(json: $0) })
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
