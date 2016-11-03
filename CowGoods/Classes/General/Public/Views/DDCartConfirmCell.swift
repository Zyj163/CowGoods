//
//  DDCartConfirmCell.swift
//  CowGoods
//
//  Created by ddn on 16/7/6.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDCartConfirmCell: DDCartGoodsCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        selectedBtn.removeFromSuperview()
        selectedBtn.snp_updateConstraints { (make) in
            make.width.equalTo(0)
            make.left.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
