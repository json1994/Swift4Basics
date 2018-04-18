//
//  Notifications.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation

public struct Notifications {
    
    public static let notificationCenter = NotificationCenter.default
    
    public static let reachabilityChanged = Proxy(name: "ReachabilityChanged")
    
    open class Proxy {
        fileprivate let name: String
        
         public init(name: String) {
            self.name = name
        }
        
        open func post(_ object: AnyObject? = nil, userInfo: [String: AnyObject]? = nil) {
            Log.info("@N>\(name) object=\(String(describing: object)) userInfo=\(String(describing: userInfo))")
            async {
                notificationCenter.post(name: Notification.Name(rawValue: self.name), object: object, userInfo: userInfo)
            }
        }
        
        open func addObserver(_ observer: AnyObject, selector: Selector, sender object: AnyObject? = nil) {
            Log.info("@N+\(name) \(selector)@\(observer)")
            notificationCenter.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
        }
        
        open func removeObserver(_ observer: AnyObject, sender object: AnyObject? = nil) {
            Log.info("@N-\(name) \(observer)")
            notificationCenter.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
        }
    }
    
    public static func removeAll(forObserver observer: AnyObject) {
        Log.info("@N#\(observer)")
        notificationCenter.removeObserver(observer)
    }
}
