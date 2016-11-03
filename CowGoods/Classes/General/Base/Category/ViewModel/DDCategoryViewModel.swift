//
//  DDCategoryViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/21.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DDCategoryViewModel: DDBaseViewModel {

    private var models = [DDCategoryModel]()
    
    var leftItemCount: Int {
        return models.count
    }
    
    private var selectedIndexPath: NSIndexPath?
    var currentIndexPath: NSIndexPath? {
        return selectedIndexPath
    }
    
    private func getSecondModel(indexPath: NSIndexPath) -> DDCategoryModel? {
        if let model = self[selectedIndexPath!], categories = model.categories {
            if indexPath.section < categories.count {
                return categories[indexPath.section]
            }
        }
        return nil
    }
    
    private func getThirdModel(indexPath: NSIndexPath) -> DDCategoryModel? {
        if let subCategories = getSecondModel(indexPath)?.categories {
            if indexPath.row < subCategories.count {
                return subCategories[indexPath.row]
            }
        }
        return nil
    }
    
    func rightCell_img(indexPath: NSIndexPath) -> NSURL? {
        return getThirdModel(indexPath)?.imageUrl
    }
    
    func rightCell_name(indexPath: NSIndexPath) -> String? {
        return getThirdModel(indexPath)?.mobile_name
    }
    
    func rightTitle(section: Int) -> String? {
        if let model = self[selectedIndexPath!], categories = model.categories {
            if section < categories.count {
                return categories[section].mobile_name
            }
        }
        return nil
    }
    
    var rightSectionCount: Int {
        if let indexPath = selectedIndexPath, model = self[indexPath] {
            return model.categories?.count ?? 0
        }
        return 0
    }
    
    func rightCellCount(section: Int) -> Int {
        if let indexPath = selectedIndexPath, model = self[indexPath], categories = model.categories {
            if section < categories.count {
                return categories[section].categories?.count ?? 0
            }
        }
        return 0
    }
    
    func setSelectedLeftIndexPath(indexPath: NSIndexPath, completion:() ->Void) {
        if let model = self[indexPath] {
            
            selectedIndexPath = indexPath
            
            if self[indexPath]?.categories?.count > 0 {
                completion()
                return
            }
            
            Alamofire.request(Router.CategoryList(cat_id: model.id!)).responseJSON { [weak self] (response) in
                if let models = self?.doSomething(response) {
                    model.categories = models
                }
                completion()
            }
        }else {
            completion()
        }
    }
    
    func setSelectedRightIndexPath(indexPath: NSIndexPath) -> UIViewController? {
        let model = getThirdModel(indexPath)
        
        let viewModel = DDVistorGoodsViewModel()
        viewModel.category_id = model?.id
        
        let vistorGoodsListVc = DDVistorGoodsListViewController(my_enum: MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: viewModel, v: UITableView(), cell: DDVistorGoodsCell.self, pageSize: 5))
        
        return vistorGoodsListVc
    }
    
    func leftTitle(indexPath: NSIndexPath) -> String? {
        return self[indexPath]?.mobile_name
    }
    
    func getCategoryList(cat_id: Int?, completion:() ->Void) {
        Alamofire.request(Router.CategoryList(cat_id: "\(cat_id)")).responseJSON { [weak self] (response) in
            if let models = self?.doSomething(response) {
                self?.models = models
            }
            completion()
        }
    }
    
    subscript(indexPath: NSIndexPath) -> DDCategoryModel? {
        if indexPath.row < models.count {
            return models[indexPath.row]
        }
        return nil
    }
    
    private func doSomething(response: Response<AnyObject, NSError>) -> [DDCategoryModel]? {
        
        if response.result.isSuccess {
            
            let value = JSON(response.result.value!)
            
            if let status = value["status"].int {
                code = StatusCode(rawValue: status) ?? .UnknownError
                msg = value["msgs"].stringValue
                
                if let arr = value["domains"].arrayObject {
                    return DDCategoryModel.instances(arr) as? [DDCategoryModel]
                }
            }
        }else {
            code = .LinkError
            msg = "网络连接失败"
        }
        
        return nil
    }
}
