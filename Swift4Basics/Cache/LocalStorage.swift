//
//  LocalStorage.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation

open class LocalStorage {
    
    fileprivate var defaults = UserDefaults.standard
    
    fileprivate var autoCommit = true
    
    open func setObject(_ object: Any?, forKey key: String) {
        if object == nil {
            defaults.removeObject(forKey: key)
            return
        }
        
        defaults.set(object!, forKey: key)
        if autoCommit {
            defaults.synchronize()
        }
    }
    
    open func object(forKey key: String) -> Any? {
        return defaults.object(forKey: key) as AnyObject?
    }
    
    open func integer(forKey key: String) -> Int {
        return defaults.integer(forKey: key)
    }
    
    open func float(forKey key: String) -> Float {
        return defaults.float(forKey: key)
    }
    
    open func double(forKey key: String) -> Double {
        return defaults.double(forKey: key)
    }
    
    open func string(forKey key: String) -> String? {
        return defaults.string(forKey: key)
    }
    
    open func string(forKey key: String, defaultValue: String) -> String {
        if let result = defaults.string(forKey: key) {
            return result
        } else {
            return defaultValue
        }
    }
    
    open func array(forKey key: String) -> [Any]? {
        return defaults.array(forKey: key) as [AnyObject]?
    }
    
    open func dictionary(forKey key: String) -> [String: Any]? {
        return defaults.dictionary(forKey: key) as [String : AnyObject]?
    }
    
    open func date(forKey key: String) -> Date! {
        var result = defaults.object(forKey: key) as? Date
        
        if result == nil {
            result = Date.distantPast
        }
        
        return result!
    }
    
    open func reset() {
        UserDefaults.resetStandardUserDefaults()
    }
    
    open func begin() {
        autoCommit = false
    }
    
    open func commit() {
        defaults.synchronize()
        autoCommit = true
    }

}
