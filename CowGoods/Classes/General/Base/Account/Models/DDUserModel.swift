//
//  DDUserModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/15.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDUserModel: DDBaseModel {
    
    /// 用户名
    var nickname : String? = ""
    /// 手机号
    var mobile : String? = ""
    /// 邀请码
    var code : String? = ""
    /// 用户头像
    var head_pic : String? = ""
    /// 用户唯一标示
    var token : String? = ""
    /// 性别
    var sex : String? = ""
    
    var card_a : String?
    
    var card_b : String?
    
    var temp_card_a : String?
    
    var temp_card_b : String?
    
    
    /**返回用户是否登录*/
    class func userLogin() -> Bool {
        return loadAccount() != nil
    }
    
    /**保存已登录用户*/
    class func saveAccount(userModel: DDUserModel) {
        CacheTool.remove(key: AccountCache)
        CacheTool.set(userModel, forKey: AccountCache)
    }
    
    /**退出登录*/
    class func clearAccount() {
        account = nil
        CacheTool.remove(key: AccountCache)
        
        NSNotificationCenter.defaultCenter().postNotificationName(DDLogoutNotify, object: nil)
    }
    
    /**获取已登录用户*/
    static var account: DDUserModel?
    class func loadAccount() -> DDUserModel? {
        
        if account != nil {
            return account
        }
        
        account = CacheTool.get(key: AccountCache) as? DDUserModel
        return account
    }
}
