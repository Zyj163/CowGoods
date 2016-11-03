//
//  DDCartGoodsCell.swift
//  CowGoods
//
//  Created by ddn on 16/7/5.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDCartGoodsCell: DDBaseTableViewCell {

    let selectedBtn = UIButton()
    
    private let leftImageView = UIImageView()
    
    private let titleLabel = UILabel()
    
    private let current_priceLabel = UILabel()
    
    private let original_priceLabel = UILabel()
    
    private let countLabel = UILabel()
    
    var takeOrNotHanlder: ((selected: Bool, indexPath: NSIndexPath)->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        contentView.addSubview(selectedBtn)
        selectedBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(0)
            make.left.equalTo(8)
            make.width.equalTo(20)
            make.height.equalTo(selectedBtn.snp_width)
        }
        selectedBtn.setImage(UIImage(named: ""), forState: .Normal)
        selectedBtn.setImage(UIImage(named: ""), forState: .Selected)
        selectedBtn.addTarget(self, action: #selector(takeOrNot(_:)), forControlEvents: .TouchUpInside)
        selectedBtn.backgroundColor = UIColor.redColor()
        selectedBtn.selected = false
        
        contentView.addSubview(leftImageView)
        leftImageView.snp_makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(selectedBtn.snp_right).offset(8)
            make.bottom.equalTo(-5)
            make.width.equalTo(leftImageView.snp_height)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(leftImageView.snp_right).offset(10)
            make.right.equalTo(-10)
        }
        titleLabel.font = 22.fitFont()
        titleLabel.textColor = UIColor.grayColor()
        titleLabel.numberOfLines = 2
        
        contentView.addSubview(current_priceLabel)
        current_priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_left)
            make.bottom.equalTo(-12)
        }
        current_priceLabel.textColor = UIColor.orangeColor()
        current_priceLabel.font = 24.fitFont()
        
        contentView.addSubview(original_priceLabel)
        original_priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(current_priceLabel.snp_right).offset(8)
            make.centerY.equalTo(current_priceLabel)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp_makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalTo(current_priceLabel)
        }
        countLabel.font = 24.fitFont()
        countLabel.textColor = UIColor.grayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {}
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {}
    
    override func setup() {
        let viewModel = self.viewModel as! DDCartViewModel
        
        if let imageStr = viewModel.original_img(indexPath!) {
            leftImageView.yy_setImageWithURL(NSURL.init(string: imageStr), placeholder: UIImage(named: "category_placeholder"))
        }else {
            leftImageView.image = UIImage(named: "category_placeholder")
        }
        
        titleLabel.text = (viewModel.goods_name(indexPath!) ?? "")
        
        current_priceLabel.text = "¥" + (viewModel.goods_current_price(indexPath!) ?? "")
        
        let str = "¥" + (viewModel.goods_market_price(indexPath!) ?? "")
        let attStr = NSAttributedString(string: str, attributes: [NSFontAttributeName : 24.fitFont(), NSForegroundColorAttributeName : UIColor.grayColor(), NSStrikethroughStyleAttributeName : 1])
        original_priceLabel.attributedText = attStr
        
        countLabel.text = "x" + "\(viewModel.goods_count(indexPath!))"
        
        selectedBtn.selected = viewModel.getTakenModel(indexPath!) == nil ? false : true
        selectedBtn.backgroundColor = selectedBtn.selected ? UIColor.redColor() : UIColor.greenColor()
    }
    
    func takeOrNot(btn: UIButton) {
        selectedBtn.selected = !selectedBtn.selected
        
        selectedBtn.backgroundColor = selectedBtn.selected ? UIColor.redColor() : UIColor.greenColor()
        
        if let hanlder = takeOrNotHanlder, indexPath = indexPath {
            hanlder(selected: btn.selected, indexPath: indexPath)
        }
    }
}
