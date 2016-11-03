//
//  Macro.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

/**************支付****************/
let WXPayNotification = "WeixinPayNotification"
let WXPayResultKey = "WXPayResultKey"

let WX_APPID = "wx000000000"
let WX_APP_SECRET = ""


let AppScheme:String = "niupingbuy"


let AlipayPartner:String = ""
let AlipaySeller:String = ""
let AlipayPrivateKey:String = "MIIE6TAbBgkqhkiG9w0BBQMwDgQI0+Xx8FpR9cCAggABIIEyDHolUmVPDkhykBYG79ZRVhsPzFGRob8wvNm+dZlq8uO3+W1uYSN3HNI7nmBNEq7MRX0lAggo/AO8jA0hMEy0quUJF/wHIQXVA46tDlHSkNy6FkJJkUxUDqzKNBh9zfqHDEsMMZw2txmEHIOTAnIdDHik+OgABNYSniRRslypPh7O48B34q3zckTn3LKzgKBow7FA4bCIk69cHUicxpEr4SXL0xcpIhP5ojkne+xTamw6mC3qEdZnGmazO+DNvAdCBT5K//5zwkdjBtmKSrGdU+1TVtK6Diin8kroDezqAbVbOL5Ml2vgu9Dv7C4/q0ZIkgIw9P9kTsaZFAZu/qwVc7gVxi8Q3bU8Z91w+ngOed72Diwbbas4PqhDy+4P/Kx2wijyCRPa57Nji9nU1p4ZHdrmb1/B/sYOrkqsX21HjAzoHDfcnVcQ5ZeOtfk9hPQ/5WOZt4vP8RVBd9Bv+19kJ8fg6boDh3OuVrGRbADUA3Prru/ZqR6I1Cqe7ZofwhesfD+5WdCMi6XqmdiE4+r5cCiSUp64Dk8Bpm5chhb6N8NeJHnP/BhwmFoQd3hEPjfcrqiGY8lSI+/t6AQ/oT9vU1BtTHWUsdo1WzRlAQZ3wtcU2XehLjm46X8JoidRpY4BUrOEJwMYeM9I+3mGdXsOHdk1PY+e1n+y+0xFpMXyoaqwCcVFUJ4ybBz8kOFFvp0pWiyBZdTwTYdsaj2NkEn2oItWlZbP8BZu/J62Ka/A07GXWzpauKUOONwpfWnv/jJocONekrTHbpwfyrhO1bo+kSrNwe4gp7hxTxYLbNBeCc8GJuF0ZB1NtQFPVlEmFysVBjY9b2cZsrKkJ1W0zFpHyBo1unKHp6isAg/bS/rvU8WEM/X6gLzx3JLox8zifDdqcH7M1ruk0kqlkHGtPCpUy0WlSe2Bg5Kf5CGr+fNHVd00FUjtoE49EYnwP6qNpNwB94PO5S4ARRh8gve9TS0Y2NGlolGw1mix+biQOnJZf6yOhycLqY6Mm0vWjVFJQGP+ZCGHofrrU2iGwejLJfBqvkH8ANAZgDj37Gv1ZdXS22xdzq5voc31Njw1kt1AAPQA7kgqTmjZ1R+ULHbp/t8ctQF9RYg2PF8cZ0GoXi0mBu9DWkAR5nbWcyQsJu9YW0/J1TlQ317ahVjFMn/eFkux2ulmt+PKeu20ue13Bph8OLrkGp1kOeRJbks8E1E/gvM/nlVB0qMaJyjWL/c3E7echqP8DOtrIeFTCkirmjd+H7KKEFYZqoUrdNaxTM5hb0CthEYWLNDFwepO3/7VhpMtxCe79eX44HKxhRK8XDTMqqce10LgbuECXKLc5ELNWNwbeGmLHL3zvLJOvGuPTRQsiKo2qLfdoWjMurzol+VXUYRuqpu5op8osSWsR//ZD4f5GIryWtKYIMT4wQgW2zl4BW1GK+hykUEcolfAVmHoR9ZIhkE0ID5zJxBUH8D0jokgP7j/A/vwXz1Xa5RUElVeAEh0wPxzsLLzllOVjOIh+GP2nKHJ4tCzXRtYRkBhqyZ2wMW1BSeaoQZFu8+wp2UvjiKy+42C72zU6mS/TjvjRS7W/dSV802tp4KCE93S/NpU6cA6zBWRKH3EeikilzsGg8XgsS1ghwjtw=="

