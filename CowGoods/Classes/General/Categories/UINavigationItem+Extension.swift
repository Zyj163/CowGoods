//
//  UINavigationItem+Extension.swift
//  CowGoods
//
//  Created by ddn on 16/6/24.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation

extension UINavigationItem {
    func setFixedRightItem(item: UIBarButtonItem) {
        let sepe = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        sepe.width = -20.fit()
        setRightBarButtonItems([sepe, item], animated: false)
    }
    
    func setFixedRightItems(items: [UIBarButtonItem]) {
        let sepe = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        sepe.width = -20.fit()
        setRightBarButtonItems([sepe] + items, animated: false)
    }
    
    func setFixedLeftItem(item: UIBarButtonItem) {
        let sepe = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        sepe.width = -20.fit()
        setLeftBarButtonItems([item, sepe], animated: false)
    }
    
    func setFixedLeftItems(items: [UIBarButtonItem]) {
        let sepe = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        sepe.width = -20.fit()
        setLeftBarButtonItems(items + [sepe], animated: false)
    }
}