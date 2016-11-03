//
//  DDVistorGoodsCell.swift
//  CowGoods
//
//  Created by ddn on 16/7/1.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import YYText

class DDVistorGoodsCell: DDBaseTableViewCell {

    var leftImageView = UIImageView(image: UIImage(named: "category_placeholder"))
    
    var titleLabel = UILabel()
    
    var desLabel = UILabel()
    
    var current_priceLabel = UILabel()
    
    var original_priceLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftImageView)
        leftImageView.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(5)
            make.bottom.equalTo(-8)
            make.width.equalTo(leftImageView.snp_height)
        }
        leftImageView.layer.cornerRadius = 5
        leftImageView.layer.borderColor = UIColor.grayColor().CGColor
        leftImageView.layer.borderWidth = 0.5
        
        contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(leftImageView.snp_right).offset(10)
            make.right.equalTo(-20)
        }
        titleLabel.numberOfLines = 2
        titleLabel.font = 24.fitFont()
        titleLabel.text = " "
        
        contentView.addSubview(desLabel)
        desLabel.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        desLabel.numberOfLines = 1
        desLabel.font = 20.fitFont()
        desLabel.text = "产品规格：无"
        
        contentView.addSubview(current_priceLabel)
        current_priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel).offset(2)
            make.top.equalTo(desLabel.snp_bottom).offset(18)
            make.bottom.equalTo(-10)
        }
        current_priceLabel.font = 24.fitFont()
        current_priceLabel.textColor = UIColor.redColor()
        
        contentView.addSubview(original_priceLabel)
        original_priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(current_priceLabel.snp_right).offset(10)
            make.centerY.equalTo(current_priceLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        let viewModel = self.viewModel as! DDVistorGoodsViewModel
        
        if let imageStr = viewModel.original_img(indexPath!) {
            leftImageView.yy_setImageWithURL(NSURL.init(string: imageStr), placeholder: UIImage(named: "category_placeholder"))
        }else {
            leftImageView.image = UIImage(named: "category_placeholder")
        }
        
        titleLabel.text = (viewModel.goods_name(indexPath!) ?? "")
        
        if let current_price = viewModel.goods_current_price(indexPath!) where !current_price.isEmpty {
            current_priceLabel.text = "¥" + current_price
        }else {
            current_priceLabel.text = nil
        }
        
        if let original_price = viewModel.goods_market_price(indexPath!) where !original_price.isEmpty {
            let str = "¥" + original_price
            let attStr = NSAttributedString(string: str, attributes: [NSFontAttributeName : 24.fitFont(), NSForegroundColorAttributeName : UIColor.grayColor(), NSStrikethroughStyleAttributeName : 1])
            
            original_priceLabel.attributedText = attStr
        }else {
            original_priceLabel.attributedText = nil
        }
    }
    
}
