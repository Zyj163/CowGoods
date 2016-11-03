//
//  RightImageButton.swift
//  微博
//
//  Created by zhangyongjun on 16/5/28.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class RightImageButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        if let _ = title {
            super.setTitle(title! + " ", forState: state)
        }else {
            super.setTitle(title, forState: state)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = CGRectGetWidth(titleLabel!.bounds)
    }
}
