//
//  App.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation

public struct App {
    
    public enum RunMode {
        case debug, release
    }
    
    public static var runMode: RunMode = .debug
    
    public static var bundle: Bundle {
        return Bundle.main
    }
    
    public static var version: String {
        return bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    public static var buildNumber: Int {
        return Int(bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0") ?? 0
    }
    
    public static var lang: String {
        return bundle.preferredLocalizations.first ?? ""
    }
    
}
