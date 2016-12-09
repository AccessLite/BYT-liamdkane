//
//  FoaasPathBuilder.swift
//  BYT-liamdkane
//
//  Created by C4Q on 12/7/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class FoaasPathBuilder {
    var operation: FoaasOperation!
    var operationFields: [String : String]!
    
    /**
     Flattens an array of [FoaasField] with identical keys, into a one-dimensional array of [String:String] while performing
     a case-insensitive comparison of key-value pairs to store only unique keys.
     
     - parameter operation: The `FoaasOperation` to use in building a URL path.
     */
    init(operation: FoaasOperation) {
        var fieldsDict: [String: String] = [:]
        _ = operation.fields.flatMap{ fieldsDict[$0.field] = $0.field }
        
        self.operation = operation
        self.operationFields = fieldsDict
    }
    
    /**
     Goes through a `FoaasOperation.url` to replace placeholder text with its corresponding value stored in self.operationsField
     in the correct order. The String is also passed back with percent encoding automatically applied.
     
     example:
     self.operationFields = [ "from" : "Grumpy Cat", "name" : "Nala Cat"]
     self.operation.url = "/bus/:name/:from/"
     
     build() // returns "/bus/Nala%20Cat/Grumpy%20Cat"
     
     - returns: A `String` that corresponds to the path component needed to create a `URL` to request a `Foaas` object
     */
    func build() -> String {
        var url = self.operation.url
        for (key, value) in self.operationFields {
            url = url.replacingOccurrences(of: ":\(key)", with: value)
        }
        return url
    }
    
    /**
     Updates the `value` of an element with the corresponding `key`. If the `key` does not exist, nothing happens.
     
     - parameter key: The key of an element in `self.operationFields`
     - parameter value: The value to change to.
     */
    func update(key: String, value: String)  {
        if self.operationFields[key] != nil {
            self.operationFields[key] = value
        }
    }
    
    /**
     Utility function to get the index of a specified key in its correct order in the `FoaasOperation.url` property.
     
     For example, for the Ballmer operation, its corresponding FoaasOperation.url is `/ballmer/:name/:company/:from`
     
     - indexOf(key: "name") // should return 0
     - indexOf(key: "company") // should return 1
     - indexOf(key: "from") // should return 2
     - indexOf(key: ":name") // should return nil
     - indexOf(key: "tool") // should return nil
     
     - parameter key: The key in self.operationFields to search for.
     - returns: The index position of the key if it exists in self.operationFields. `nil` otherwise.
     - seealso: `FoaasPathBuilder.allKeys`
     */
    func indexOf(key: String) -> Int? {
        return self.allKeys().index(of: key)
    }
    
    /**
     Utility method that returns all of the keys for a `FoaasOperation`'s `field`s
     
     - returns: The keys contained in `self.operation.fields` as `[String]`
     */
    func allKeys() -> [String] {
        return self.operation.fields.map { $0.field }
    }
}
