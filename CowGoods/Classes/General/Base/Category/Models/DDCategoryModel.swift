//
//  DDCategoryModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/21.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDCategoryModel: DDBaseModel {
    
    var id: String? = ""
    var mobile_name: String? = ""
    var level: String? = ""
    var categories: [DDCategoryModel]? = [DDCategoryModel]()
    var image: String? = ""
    
    var imageUrl: NSURL? {
        get {
            return NSURL(string: image ?? "")
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        if key == "domains" {
            if let value = value as? [[String : AnyObject]] {
               
                categories = DDCategoryModel.instances(value) as? [DDCategoryModel]
            }
        }else {
            super.setValue(value, forUndefinedKey: key)
        }
    }
}
