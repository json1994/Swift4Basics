//
//  RealmManager.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

extension Realm {
    
    public static let rootPath = (Realm.Configuration.defaultConfiguration.fileURL!.path as NSString).deletingLastPathComponent
    
    //MARK:share
    fileprivate static var _sharedRealm: Realm!
    
    public static var sharedRealm: Realm {
        if _sharedRealm == nil {
            _sharedRealm = try! Realm(fileURL: NSURL(string:"\(rootPath)/shared.realm")! as URL)
        }
        return _sharedRealm
    }
    
    public static func setSharedRealm(_ realm: Realm) {
        _sharedRealm = realm
    }
    
    //MAKR:user
    fileprivate static var _userRealm: Realm!
    
    public static var userRealm: Realm {
        if _userRealm == nil {
            
            return Realm.sharedRealm
        }
        return _userRealm
    }
    
    public static func setUserRealm(_ realm: Realm) {
        _userRealm = realm
    }
    
    public static func setUerRealmWithString(_ idOrName:String){
        
        _userRealm = try! Realm(fileURL: NSURL(string:"\(rootPath)/\(idOrName).realm")! as URL)
    }
    
    public static func resetUserRealm() {
        _userRealm = nil
    }
    

}

