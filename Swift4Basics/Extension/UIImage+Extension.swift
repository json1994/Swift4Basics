//
//  UIImage+Extension.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation
import UIKit
// MARK: Data

extension UIImage {
    
    public var data: Data? {
        switch contentType {
        case .jpeg:
            return self.jpegData(compressionQuality: 1)
        case .png:
            return self.pngData()
            //case .GIF:
        //return UIImageAnimatedGIFRepresentation(self)
        default:
            return nil
        }
    }
}

// MARK: Content Type

extension UIImage {
    fileprivate struct AssociatedKey {
        static var contentType: Int = 0
    }
    
    public enum ContentType: Int {
        case unknown = 0, png, jpeg, gif, tiff, webp
        
        public var mimeType: String {
            switch self {
            case .jpeg: return "image/jpeg"
            case .png:  return "image/png"
            case .gif:  return "image/gif"
            case .tiff: return "image/tiff"
            case .webp: return "image/webp"
            default:    return ""
            }
        }
        
        public var extendName: String {
            switch self {
            case .jpeg: return ".jpg"
            case .png:  return ".png"
            case .gif:  return ".gif"
            case .tiff: return ".tiff"
            case .webp: return ".webp"
            default:    return ""
            }
        }
        
        
        public static func contentType(mimeType: String?) -> ContentType {
            guard let mime = mimeType else { return .unknown }
            switch mime {
            case "image/jpeg": return .jpeg
            case "image/png":  return .png
            case "image/gif":  return .gif
            case "image/tiff": return .tiff
            case "image/webp": return .webp
            default:           return .unknown
            }
        }
        
        public static func contentTypeWithImageData(_ imageData: Data?) -> ContentType {
            guard let data = imageData else { return .unknown }
            
            var c = [UInt32](repeating: 0, count: 1)
            (data as NSData).getBytes(&c, length: 1)
            
            switch (c[0]) {
            case 0xFF:
                return .jpeg
            case 0x89:
                return .png
            case 0x47:
                return .gif
            case 0x49, 0x4D:
                return .tiff
            case 0x52:
                // R as RIFF for WEBP
                if data.count >= 12 {
                    if let type = String(data: data.subdata(in: data.startIndex..<data.startIndex.advanced(by: 12)), encoding: String.Encoding.ascii) {
                        if type.hasPrefix("RIFF") && type.hasSuffix("WEBP") {
                            return .webp
                        }
                    }
                }
                
            default: break
            }
            return .unknown
        }
    }
    
    public var contentType: ContentType {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedKey.contentType) as? Int ?? 0
            if value == 0 {
                var result: ContentType
                //if let _ = UIImageAnimatedGIFRepresentation(self) {
                //result = .GIF
                //} else
                if let _ = self.jpegData(compressionQuality: 1) {
                    result = .jpeg
                } else if let _ = self.pngData() {
                    result = .png
                } else {
                    result = .unknown
                }
                objc_setAssociatedObject(self, &AssociatedKey.contentType, result.rawValue, .OBJC_ASSOCIATION_RETAIN)
                return result
            }
            return ContentType(rawValue: value) ?? .unknown
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.contentType, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    convenience init?(data: Data, contentType: ContentType) {
        self.init(data: data)
        self.contentType = contentType
    }
}
