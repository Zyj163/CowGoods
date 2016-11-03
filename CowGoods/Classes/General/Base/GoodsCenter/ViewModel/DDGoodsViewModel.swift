//
//  DDGoodsViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/20.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire

class DDGoodsViewModel: DDBaseMoreDataViewModel {
    var user: DDUserModel? {
        return DDUserModel.loadAccount()
    }
    
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
        
        Alamofire.request(Router.CloudHouse(token: user?.token ?? "", currentPage: "\(currentPage)", pageSize: "\(pageSize)")).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
    }
    
    override func refresh(pageSize: Int, completion: () -> Void) {
        currentPage = 1
        
        Alamofire.request(Router.CloudHouse(token: user?.token ?? "", currentPage: "\(currentPage)", pageSize: "\(pageSize)")).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
    }
}
