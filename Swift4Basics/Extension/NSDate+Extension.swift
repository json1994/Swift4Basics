//
//  NSDate+Extension.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation


let kMinute = 60
let kHour = kMinute * 60
let kDaySeconds = kHour * 24
let kDayMinutes = kMinute * 24
let kWeek = kDayMinutes * 7
let kMonth = kDayMinutes * 31
let kYear = kDayMinutes * 365


func NSDateTimeAgoLocalizedStrings(key: String) -> String {
    
    let path = NSURL(fileURLWithPath: Bundle.main.resourcePath!).appendingPathComponent("NSDateTimeAgo.bundle")
    guard let bundle = Bundle(url: path!) else {
        return ""
    }
    return NSLocalizedString(key, tableName: "NSDateTimeAgo", bundle: bundle, comment: "")
}


// MARK: Format
extension Date {
    
    var currentCalendar: NSCalendar {
        return NSCalendar.current as NSCalendar
    }
    
    var calendarUnit: NSCalendar.Unit {
        return ([.year, .month, .day, .weekOfMonth, .weekday, .day, .hour, .minute, .second])
    }
    /// 获取NSDateComponents，包含：年 月 日 时 分 秒 周
    var components: NSDateComponents {
        return currentCalendar.components(calendarUnit, from: self) as NSDateComponents
    }
    
    var seconds: Int {
        return components.second
    }
    
    var minutes: Int {
        return components.minute
    }
    
    var hours: Int {
        return components.hour
    }
    
    var time: String {
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    var daysUntilNow: NSNumber {
        let interval = NSDate().timeIntervalSince(self)
        let days: Int = Int(interval) / kDaySeconds
        return NSNumber(value: days)
    }
    
    var midhight: NSDate {
        let calendar = currentCalendar
        let components: NSCalendar.Unit = [.day, .month, .year]
        let comps = calendar.components(components, from: self)
        return calendar.date(from: comps)! as NSDate
    }
    
    func dateSinceMidnightByAddingTimeInterval(timeInterval: TimeInterval) -> NSDate {
        let midnight = self.midhight
        return midnight.addingTimeInterval(timeInterval)
    }
    
    /// 日期格式化成字符串
    public func string(format: String) -> String {
        return DateFormatter(dateFormat: format).string(from: self)
    }
}

extension String {
    /// 从格式化的字符串中创建日期对象
    public func date(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return DateFormatter(dateFormat: format).date(from: self)
    }
}

// MARK: Properties

extension Date {
    /// Unix Timestamp: 从格林威治时间1970年01月01日00时00分00秒起至现在的总秒数
    public var unixTimestamp: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    /// Timestamp: 从格林威治时间1970年01月01日00时00分00秒起至现在的总豪秒数
    public var timestamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

extension Date{
    // shows 1 or two letter abbreviation for units.
    // does not include 'ago' text ... just {value}{unit-abbreviation}
    // does not include interim summary options such as 'Just now'
    public var timeAgoSimple: String {
        
        let now = Date()
        let deltaSeconds = Int(fabs(timeIntervalSince(now)))
        let deltaMinutes = deltaSeconds / 60
        
        var value: Int!
        
        if deltaSeconds < kMinute {
            // Seconds
            return stringFromFormat(format: "%%d%@s", withValue: deltaSeconds)
        } else if deltaMinutes < kMinute {
            // Minutes
            return stringFromFormat(format: "%%d%@m", withValue: deltaMinutes)
        } else if deltaMinutes < kDayMinutes {
            // Hours
            value = Int(floor(Float(deltaMinutes / kMinute)))
            return stringFromFormat(format: "%%d%@h", withValue: value)
        } else if deltaMinutes < kWeek {
            // Days
            value = Int(floor(Float(deltaMinutes / kDayMinutes)))
            return stringFromFormat(format: "%%d%@d", withValue: value)
        } else if deltaMinutes < kMonth {
            // Weeks
            value = Int(floor(Float(deltaMinutes / kWeek)))
            return stringFromFormat(format: "%%d%@w", withValue: value)
        } else if deltaMinutes < kYear {
            // Month
            value = Int(floor(Float(deltaMinutes / kMonth)))
            return stringFromFormat(format: "%%d%@mo", withValue: value)
        }
        
        // Years
        value = Int(floor(Float(deltaMinutes / kYear)))
        return stringFromFormat(format: "%%d%@yr", withValue: value)
    }
    
    public var timeAgo: String {
        
        let now = Date()
        let deltaSeconds = Int(fabs(timeIntervalSince(now)))
        let deltaMinutes = deltaSeconds / 60
        
        var value: Int!
        
        if deltaSeconds < 5 {
            // Just Now
            return NSDateTimeAgoLocalizedStrings(key: "Just now")
        } else if deltaSeconds < kMinute {
            // Seconds Ago
            return stringFromFormat(format: "%%d %@seconds ago", withValue: deltaSeconds)
        } else if deltaSeconds < 120 {
            // A Minute Ago
            return NSDateTimeAgoLocalizedStrings(key: "A minute ago")
        } else if deltaMinutes < kMinute {
            // Minutes Ago
            return stringFromFormat(format: "%%d %@minutes ago", withValue: deltaMinutes)
        } else if deltaMinutes < 120 {
            // An Hour Ago
            return NSDateTimeAgoLocalizedStrings(key: "An hour ago")
        } else if deltaMinutes < kDayMinutes {
            // Hours Ago
            value = Int(floor(Float(deltaMinutes / kMinute)))
            return stringFromFormat(format: "%%d %@hours ago", withValue: value)
        } else if deltaMinutes < (kDayMinutes * 2) {
            // Yesterday
            return NSDateTimeAgoLocalizedStrings(key: "Yesterday")
        } else if deltaMinutes < kWeek {
            // Days Ago
            value = Int(floor(Float(deltaMinutes / kDayMinutes)))
            return stringFromFormat(format: "%%d %@days ago", withValue: value)
        } else if deltaMinutes < (kWeek * 2) {
            // Last Week
            return NSDateTimeAgoLocalizedStrings(key: "Last week")
        } else if deltaMinutes < kMonth {
            // Weeks Ago
            value = Int(floor(Float(deltaMinutes / kWeek)))
            return stringFromFormat(format: "%%d %@weeks ago", withValue: value)
        } else if deltaMinutes < (kDayMinutes * 61) {
            // Last month
            return NSDateTimeAgoLocalizedStrings(key: "Last month")
        } else if deltaMinutes < kYear {
            // Month Ago
            value = Int(floor(Float(deltaMinutes / kMonth)))
            return stringFromFormat(format: "%%d %@months ago", withValue: value)
        } else if deltaMinutes < (kDayMinutes * (kYear * 2)) {
            // Last Year
            return NSDateTimeAgoLocalizedStrings(key: "Last Year")
        }
        
        // Years Ago
        value = Int(floor(Float(deltaMinutes / kYear)))
        return stringFromFormat(format: "%%d %@years ago", withValue: value)
    }
    
    public func stringFromFormat(format: String, withValue value: Int) -> String {
        
        let localeFormat = String(format: format, getLocaleFormatUnderscoresWithValue(value: Double(value)))
        let localizedString = NSDateTimeAgoLocalizedStrings(key: localeFormat)
        
        return String(format: localizedString, value)
    }
    
    public func getLocaleFormatUnderscoresWithValue(value: Double) -> String {
        
        guard let localeCode = NSLocale.preferredLanguages.first else {
            return ""
        }
        
        if localeCode == "ru" || localeCode == "ru-RU" {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10
            
            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            
            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        return ""
    }
}