let AlipayNotifyURL:String = "http://www.yourdomain.com/order/alipay_notify_app"

let ServerURL = baseUrl
/**************支付****************/


let BadgeValueDefaultKey = "BadgeValueDefaultKey"

let devBase = "http://shop.yyox.com"
let productBase = "http://www.niupinbuy.com"

let baseUrl = devBase

/// 切换控制起通知
let DDSwitchRootViewControllerNotify = "DDSwitchRootViewControllerNotify"
/// 推出登录通知（清除用户信息与数据）
let DDLogoutNotify = "DDLogoutNotify"

/// 随机数
var random: CGFloat {
    return CGFloat(arc4random_uniform(256))
}

/// 判断设备型号
var iPhone4 : Bool {
    return UIScreen.instancesRespondToSelector(Selector("currentMode")) ? CGSizeEqualToSize(CGSizeMake(640, 960), (UIScreen.mainScreen().currentMode?.size)!) : false
}
var iPhone5 : Bool {
    return UIScreen.instancesRespondToSelector(Selector("currentMode")) ? CGSizeEqualToSize(CGSizeMake(640, 1136), (UIScreen.mainScreen().currentMode?.size)!) : false
}
var iPhone6 : Bool {
    return UIScreen.instancesRespondToSelector(Selector("currentMode")) ? CGSizeEqualToSize(CGSizeMake(750, 1334), (UIScreen.mainScreen().currentMode?.size)!) : false
}
var iPhone6p : Bool {
    return UIScreen.instancesRespondToSelector(Selector("currentMode")) ? CGSizeEqualToSize(CGSizeMake(1242, 2208), (UIScreen.mainScreen().currentMode?.size)!) : false
}

/**随机色*/
func randomColor() -> UIColor {
    return UIColor(red: random/255.0, green: random/255.0, blue: random/255.0, alpha: 1)
}

/// NSNotificationCenter
var NSDC : NSNotificationCenter {
    return NSNotificationCenter.defaultCenter()
}
/// NSUserDefaults
var NSUD : NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
}
/// NSFileManager
var NSFM : NSFileManager {
    return NSFileManager.defaultManager()
}

/// 状态栏高度
var StatusBarHeight : CGFloat {
    return 20
}

/// 导航栏高度
var NavBarHeight : CGFloat {
    return 44
}

var NetVisable: Bool {
    get {
        return UIApplication.sharedApplication().networkActivityIndicatorVisible
    }
    set {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = newValue
    }
}

/// 工具栏高度
var TabBarHeight : CGFloat {
    return 49
}

var ScreenScale : CGFloat {
    return UIScreen.mainScreen().scale
}

var ScreenWidth : CGFloat {
    return UIScreen.mainScreen().bounds.size.width
}

var ScreenHeight : CGFloat {
    return UIScreen.mainScreen().bounds.size.height
}

func classFromString(className: String) -> AnyClass? {
    let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
    
    if let cls:AnyClass = NSClassFromString(ns + "." + className) {
        
        return cls
    }
    return nil
}

func showIndicatorView(inView view: UIView) {
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    view.addSubview(indicator)
    indicator.hidesWhenStopped = true
    indicator.snp_makeConstraints(closure: { (make) in
        make.center.equalTo(0)
    })
    indicator.startAnimating()
}

func hideIndicatorView(fromView view: UIView) {
    let indicators = view.subviews.filter {$0 is UIActivityIndicatorView}
    if let indicator = indicators.first {
        indicator.removeFromSuperview()
    }
}

func fixCellSeperator(cell: UITableViewCell) {
    cell.separatorInset = UIEdgeInsetsZero
    cell.layoutMargins = UIEdgeInsetsZero
    cell.preservesSuperviewLayoutMargins = false
}












