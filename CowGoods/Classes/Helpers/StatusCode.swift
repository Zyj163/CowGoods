//
//  StatusCode.swift
//  CowGoods
//
//  Created by ddn on 16/6/22.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation

enum StatusCode: Int {
    case LinkError = -2
    case OrderError = -1
    case Success = 0
    case NotLogin = 40001
    case NoProperty = 40012
    case UnknownError
}
