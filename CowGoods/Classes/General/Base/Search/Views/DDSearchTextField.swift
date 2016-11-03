//
//  DDSearchTextField.swift
//  CowGoods
//
//  Created by ddn on 16/6/28.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDSearchTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        background = UIImage(named: "searchTextField")
        
        let leftView = UIView()
        let iconView = UIImageView(image: UIImage(named: "search_icon"))
        leftView.addSubview(iconView)
        iconView.origin.x = 5
        leftView.size = CGSize(width: iconView.width + 10, height: iconView.height)
        
        self.leftView = leftView
        leftViewMode = .Always
        placeholder = "搜索需要的商品名称/品牌"
        font = 22.fitFont()
        tintColor = UIColor.grayColor()
        returnKeyType = .Done
        clearButtonMode = .WhileEditing
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class DDSearchItem: UIBarButtonItem {
    
    class func item(target: AnyObject?, action: Selector) -> DDSearchItem {
        let searchBtn = UIButton()
        searchBtn.setBackgroundImage(UIImage(named:"search_btn"), forState: .Normal)
        searchBtn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        searchBtn.setTitle("搜 索", forState: .Normal)
        searchBtn.titleLabel?.font = 26.fitFont()
        searchBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        searchBtn.sizeToFit()
        return DDSearchItem(customView: searchBtn)
    }
}

extension UIButton {
    
    class func button(target: AnyObject?, action: Selector) -> UIButton {
        let searchBtn = UIButton()
        searchBtn.setBackgroundImage(UIImage(named:"search_btn"), forState: .Normal)
        searchBtn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        searchBtn.setTitle("搜 索", forState: .Normal)
        searchBtn.titleLabel?.font = 26.fitFont()
        searchBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        searchBtn.sizeToFit()
        return searchBtn
    }
    
}
