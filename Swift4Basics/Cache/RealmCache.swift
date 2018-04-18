//
//  RealmCache.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

open class RealmCache: Cachable {
    
    let realm:Realm
    
    public init(realm:Realm){
        self.realm = realm
    }
    
    public func value(forKey key: String) -> CacheItem? {
        
        if let item = realm.object(ofType: CacheItem.self, forPrimaryKey: key as AnyObject) , item.isValid {
            return item
        }
        return nil
    }
    
    open func setValue(_ value: CacheItem) {
        try! realm.write {
            realm.add(value, update: true)
        }
    }
    public func string(forKey key: String) -> String? {
        
        return value(forKey: key)?.value
    }
    
    public func setString(_ value: String, forKey key: String, expires: Double?) {
        let item = CacheItem()
        item.key = key
        item.value = value
        item.expires = expires ?? Date.distantFuture.timeIntervalSince1970
        setValue(item)
    }
    
    public func remove(forKey key: String) {
        guard let item = value(forKey: key) else { return }
        try! realm.write {
            realm.delete(item)
            Log.info("RealmCache: remove cache \"\(key)\"")
        }
    }
    
    open func clear() {
        do {
            if !realm.isEmpty {
                try realm.write {
                    realm.delete(realm.objects(CacheItem.self))
                }
            }
            Log.info("RealmCache: clear")
        } catch let error as NSError  {
            Log.error("RealmCache: clear. \(error)")
        }
    }
}
