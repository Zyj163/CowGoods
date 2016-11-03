//
//  DDBaseViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/15.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation

class DDBaseViewModel: NSObject, BaseViewModelProtocol {
    /// 网络请求状态码 －2为网络连接失败；－1为请求失败；0为请求成功
    var code: StatusCode = .LinkError
    /// 网络请求后返回的消息
    var msg: String = ""
    
    var currentTask: NSURLSessionTask?
}

















