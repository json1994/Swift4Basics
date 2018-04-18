//
//  Session.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation
import CoreLocation

open class Session: LocalStorage {
    /* Tick */
    
    public static let shareSession = Session()
    
    
    /* deviceId */
    open var deviceId: String {
        get {
            if let udid = string(forKey: "UDID") {
                return udid
            }
            
            let udid = UDID.UDIDString
            setObject(udid as AnyObject?, forKey: "UDID")
            
            return udid
        }
        set { setObject(newValue as AnyObject?, forKey: "UDID") }
    }
}

