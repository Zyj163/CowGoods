//
//  DDGoodsDetailModel.swift
//  CowGoods
//
//  Created by ddn on 16/7/4.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDGoodsDetailModel: DDGoodsModel {
    
    var goods_spec_price: [PriceModel] = [PriceModel]()
    var goods_spec: [GoodsCategoryModel] = [GoodsCategoryModel]()
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "goods_spec_price" {
            if value is [AnyObject] {
                goods_spec_price = PriceModel.instances(value as! [AnyObject]) as! [PriceModel]
            }
        }else if key == "goods_spec" {
            if value is [AnyObject] {
                goods_spec = GoodsCategoryModel.instances(value as! [AnyObject]) as! [GoodsCategoryModel]
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

class PriceModel: DDBaseModel {
    var spec_key: [String] = [String]()
    var spec_price: String = ""
    var store_count: String = ""
}

class GoodsCategoryModel: DDBaseModel {
    var name: String = ""
    var specs: [GoodsCategoryDetailModel] = [GoodsCategoryDetailModel]()
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "specs" {
            if value is [AnyObject] {
                specs = GoodsCategoryDetailModel.instances(value as! [AnyObject]) as! [GoodsCategoryDetailModel]
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}

class GoodsCategoryDetailModel: DDBaseModel {
    var id = ""
    var item = ""
}











