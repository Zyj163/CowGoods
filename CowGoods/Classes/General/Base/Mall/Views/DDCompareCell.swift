//
//  DDCompareCell.swift
//  CowGoods
//
//  Created by ddn on 16/6/17.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDCompareCell: DDBaseTableViewCell {

    override func setup() {
        let viewModel = self.viewModel as! DDCompareViewModel
        
        if let imageStr = viewModel.original_img(indexPath!) {
            self.imageView?.yy_setImageWithURL(NSURL.init(string: imageStr), placeholder: UIImage(named: ""))
        }else {
            self.imageView?.image = UIImage(named: "")
        }
        
        if let title = viewModel.goods_name(indexPath!) {
            self.textLabel?.text = title
        }
    }

}
