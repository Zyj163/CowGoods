//
//  DDBuyChooseCountCell.swift
//  CowGoods
//
//  Created by ddn on 16/7/1.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDBuyChooseCountCell: UITableViewCell {

    private var desLabel: UILabel = UILabel()
    
    private var numView: UIView = UIView()
    
    private var numLabel: UILabel = UILabel()
    
    private var deBtn: UIButton = UIButton()
    
    private var inBtn: UIButton = UIButton()
    
    var maxNum: Int = 1
    
    var num: Int = 1 {
        didSet {
            numLabel.text = "  " + "\(num)" + "  "
            deBtn.enabled = num != 1
            inBtn.enabled = num < maxNum
            if let chooseHanlder = chooseHanlder {
                chooseHanlder(count: num)
            }
        }
    }
    
    var chooseCount : Int {
        return num
    }
    
    var chooseHanlder: ((count: Int)->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(desLabel)
        contentView.addSubview(numView)
        
        numView.addSubview(deBtn)
        numView.addSubview(numLabel)
        numView.addSubview(inBtn)
        
        desLabel.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(0)
        }
        
        numView.snp_makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        deBtn.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
        }
        
        numLabel.snp_makeConstraints { (make) in
            make.left.equalTo(deBtn.snp_right).offset(1)
            make.top.bottom.equalTo(0)
        }
        
        inBtn.snp_makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.left.equalTo(numLabel.snp_right).offset(1)
        }
        
        desLabel.text = "购买数量"
        numLabel.text = "  0  "
        numLabel.textColor = UIColor(hexString: "333333")
        numLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        deBtn.setBackgroundImage(UIImage(named: "number_disable"), forState: .Disabled)
        deBtn.setBackgroundImage(UIImage(named: "number_enable")?.imageByRotate180(), forState: .Normal)
        deBtn.setTitle("-", forState: .Normal)
        deBtn.titleLabel?.font = 40.fitFont()
        deBtn.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        deBtn.addTarget(self, action: #selector(clickOnDe(_:)), forControlEvents: .TouchUpInside)
        deBtn.enabled = false
        
        inBtn.setBackgroundImage(UIImage(named: "number_enable"), forState: .Normal)
        inBtn.setBackgroundImage(UIImage(named: "number_disable"), forState: .Disabled)
        inBtn.setTitle("+", forState: .Normal)
        inBtn.titleLabel?.font = 40.fitFont()
        inBtn.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        inBtn.addTarget(self, action: #selector(clickOnIn(_:)), forControlEvents: .TouchUpInside)
    }
    
    func clickOnDe(btn: UIButton) {
        num -= 1
    }
    
    func clickOnIn(btn: UIButton) {
        num += 1
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }

}
