//
//  DDBaseMoreDataViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/17.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DDBaseMoreDataViewModel: DDBaseViewModel, BaseDataViewModelProtocol, BaseMoreDataViewModelProtocol {
    
    /// 模型
    var models = [DDBaseModel]()
    /// 行数
    var rowCount: Int {
        return models.count
    }
    /// 区数
    var sectionCount: Int {
        return 1
    }
    /// 当前页码
    var currentPage: Int = 0
    /// 最大页数
    var maxPage: Int = 0
    /// 是否有更多数据
    var hasMore: Bool {
        return maxPage > currentPage
    }
    
    /// 新增加的个数
    var addCount = 0
    
    /// 模型的类型
    var modelClass : DDBaseModel.Type {
        return DDBaseModel.self
    }
    
    func rowHeight(indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    /**
     根据角标获取模型
     
     - parameter indexPath: indexPath
     
     - returns: 模型
     */
    subscript(indexPath: NSIndexPath) -> DDBaseModel? {
        get {
            if models.count > indexPath.row {
                let model = models[indexPath.row]
                return model
            }
            return nil
        }
    }
    
    func getMore(pageSize: Int, completion: () -> Void) {
        
    }
    
    func refresh(pageSize: Int, completion: () -> Void) {
        
    }
    
    /**
     收到网络响应后做的事情
     
     - parameter response:   响应对象
     - parameter completion: 外部回调
     */
    func doSomething(response: Response<AnyObject, NSError>, completion: () -> Void) {
        
        addCount = 0
        
        if response.result.isSuccess {
            
            let value = JSON(response.result.value!)
            
            print(value)
            
            if let status = value["status"].int {
                code = StatusCode(rawValue: status) ?? .UnknownError
                msg = value["msgs"].stringValue
                maxPage = value["others", "totalPages"].intValue
                
                if let arr = value["domains"].arrayObject {
                    let models = modelClass.instances(arr)
                    addCount = models.count
                    if currentPage == 1 {
                        self.models = models
                    }else {
                        self.models += models
                    }
                }
            }
        }else {
            code = .LinkError
            msg = "网络连接失败"
        }
        
        completion()
    }
}
