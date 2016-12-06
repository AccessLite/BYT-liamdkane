//
//  FoaasOperation.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation


enum data: Error {
    case dataFail
}

class FoaasOperation: JSONConvertible, DataConvertible {
    let name: String
    var url: String
    let fields: [FoaasField]
    
    init(name: String, url: String, fields: [FoaasField]) {
        self.name = name
        self.url = url
        self.fields = fields
    }
    
    //MARK: - Data Convertible
    func toData() throws -> Data {
        let data: Data = try JSONSerialization.data(withJSONObject: self.toJson(), options: [])
        return data
    }

    required convenience init?(data: Data) {
        do {
            let validJSON = try JSONSerialization.jsonObject(with: data, options: [])
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
        let fieldsJsonArr = self.fields.map { $0.toJson() }
        let json: [String: AnyObject] = [
            "name" : self.name as AnyObject,
            "url" : self.url as AnyObject,
            "fields" : fieldsJsonArr as AnyObject
        ]
        return json
    }
    
    required convenience init?(json: [String : AnyObject]) {
        guard
            let name = json["name"] as? String,
            let url = json["url"] as? String,
            let fieldsArr = json["fields"] as? [[String: AnyObject]] else {
                return nil
        }
        let fields = fieldsArr.flatMap { FoaasField(json: $0) }
        
        self.init(name: name, url: url, fields: fields)
    }
}
