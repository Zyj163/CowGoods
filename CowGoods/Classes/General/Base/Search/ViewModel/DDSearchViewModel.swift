//
//  DDSearchViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/7/8.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DDSearchViewModel: DDVistorGoodsViewModel {
    
    var keywords: String! = ""
    
    var orderby: String?
    
    
    override var modelClass: DDBaseModel.Type {
        return DDGoodsModel.self
    }
    
//    func original_img(indexPath: NSIndexPath) -> String? {
//        if let model = self[indexPath] as? DDGoodsModel {
//            return model.original_img
//        }
//        return nil
//    }
//    
//    func goods_name(indexPath: NSIndexPath) -> String? {
//        if let model = self[indexPath] as? DDGoodsModel {
//            return model.goods_name
//        }
//        return nil
//    }
//    
//    func goods_current_price(indexPath: NSIndexPath) -> String? {
//        if let model = self[indexPath] as? DDGoodsModel {
//            return model.shop_price
//        }
//        return nil
//    }
//    
//    func goods_market_price(indexPath: NSIndexPath) -> String? {
//        if let model = self[indexPath] as? DDGoodsModel {
//            return model.market_price
//        }
//        return nil
//    }
//    
//    func goods_id(indexPath: NSIndexPath) -> String? {
//        if let model = self[indexPath] as? DDGoodsModel {
//            return model.goods_id
//        }
//        return nil
//    }
    
//    override func rowHeight(indexPath: NSIndexPath) -> CGFloat {
//        return 100
//    }
    
    override func getMore(pageSize: Int, completion: () -> Void) {
        currentPage += 1
        
        Alamofire.request(Router.Search(keywords: keywords)).responseJSON { [weak self] (response) in
            
            self?.doSomething(response, completion: completion)
        }
    }
    
    override func refresh(pageSize: Int, completion: () -> Void) {
        currentPage = 1
        
        Alamofire.request(Router.Search(keywords: keywords)).responseJSON { [weak self] (response) in
            
            self?.doSomething(response, completion: completion)
        }
    }
    
//    func toNext(indexPath: NSIndexPath) -> UIViewController? {
//        let vc = DDGoodsDetailViewController()
//        vc.goodId = goods_id(indexPath)
//        return vc
//    }
}
