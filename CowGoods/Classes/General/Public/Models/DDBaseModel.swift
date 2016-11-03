//
//  DDBaseModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDBaseModel: NSObject, NSCoding {
    
    var a = 1
    
    override init() {
        super.init()
    }
    
    // 归档
    func encodeWithCoder(aCoder: NSCoder) {
        
        let mirror = Mirror(reflecting: self)
        
        for p in mirror.children {
            if let name = p.label {
                aCoder.encodeObject(valueForKeyPath(name), forKey: name)
            }
        }
    }
    
    // 解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        let mirror = Mirror(reflecting: self)
        
        for p in mirror.children {
            if let name = p.label {
                setValue(aDecoder.decodeObjectForKey(name) as? String, forKeyPath: name)
            }
        }
    }
    
    class func instance(dic: [String : AnyObject]) -> DDBaseModel {
        let model = super.init()
        model.setValuesForKeysWithDictionary(dic)
        return model as! DDBaseModel
    }
    
    class func instances(arr: [AnyObject]) -> [DDBaseModel] {
        return arr.flatMap { (dic) -> DDBaseModel? in
            
            guard dic is [String : AnyObject] else {
                return nil
            }
            return instance(dic as! [String : AnyObject])
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override func valueForUndefinedKey(key: String) -> AnyObject? {
        return nil
    }
    
    override func setNilValueForKey(key: String) {
        
    }
    
    override var description: String {
        
        var values = [String]()
        
        let mirror = Mirror(reflecting: self)
        
        for p in mirror.children {
            values.append(p.label!)
        }
        
        let dict = dictionaryWithValuesForKeys(values)
        return "\(dict)"
    }
}
