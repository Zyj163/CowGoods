//
//  DDGoodsModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/20.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDGoodsModel: DDBaseModel {
    var goods_id: String? = ""
    var original_img: String? = ""
    
    var goods_remark: String? = ""
    var goods_name: String? = ""
    
    var store_count: String? = ""
    var shop_price: String? = ""
    var market_price: String? = ""
    
    var collect_type: String? = "0"
    
    override func setNilValueForKey(key: String) {
        if key == "collect_type" {
            collect_type = "0"
        }
    }
}
