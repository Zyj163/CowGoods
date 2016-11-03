//
//  DDCollectViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/7/25.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire

class DDCollectViewModel: DDVistorGoodsViewModel {

    override func getMore(pageSize: Int, completion: () -> Void) {
        currentPage += 1
        
        Alamofire.request(Router.CollectList(token: DDUserModel.loadAccount()?.token ?? "", current_page: "\(currentPage)", page_size: "\(pageSize)")).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
    }
    
    override func refresh(pageSize: Int, completion: () -> Void) {
        currentPage = 1
        
        Alamofire.request(Router.CollectList(token: DDUserModel.loadAccount()?.token ?? "", current_page: "\(currentPage)", page_size: "\(pageSize)")).responseJSON { [weak self] (response) in
            self?.doSomething(response, completion: completion)
        }
    }
    
}
