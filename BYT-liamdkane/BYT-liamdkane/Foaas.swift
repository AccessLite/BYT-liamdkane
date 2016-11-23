//
//  Foaas.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class Foaas: JSONConvertible, CustomStringConvertible {
    let message: String
    let subtitle: String
    var description: String {
        return "Message: \(self.message), Subtitle: \(self.subtitle)"
    }
    
    init (message: String, subtitle: String) {
        self.message = message
        self.subtitle = subtitle
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard
            let message = json["message"] as? String,
            let subtitle = json["subtitle"] as? String else {
                return nil
        }
        self.init(message: message, subtitle: subtitle)
    }
    
    func toJson() -> [String : AnyObject] {
        return [
            "message" : self.message as AnyObject,
            "subtitle" : self.subtitle as AnyObject
        ]
    }
    
}
