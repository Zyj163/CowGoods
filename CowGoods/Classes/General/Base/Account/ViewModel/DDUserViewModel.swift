//
//  DDUserViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/20.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DDUserViewModel: DDBaseViewModel {
    
    /**登录*/
    func login(URLRequest: URLRequestConvertible, completion: () -> Void) {
        
        Alamofire.request(URLRequest).responseJSON(completionHandler: { [weak self] (response) in
            
            self?.doSomething(response, completion: completion)
            })
    }
    
    /**获取动态密码*/
    func getDynamicPassword(URLRequest: URLRequestConvertible, completion: () -> Void) {
        
        Alamofire.request(URLRequest).responseJSON(completionHandler: { [weak self] (response) in
            
            self?.doSomething(response, completion: completion)
            })
    }
    
    /**注册*/
    func register(URLRequest: URLRequestConvertible, completion: () -> Void) {
        
        Alamofire.request(URLRequest).responseJSON(completionHandler: { [weak self] (response) in
            
            self?.doSomething(response, completion: completion)
            })
    }
    
    /**获取验证码*/
    func getAuthcode(URLRequest: URLRequestConvertible, completion: () -> Void) {
        
        Alamofire.request(URLRequest).responseJSON(completionHandler: { [weak self] (response) in
            
            self?.doSomething(response, completion: completion)
            })
    }
    
    private func doSomething(response: Response<AnyObject, NSError>, completion: () -> Void) {
        
        if response.result.isSuccess {
            let value = JSON(response.result.value!)
            if let status = value["status"].int {
                self.code = StatusCode(rawValue: status) ?? .UnknownError
                self.msg = value["msgs"].stringValue
                
                if let dic = value["domains"].dictionaryObject {
                    let model = DDUserModel.instance(dic) as! DDUserModel
                    DDUserModel.saveAccount(model)
                }
            }
        }else {
            self.code = .LinkError
            self.msg = "网络连接失败"
        }
        
        completion()
    }
}
