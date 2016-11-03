//
//  CacheTool.swift
//  CowGoods
//
//  Created by ddn on 16/7/7.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation

let CartCache = "CartCache"
let AccountCache = "AccountCache"

private let cacheTool = CacheTool()

private let diskCachePath = "AccountCache".cacheDir()

class CacheTool {
    
    private lazy var diskCache : YYDiskCache = { [weak self] in
        let diskCache = YYDiskCache(path: diskCachePath)
        return diskCache!
        }()
    
    private lazy var memCache : YYMemoryCache = { [weak self] in
        let memCache = YYMemoryCache()
        memCache.shouldRemoveAllObjectsOnMemoryWarning = true
        memCache.ageLimit = 60 * 60 * 6
        return memCache
        }()
    
    class func sharedInstance() -> CacheTool {
        return cacheTool
    }
    
    class func set(obj: NSCoding, forKey key: String) {
        cacheTool.diskCache.setObject(obj, forKey: key)
    }
    
    class func remove(key key: String) {
        cacheTool.diskCache.removeObjectForKey(key)
    }
    
    class func get(key key: String) -> AnyObject? {
        return cacheTool.diskCache.objectForKey(key)
    }
    
    class func hold(obj: AnyObject, forKey key: String) {
        cacheTool.memCache.setObject(obj, forKey: CartCache)
    }
    
    class func clear(key key: String) {
        cacheTool.memCache.removeObjectForKey(CartCache)
    }
    
    class func take(key key: String) -> AnyObject? {
        return cacheTool.memCache.objectForKey(CartCache)
    }
}