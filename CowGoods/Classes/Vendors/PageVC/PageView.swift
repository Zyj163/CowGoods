//
//  PageView.swift
//  BestGoods
//
//  Created by zhangyongjun on 16/6/11.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class PageView: UIScrollView {
    
    private lazy var views = [Int : UIView]()
    
    var maxIdx = 0
    
    subscript(index: Int) -> UIView? {
        
        get {
            return views[index]
        }
        
        set {
            let view = views[index]
            if view == nil && newValue != nil {
                views[index] = newValue
                addSubview(newValue!)
            }
            if view != nil && newValue == nil {
                views[index] = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pagingEnabled = true
        bounces = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (index, subview) in views {
            maxIdx = index > maxIdx ? index : maxIdx
            
            let width = bounds.size.width
            let height = bounds.size.height
            subview.frame = CGRectMake(CGFloat(index) * width, 0, width, height - contentInset.top - contentInset.bottom)
        }
    }

}





















