//
//  DDUserCenterCell.swift
//  CowGoods
//
//  Created by ddn on 16/6/24.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDUserCenterCell: UITableViewCell {

    let iconView: UIImageView = UIImageView()
    
    let titleLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        iconView.contentMode = .Center
        titleLabel.font = 30.fitFont()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func binding(icon: UIImage, title: String, indicator: Bool) {
        iconView.image = icon
        titleLabel.text = title
        self.accessoryType = indicator ? .DisclosureIndicator : .None
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        
        iconView.snp_updateConstraints { (make) in
            make.left.equalTo(35.0.fit())
            make.top.equalTo(20.fit())
            make.bottom.equalTo(-20.fit())
        }
        
        titleLabel.snp_updateConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp_right).offset(20.fit())
        }
        
        super.updateConstraints()
        
    }

}
