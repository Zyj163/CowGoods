//
//  DDHeaderReusableView.swift
//  CowGoods
//
//  Created by ddn on 16/6/27.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDHeaderReusableView: UICollectionReusableView {
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hexString: "eeeeee")
        addSubview(label)
        label.font = 24.fitFont()
        label.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func binding(indexPath: NSIndexPath, viewModel: DDCategoryViewModel) {
        label.text = viewModel.rightTitle(indexPath.section)
    }
}
