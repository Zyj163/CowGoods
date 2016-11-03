//
//  DDCompareViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/17.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire

class DDCompareViewModel: DDBaseMoreDataViewModel {
    
    override var modelClass: DDBaseModel.Type {
        return DDGoodsModel.self
    }
    
    func original_img(indexPath: NSIndexPath) -> String? {
        if let model = self[indexPath] as? DDGoodsModel {
            return model.original_img
        }
        return nil
    }
    
    func goods_name(indexPath: NSIndexPath) -> String? {
        if let model = self[indexPath] as? DDGoodsModel {
            return model.goods_name
        }
        return nil
    }
    
    override func getMore(pageSize: Int, completion: () -> Void) {
        currentPage += 1
        
        Alamofire.request(Router.GoodsList(cat_id: "421", brand_id: "", currentPage: "\(currentPage)", pageSize: "\(pageSize)")).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
    }
    
    override func refresh(pageSize: Int, completion: () -> Void) {
        currentPage = 1
        
        Alamofire.request(Router.GoodsList(cat_id: "421", brand_id: "", currentPage: "\(currentPage)", pageSize: "\(pageSize)")).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
    }
    
    func toNextVc(indexPath: NSIndexPath) -> UIViewController? {
        
        if let model = self[indexPath] as? DDGoodsModel {
            
            let goodsVc = DDGoodsDetailViewController()
            
//            goodsVc.url = model.
            
            return goodsVc
        }
        return nil
    }
}











