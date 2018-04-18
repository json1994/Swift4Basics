//
//  String+Extension.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation
import CommonCrypto

// MARK: Length
extension String {
    /// 字符串长度
    public var length: Int { return self.count }
}

// MARK: URL encode/decode

extension String {
    /// URL编码
    public var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? self
    }
    
    public var urlEncodingWithQueryAllowedCharacters: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
    
    /// URL解码
    public var urlDecoded: String {
        return self.removingPercentEncoding ?? self
    }
}

// MARK: Digest

extension String {
    public var md5: String {
        let data = self.data
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }
    
    public var sha1: String {
        let data = self.data
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }
}

// MARK: Base64

extension String {
    /// Base64编码
    public var base64Encoded: String {
        return data.base64EncodedString(options: [])
    }
    
    /// Base64解码
    public var base64Decoded: String {
        return Data(base64Encoded: self, options: [])?.string ?? ""
    }
}

// MARK: Get the size of the text

extension String {
    /// 计算制定字体大小的文字显示尺寸（系统默认字体）
    public func size(fontSize: CGFloat, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        return size(font: UIFont.systemFont(ofSize: fontSize), width: width)
    }
    
    /// 计算制定字体的文字显示尺寸
    public func size(font: UIFont, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.paragraphStyle: paragraphStyle.copy()
        ]
        
        return (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
}

// MARK: Substring

extension String {
    public func substring(_ fromIndex: Int, _ toIndex: Int = Int.max) -> String? {
        let len = self.length
        var start: Int
        var end: Int
        if fromIndex < 0 {
            start = 0
            end = len + fromIndex
        } else {
            start = fromIndex
            if toIndex < 0 {
                end = len + toIndex
            } else {
                end = min(toIndex, len)
            }
        }
        
        if start > end {
            return nil
        }
        
        return self[start..<end]
    }
    
    public subscript(range: Range<Int>) -> String? {
        let len = self.length
        if range.lowerBound >= len || range.upperBound < 0 {
            return nil
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: max(0, range.lowerBound))
        let endIndex = self.index(self.startIndex, offsetBy: min(len, range.upperBound))
        
        return String(self[startIndex..<endIndex])
    }
    
    public subscript(index: Int) -> Character? {
        if index < 0 || index >= self.length {
            return nil
        }
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}

// MARK: Trim

extension String {
    /// 删除前后空白符（包含空格、Tab、回车、换行符）
    public var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

// MARK: Localized String

extension String {
    public var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
}


import SwiftyJSON

// MARK: - JSON

extension String {
    /// String to JSON
    public var json: JSON? { return try? JSON(data: self.data) }
}

extension JSON {
    /// JSON to String
    public var jsonString: String { return rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions()) ?? "" }
}

// MARK: - NSData

extension String {
    /// 返回UTF8字符集的NSData对象
    public var data: Data {
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
}

extension Data {
    /// 返回UTF8字符串
    public var string: String {
        return String(data: self, encoding: String.Encoding.utf8) ?? ""
    }
}

// MARK: - Int

extension String {
    public var int: Int32 { return (self as NSString).intValue }
    public var integer: Int { return (self as NSString).integerValue }
}

extension Int {
    public var string: String { return String(self) }
}

// MARK: - Float

extension String {
    public var float: Float { return (self as NSString).floatValue }
}

extension Float {
    public var string: String { return String(self) }
}

// MARK: - Double

extension String {
    public var double: Double { return (self as NSString).doubleValue }
}

extension Double {
    public var string: String { return String(self) }
}

// MARK: - Bool

extension String {
    public var bool: Bool { return (self as NSString).boolValue }
}

extension Bool {
    public var string: String { return self ? "true" : "false" }
}
