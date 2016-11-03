//
//  DDCartViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/7/5.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire

class DDCartViewModel: DDBaseMoreDataViewModel {
    
    var user: DDUserModel? {
        return DDUserModel.loadAccount()
    }
    
    var allTaken: Bool {
        if let takenModels = getTakenModels() {
            return takenModels.count == models.count
        }
        return false
    }
    
    var noneTaken: Bool {
        return getTakenModels() == nil || getTakenModels()!.isEmpty
    }
    
    override var modelClass: DDBaseModel.Type {
        return DDCartGoodsModel.self
    }
    
    func original_img(indexPath: NSIndexPath) -> String? {
        if let model = self[indexPath] as? DDCartGoodsModel {
            return model.original_img
        }
        return nil
    }
    
    func goods_name(indexPath: NSIndexPath) -> String? {
        if let model = self[indexPath] as? DDCartGoodsModel {
            return model.goods_name
        }
        return nil
    }
    
    func goods_current_price(indexPath: NSIndexPath) -> String? {
        if let model = self[indexPath] as? DDCartGoodsModel {
            return model.shop_price
        }
        return nil
    }
    
    func goods_market_price(indexPath: NSIndexPath) -> String? {
        if let model = self[indexPath] as? DDCartGoodsModel {
            return model.market_price
        }
        return nil
    }
    
    func goods_id(indexPath: NSIndexPath) -> String? {
        if let model = self[indexPath] as? DDCartGoodsModel {
            return model.goods_id
        }
        return nil
    }
    
    func goods_count(indexPath: NSIndexPath) -> Int {
        if let model = self[indexPath] as? DDCartGoodsModel {
            return model.goods_num
        }
        return 0
    }
    
    override func rowHeight(indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func changeStatus(selected: Bool, indexPath: NSIndexPath?) {
        if indexPath == nil {
            models.forEach({ (model) in
                let model = model as! DDCartGoodsModel
                model.taken = selected
            })
        }else if let model = self[indexPath!] as? DDCartGoodsModel {
            model.taken = selected
        }
    }
    
    func getTotalPrice() -> Double {
        let selectedModels = getTakenModels()
        if selectedModels == nil || selectedModels!.isEmpty {
            return 0
        }
        return selectedModels!.reduce(0.0) { (result, model) -> Double in
            return (Double(model.shop_price ?? "0")!) * Double(model.goods_num) + result
        }
    }
    
    func getTakenModels() -> [DDCartGoodsModel]? {
        return models.filter { (model) -> Bool in
            let model = model as! DDCartGoodsModel
            return model.taken
        } as? [DDCartGoodsModel]
    }
    
    func getTakenModel(indexPath: NSIndexPath) -> DDCartGoodsModel? {
        if let model = self[indexPath] as? DDCartGoodsModel {
            return model.taken ? model : nil
        }
        return nil
    }
    
    override func getMore(pageSize: Int, completion: () -> Void) {
        currentPage += 1
        
        Alamofire.request(Router.CartList(token: user?.token ?? "", current_page: "\(currentPage)", page_size: "\(pageSize)")).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
    }
    
    override func refresh(pageSize: Int, completion: () -> Void) {
        currentPage = 1
        
        Alamofire.request(Router.CartList(token: user?.token ?? "", current_page: "\(currentPage)", page_size: "\(pageSize)")).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
    }
    
    func toNext(indexPath: NSIndexPath) -> UIViewController? {
        let vc = DDGoodsDetailViewController()
        vc.goodId = goods_id(indexPath)
        return vc
    }
    
    func confirm() ->UIViewController {
        
        let confirmVc = DDCartConfirmViewController()
        
        confirmVc.my_enum = MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: self, v: UITableView(), cell: DDCartConfirmCell.self, pageSize: 20)
        
        return confirmVc
    }

}
