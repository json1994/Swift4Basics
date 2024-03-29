//
//  URLCache.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation
import SystemConfiguration
import Reachability

open class SwiftURLCache: URLCache {
    
    public static var cacheFolder = "URLCache" // The folder in the Documents folder where cached files will be saved
    public static var memoryCapacity:Int = 16 * 1024 * 1024 // The maximum memory size that will be cached
    public static var diskCapacity:Int = 256 * 1024 * 1024 // The maximum file size that will be cached
    public static var filter: (_ request: URLRequest) -> Bool = { _ in return true }
    
    fileprivate static var cacheDirectory: String!
    
    // Activate LDURLCache
    open class func activate() {
        // set caching paths
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        cacheDirectory = URL(fileURLWithPath: cachePath).appendingPathComponent(cacheFolder).absoluteString
        let urlCache = SwiftURLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: cacheDirectory)
        URLCache.shared = urlCache
    }
    
    // Will be called by a NSURLConnection when it's wants to know if there is something in the cache.
    open override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        guard let url = request.url else {
            Log.error("CACHE not allowed for nil URLs")
            return nil
        }
        
        let absoluteString = url.absoluteString
        if absoluteString.isEmpty {
            Log.error("CACHE not allowed for empty URLs")
            return nil
        }
        
        if !SwiftURLCache.filter(request) {
            Log.error("CACHE skipped because of filter")
            return nil
        }
        
        if request.cachePolicy == .reloadIgnoringCacheData && !(try! Reachability().connection != .unavailable) || absoluteString.hasPrefix("file:") || absoluteString.hasPrefix("data:") {
            Log.warn("CACHE not allowed for \(url)")
            return nil
        }
        
        let storagePath = SwiftURLCache.storagePathForRequest(request, rootPath: SwiftURLCache.cacheDirectory)
        if !FileManager.default.fileExists(atPath: storagePath) {
            //Log.warn("CACHE not found \(storagePath) for \(url.absoluteString)")
            return nil
        }
        
        // Read object from file
        if let response = NSKeyedUnarchiver.unarchiveObject(withFile: storagePath) as? CachedURLResponse {
            //Log.info("Returning cached data from \(storagePath) for \(url.absoluteString)");
            
            // I have to find out the difrence. For now I will let the developer checkt which version to use
            //if LDURLCache.RECREATE_CACHE_RESPONSE {
            //// This works for most sites, but aperently not for the game as in the alternate url you see in ViewController
            //let r = NSURLResponse(URL: response.response.URL!, MIMEType: response.response.MIMEType, expectedContentLength: response.data.length, textEncodingName: response.response.textEncodingName)
            //return NSCachedURLResponse(response: r, data: response.data, userInfo: response.userInfo, storagePolicy: .Allowed)
            //}
            // This works for the game, but not for my site.
            return response
        } else {
            Log.error("The file is probably not put in the local path using NSKeyedArchiver \(storagePath)");
        }
        return nil
    }
    
    // Will be called by NSURLConnection when a request is complete.
    open override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        if !SwiftURLCache.filter(request) {
            return
        }
        if let httpResponse = cachedResponse.response as? HTTPURLResponse {
            if httpResponse.statusCode >= 400 {
                //Log.warn("CACHE Do not cache error \(httpResponse.statusCode) page for : \(request.URL) \(httpResponse.debugDescription)");
                return
            }
        }
        
        let storagePath = SwiftURLCache.storagePathForRequest(request, rootPath: SwiftURLCache.cacheDirectory)
        if storagePath.isEmpty {
            Log.error("Error building cache storage path")
        }
        let storageDirectory = NSString(string: storagePath).deletingLastPathComponent
        do {
            //Log.info("Creating cache directory \(storageDirectory)");
            try FileManager.default.createDirectory(atPath: storageDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            Log.error("Error creating cache directory \(storageDirectory)");
            Log.error("Error \(error.debugDescription)");
        }
        
        if cachedResponse.response.mimeType?.hasPrefix("image/") == true {
            if FileManager.default.fileExists(atPath: storagePath) {
                //Log.warn("CACHE not rewriting stored image file for \(request.URL!.absoluteString)");
                return
            }
        }
        
        if let previousResponse = NSKeyedUnarchiver.unarchiveObject(withFile: storagePath) as? CachedURLResponse {
            if previousResponse.data == cachedResponse.data {
                //Log.info("CACHE not rewriting stored file for \(request.URL!.absoluteString)");
                return
            }
        }
        
        // save file
        //Log.info("Writing data to \(storagePath) for \(request.URL!.absoluteString)");
        if !NSKeyedArchiver.archiveRootObject(cachedResponse, toFile: storagePath) {
            Log.error("Could not write file to cache");
        } else {
            //Log.info("CACHE save file to Cache  : \(storagePath)");
            // prevent iCloud backup
            if !SwiftURLCache.addSkipBackupAttributeToItemAtURL(URL(fileURLWithPath: storagePath)) {
                Log.warn("Could not set the do not backup attribute");
            }
        }
    }
    
    // return the path if the file for the request is in the PreCache or Cache.
    static func storagePathForRequest(_ request: URLRequest) -> String? {
        var storagePath: String? = SwiftURLCache.storagePathForRequest(request, rootPath: SwiftURLCache.cacheDirectory)
        if !FileManager.default.fileExists(atPath: storagePath ?? "") {
            storagePath = nil
        }
        return storagePath;
    }
    
    // build up the complete storrage path for a request plus root folder.
    static func storagePathForRequest(_ request: URLRequest, rootPath: String) -> String {
        if let urlString  = request.url?.absoluteString {
            let hash = "\(urlString.md5)\(urlString.sha1)".md5
            var localUrl = "\(rootPath)\(String(describing: hash[0]))/\(String(describing: hash.substring(1, 2)))/\(String(describing: hash[3..<32]))"
            if localUrl.hasPrefix("file:/") {
                localUrl = localUrl.substring(from: localUrl.index(localUrl.startIndex, offsetBy: 6))
            }
            localUrl = localUrl.replacingOccurrences(of: "//", with: "/")
            localUrl = localUrl.replacingOccurrences(of: "//", with: "/")
            return localUrl
        }
        return ""
    }
    
    static func addSkipBackupAttributeToItemAtURL(_ url: URL) -> Bool {
        do {
            try (url as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
            return true
        } catch _ as NSError {
            Log.error("ERROR: Could not set 'exclude from backup' attribute for file \(url.absoluteString)")
        }
        return false
    }
}
