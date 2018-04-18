//
//  CacheItem.swift
//  Livby
//
//  Created by mac on 17/2/28.
//  Copyright © 2017年 hw. All rights reserved.
//

import Foundation
import Realm
import Realm.Private
import RealmSwift
import ObjectMapper
// MARK: - CacheItem

open class CacheItem: Object {
    
    var key: String?
    
    var value: String?
    
    var expires: Double = 0.0
    
    // 主键
    override open static func primaryKey() -> String? {
        return "key"
    }
    
    var isValid: Bool {
        return self.expires > Date.timeIntervalSinceReferenceDate
    }
}

extension CacheItem {
    
    public static let em = RealmEntityManager<CacheItem>(realm: Realm.sharedRealm)
}

