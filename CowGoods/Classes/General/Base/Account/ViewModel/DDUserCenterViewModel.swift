//
//  DDUserCenterViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/24.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDUserCenterViewModel: DDBaseViewModel {
    
    
    private let imageNames: [[String]] = [["cart", "favor", "collect", "store", "client", "wallet"], ["callme", "feedback", "problem"]]
    private let titles: [[String]] = [["购物车", "喜欢视频", "我的收藏", "我的库存", "客户管理", "我的金库"], ["联系客服", "意见反馈", "常见问题"]]
    
    
    var sectionCount: Int {
        return imageNames.count
    }
    
    var userLogin: Bool {
        return DDUserModel.userLogin()
    }
    
    func userIcon() -> NSURL? {
        if let urlStr = DDUserModel.loadAccount()?.head_pic {
            return NSURL(string: urlStr)
        }
        return nil
    }
    
    func userName() -> String? {
        return DDUserModel.loadAccount()?.nickname
    }
    
    func image(indexPath: NSIndexPath) -> String? {
        
        if !chargeAble(indexPath) {
            return nil
        }
        
        return imageNames[indexPath.section][indexPath.row]
    }
    
    func title(indexPath: NSIndexPath) -> String? {
        if !chargeAble(indexPath) {
            return nil
        }
        
        return titles[indexPath.section][indexPath.row]
    }
    
    func rowCount(section: Int) -> Int {
        if section > 1 {
            return 0
        }
        return imageNames[section].count
    }
    
    func selectToNext(indexPath: NSIndexPath) -> (UIViewController, Bool)? {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return (DDCartViewController(), true)
            case 1:
                return nil
            case 2:
                
                let viewModel = DDCollectViewModel()
                
                let collectListVc = DDCollectViewController(my_enum: MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: viewModel, v: UITableView(), cell: DDVistorGoodsCell.self, pageSize: 5))
                
                return (collectListVc, true)
            case 3:
                return nil
            case 4:
                return nil
            case 5:
                return nil
            default:
                return nil
            }
        case 1:
            switch indexPath.row {
            case 0:
                return nil
            case 1:
                return (DDFeedbackViewController(), false)
            case 2:
                return nil
            default:
                return nil
            }
        default:
            break
        }
        return nil
    }
    
    func chargeAble(indexPath: NSIndexPath) -> Bool {
        if indexPath.section > sectionCount {
            return false
        }
        
        if indexPath.section == 0 {
            if indexPath.row >= rowCount(0) {
                return false
            }
            return true
        }else {
            if indexPath.row >=  3 {
                return false
            }
            return true
        }
    }
}









