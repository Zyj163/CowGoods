//
//  DDBuyChooseFirstTableViewCell.swift
//  CowGoods
//
//  Created by ddn on 16/6/30.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDBuyChooseFirstTableViewCell: UITableViewCell {

    let priceLabel = UILabel()
    
    let storeCountLabel = UILabel()
    
    let desLabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(priceLabel)
        contentView.addSubview(storeCountLabel)
        contentView.addSubview(desLabel)
        
        setup()
    }
    
    private func setup() {
        priceLabel.font = 30.fitFont()
        priceLabel.textColor = UIColor.redColor()
        priceLabel.text = "0"
        
        storeCountLabel.font = 24.fitFont()
        storeCountLabel.text = "库存0件"
        
        desLabel.font = storeCountLabel.font
        desLabel.text = "请选择"
        
        priceLabel.snp_makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(120)
        }
        
        storeCountLabel.snp_makeConstraints { (make) in
            make.left.equalTo(priceLabel)
            make.top.equalTo(priceLabel.snp_bottom).offset(8)
        }

        desLabel.snp_makeConstraints { (make) in
            make.left.equalTo(priceLabel)
            make.top.equalTo(storeCountLabel.snp_bottom).offset(3)
            make.bottom.equalTo(-15)
        }
    }
    
    func binding(viewModel: DDGoodsDetailViewModel, properties: [String]) {
        let count = viewModel.goods_store(properties)
        storeCountLabel.text = "库存" + (count ?? "0") + "件"
        let price = viewModel.goods_price(properties)
        priceLabel.text = "¥ " + (price ?? "0")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
}
