//
//  DDGoodsDetailViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/7/4.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DDGoodsDetailViewModel: DDBaseViewModel {
    
    var model: DDGoodsDetailModel?
    
    var user: DDUserModel? {
        return DDUserModel.loadAccount()
    }
    
    private var current_choose = [Int : String]()
    
    var goods_img : NSURL? {
        if let urlStr = model?.original_img {
            return NSURL(string: urlStr)
        }
        return nil
    }
    
    var isCollected: Bool {
        let collect = model?.collect_type ?? "0"
        return (collect as NSString).boolValue
    }
    
    var current_properties: [String]? {
        return current_choose.values.flatMap{$0}
    }
    
    var rowCountForChoose: Int {
        return model?.goods_spec == nil ? 2 : model!.goods_spec.count + 2
    }
    
    var good_id: String? {
        return model?.goods_id
    }
    
    var current_count: Int = 1
    
    func goods_store(properties: [String]) -> String? {
        let result = model?.goods_spec_price.filter{
            Regexte.hasSameElements(arr: properties, otherArr: $0.spec_key)
        }
        
        return result?.first?.store_count ?? model?.store_count
    }
    
    func goods_price(properties: [String]) -> String? {
        let result = model?.goods_spec_price.filter{
            Regexte.hasSameElements(arr: properties, otherArr: $0.spec_key)
        }
        
        return result?.first?.spec_price ?? model?.shop_price
    }
    
    func updateChoose(indexPath: NSIndexPath, value: String) {
        
        let specs = model?.goods_spec[indexPath.row - 1].specs
        
        let result = specs?.filter{$0.item == value}
        
        current_choose[indexPath.row] = result?.first?.id
    }
    
    func clearChoose() {
        current_choose.removeAll()
    }
    
    func goods_category_name(indexPath: NSIndexPath) -> String? {
        return model?.goods_spec[indexPath.row - 1].name
    }
    
    func goods_properties(indexPath: NSIndexPath) -> [String]? {
        if let spec = model?.goods_spec {
            if indexPath.row > 0 && spec.count > indexPath.row - 1 {
                return model?.goods_spec[indexPath.row - 1].specs.flatMap({$0.item})
            }
        }
        return nil
    }
    
    func changeCollect(completion: ()->Void) {
        Alamofire.request(Router.CollectAction(token: user?.token ?? "", goods_id: model?.goods_id ?? "", collect_type: model?.collect_type ?? "")).responseJSON { [weak self] (response) in
            
            let com = {
                if self?.code == .Success {
                    if let collect = self?.model?.collect_type {
                        
                        if collect == "1" {
                            self?.model?.collect_type = "0"
                        }else {
                            self?.model?.collect_type = "1"
                        }
                        
                    }
                }
                completion()
            }
            
            self?.doSomething(response, completion: com)
        }
    }
    
    func getGoodsInfo(goodId: String, completion:()->Void) {
        
        let request = Alamofire.request(Router.GoodsDetail(token: user?.token ?? "", good_id: goodId)).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
        currentTask = request.task
    }
    
    func addToCart(goodId: String, goodsNum: Int, goodsSpec: [String], completion:()->Void) {
        let newGoodsSpec = goodsSpec.count > 1 ? goodsSpec.joinWithSeparator("_") : goodsSpec.first
        Alamofire.request(Router.AddToCart(token: user?.token ?? "", goods_id: goodId, goods_number: "\(goodsNum)", goods_spec: newGoodsSpec ?? "")).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
    }
    
    private func doSomething(response: Response<AnyObject, NSError>, completion: () -> Void) {
        
        if response.result.isSuccess {
            let value = JSON(response.result.value!)
            
            print(value)
            
            
            if let status = value["status"].int {
                self.code = StatusCode(rawValue: status) ?? .UnknownError
                self.msg = value["msgs"].stringValue
                
                if let dic = value["domains"].dictionaryObject {
                    self.model = DDGoodsDetailModel.instance(dic) as? DDGoodsDetailModel
                }
            }
        }else {
            self.code = .LinkError
            self.msg = "网络连接失败"
        }
        
        completion()
        currentTask = nil
    }
}
