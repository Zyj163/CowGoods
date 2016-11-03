//
//  DDShareViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/6/30.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDShareViewModel: NSObject {

    private var titles: [String] = ["微信好友", "微信朋友圈", "新浪微博", "QQ好友", "QQ空间", "复制链接"]
    
    private var imageNames: [String] = ["weixinhaoyou", "pengyouquan", "weibo", "qq", "kongjian", "lianjie"]
    
    var itemCount : Int {
        return titles.count
    }
    
    func title(indexPath indexPath: NSIndexPath) -> String? {
        if indexPath.row < titles.count {
            return titles[indexPath.row]
        }
        return nil
    }
    
    func imageName(indexPath indexPath: NSIndexPath) -> String? {
        if indexPath.row < imageNames.count {
            return imageNames[indexPath.row]
        }
        return nil
    }
    
}
