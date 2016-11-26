//
//  FoaasDataManager.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class FoaasDataManager {
    
    static let shared = FoaasDataManager()
    private init () {}
    
    
    
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    func save(operations: [FoaasOperation]) {
        
        let data: [Data] = operations.flatMap { try? $0.toData() }
        
        FoaasDataManager.defaults.set(data, forKey: FoaasDataManager.operationsKey)
    }
    
    func load() -> Bool {
        return FoaasDataManager.defaults.dictionary(forKey: FoaasDataManager.operationsKey) != nil
    }
    
    func deleteStoredOperations() {
        FoaasDataManager.defaults.removeObject(forKey: FoaasDataManager.operationsKey)
    }
}
