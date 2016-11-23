//
//  FoaasOperation.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class FoaasOperation: JSONConvertible, DataConvertible {
    let name: String
    let url: String
    //TODO: Clarify if Louis wants to nest objects in this property or nah
    // if you mean make this [FoaasField]: yes
    let fields: [[String: AnyObject]]
    
    init(name: String, url: String, fields: [[String: AnyObject]]) {
        self.name = name
        self.url = url
        self.fields = fields
    }
    
    //MARK: - Data Convertible
    
    func toData() throws -> Data {
        // nice!! I was looking for this specific solution (but as a 1-liner)
        return try JSONSerialization.data(withJSONObject: self.toJson(), options: [])
    }
    
    required convenience init?(data: Data) {
        do {
            let validJSON = try JSONSerialization.jsonObject(with: data, options: [])
            // always have {} bookmarked by (at least) a space
            guard let validObject = validJSON as? [String: AnyObject] else { return nil }
            self.init(json: validObject)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - JSON Convertible
    
    func toJson() -> [String : AnyObject] {
        return [
            "name" : self.name as AnyObject,
            "url" : self.url as AnyObject,
            "fields" : self.fields as AnyObject // this will need some changes after you make fields [FoaasField]
        ]
    }
    
    required convenience init?(json: [String : AnyObject]) {
        guard
            let name = json["name"] as? String,
            let url = json["url"] as? String,
            let fields = json["fields"] as? [[String: AnyObject]] else {
                return nil
        }
        // convert fields to [FoaasField]
        self.init(name: name, url: url, fields: fields)
    }
}
