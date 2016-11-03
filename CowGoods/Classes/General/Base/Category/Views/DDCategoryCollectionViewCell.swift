//
//  DDCategoryCollectionViewCell.swift
//  CowGoods
//
//  Created by ddn on 16/6/22.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import YYText

class DDCategoryCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView(image: UIImage(named: "category_placeholder"))
    
    let label = YYLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        label.font = 20.fitFont()
        label.textAlignment = .Center
        label.textColor = UIColor(hexString: "959595")
        label.displaysAsynchronously = true
        
        imageView.snp_updateConstraints { (make) in
            make.top.right.left.equalTo(0)
            make.height.equalTo(imageView.snp_width)
        }
        
        label.snp_updateConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.top.equalTo(imageView.snp_bottom).offset(10.fit())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func binding(indexPath: NSIndexPath, viewModel: DDCategoryViewModel) {
        
        if let url = viewModel.rightCell_img(indexPath) {
            imageView.yy_setImageWithURL(url, placeholder: UIImage(named: "category_placeholder"), options: .SetImageWithFadeAnimation, completion: nil)
        }
        
        label.text = viewModel.rightCell_name(indexPath)
    }
}
