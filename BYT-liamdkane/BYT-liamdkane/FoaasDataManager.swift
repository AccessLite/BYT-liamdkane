//
//  FoaasDataManager.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/22/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class FoaasDataManager {
    // consts/vars are always defined at the top of a class
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    static let shared = FoaasDataManager()
    private init () {}
    
    func save(operations: [FoaasOperation]) {
        FoaasDataManager.shared.operations = operations
        let data: [Data] = operations.flatMap { try? $0.toData() }
        FoaasDataManager.defaults.set(data, forKey: FoaasDataManager.operationsKey)
    }
    
    func load() -> Bool {
        guard let defaultsData = FoaasDataManager.defaults.value(forKey: FoaasDataManager.operationsKey) as? [Data] else { return false }
        let operations = defaultsData.flatMap{ FoaasOperation(data: $0) }
        FoaasDataManager.shared.operations = operations
        return true
    }
    
    func deleteStoredOperations() {
        FoaasDataManager.defaults.removeObject(forKey: FoaasDataManager.operationsKey)
        FoaasDataManager.shared.operations = nil
    }
}
