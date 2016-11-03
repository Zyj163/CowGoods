//
//  DDAuthViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/20.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class DDAuthViewModel: DDBaseViewModel {
    
    var canMakeAuth: Bool {
        if let user = DDUserModel.loadAccount() {
            dump(user)
            if (user.temp_card_a != nil) {
                if (user.temp_card_b != nil)  {
                    return true
                }
            }
        }
        return false
    }
    
    func uploadCard(image: UIImage, front: Bool, completion: () ->Void) {
        
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            
            Alamofire.upload(Router.UploadCard(), data: imageData).responseJSON(completionHandler: { (response) in
                self.doSomethingAfterUpload(front, response: response, completion: completion)
            })
        }
    }
    
    private func doSomethingAfterUpload(front: Bool, response: Response<AnyObject, NSError>, completion: () -> Void) {
        
        if response.result.isSuccess {
            let value = JSON(response.result.value!)
            if let status = value["status"].int {
                code = StatusCode(rawValue: status) ?? .UnknownError
                msg = value["msgs"].stringValue
                
                if let card : JSON = value["domains"] {
                    if let user = DDUserModel.loadAccount() {
                        if front {
                            user.temp_card_a = card["relative_url"].string
                            user.card_a = card["absolute_url"].string
                        }else {
                            user.temp_card_b = card["relative_url"].string
                            user.card_b = card["absolute_url"].string
                        }
                    }
                }
            }
        }
        else {
            code = .LinkError
            msg = "网络连接失败"
        }
        
        completion()
    }
    
    func makeAuth(name name: String, National_ID: String, completion: () ->Void) {
        if canMakeAuth {
            let user = DDUserModel.loadAccount()
            Alamofire.request(Router.MakeAuth(token: (user?.token)!, name: name, National_ID: National_ID, card_a: (user?.temp_card_a)!, card_b: (user?.temp_card_b)!)).responseJSON(completionHandler: { (response) in
                print(response)
                self.doSomething(response, completion: completion)
                
            })
        }else {
            code = .NotLogin
            msg = "没有验证资格"
            completion()
        }
    }
    
    private func doSomething(response: Response<AnyObject, NSError>, completion: () -> Void) {
        
        if response.result.isSuccess {
            let value = JSON(response.result.value!)
            if let status = value["status"].int {
                self.code = StatusCode(rawValue: status) ?? .UnknownError
                self.msg = value["msgs"].stringValue
            }
        }else {
            self.code = .LinkError
            self.msg = "网络连接失败"
        }
        
        completion()
    }
    
    deinit {
        clearCache()
    }
    
    func clearCache() {
        let user = DDUserModel.loadAccount()
        user?.temp_card_b = nil
        user?.temp_card_a = nil
    }
}







