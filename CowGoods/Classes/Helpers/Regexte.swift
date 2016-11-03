//
//  Regexte.swift
//  CowGoods
//
//  Created by ddn on 16/6/14.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation

class Regexte {
    
    /**判断是否为手机号*/
    class func isTelNumber(obj: AnyObject) -> Bool {
        
        let MOBILE = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        /// 移动
        let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        /// 联通
        let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        /// 电信
        let CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        /// 大陆地区固话及小灵通
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBILE)
        let regextestcm = NSPredicate(format:"SELF MATCHES %@", CM)
        let regextestcu = NSPredicate(format:"SELF MATCHES %@", CU)
        let regextestct = NSPredicate(format:"SELF MATCHES %@", CT)
        
        let res1 = regextestmobile.evaluateWithObject(obj)
        let res2 = regextestcm.evaluateWithObject(obj)
        let res3 = regextestcu.evaluateWithObject(obj)
        let res4 = regextestct.evaluateWithObject(obj)
        
        return (res1 || res2 || res3 || res4)
        
    }
    
    /**判断是否为邀请码*/
    class func isInviteNumber(obj: AnyObject) -> Bool {
        let Invite = "^[a-zA-Z0-9]{8}$"
        let regextest = NSPredicate(format: "SELF MATCHES %@", Invite)
        
        return regextest.evaluateWithObject(obj)
    }
    
    /**判断是否为验证码*/
    class func isAuthCodeNumber(obj: AnyObject) -> Bool {
        let AuthCode = "^[0-9]{4}$"
        let regextest = NSPredicate(format: "SELF MATCHES %@", AuthCode)
        
        return regextest.evaluateWithObject(obj)
    }
    
    
    /*
     ^ 匹配一行的开头位置
     (?![0-9]+$) 预测该位置后面不全是数字
     (?![a-zA-Z]+$) 预测该位置后面不全是字母
     [0-9A-Za-z] {6,10} 由6-10位数字或这字母组成
     $ 匹配行结尾位置
     */
    /**判断是否为密码*/
    class func isPasswordNumber(obj: AnyObject) -> Bool {
        let Password = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10}$"
        let regextest = NSPredicate(format: "SELF MATCHES %@", Password)
        
        return regextest.evaluateWithObject(obj)
    }
}

extension Regexte {
    class func hasSameElements(arr arr: [String], otherArr: [String]) -> Bool {
        if arr.count != otherArr.count || arr.count * otherArr.count == 0 {
            return false
        }
        
        let resultArr = arr.filter { (element) -> Bool in
            otherArr.contains(element)
        }
        
        return resultArr.count == arr.count
    }
}





















