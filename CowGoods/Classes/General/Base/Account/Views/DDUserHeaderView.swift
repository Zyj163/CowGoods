//
//  DDUserHeaderView.swift
//  CowGoods
//
//  Created by ddn on 16/6/24.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDUserHeaderView: UIView {

    let iconView: UIImageView = {
        let iconView = UIImageView(image: UIImage(named: "icon_holderPlace"))
        return iconView
    }()
    
    let titleLabel = UILabel()
    
    let lineView = UIView()
    
    var clickCallback : (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(lineView)
        lineView.backgroundColor = UIColor.lightGrayColor()
        titleLabel.font = 36.fitFont()
        
        addGestureRecognizer(UITapGestureRecognizer(actionBlock: {[weak self] _ in
            if let callback = self?.clickCallback {
                callback()
            }
        }))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func binding(icon: NSURL?, title: String?) {
        
        let size = iconView.size
        
        iconView.yy_setImageWithURL(icon, placeholder: UIImage(named: "icon_holderPlace"), options: .SetImageWithFadeAnimation, progress: nil, transform: { (image, _) -> UIImage? in
            return image.yy_imageByResizeToSize(size, contentMode: .Center)?.yy_imageByRoundCornerRadius(size.width / 2, borderWidth: 5, borderColor: UIColor.whiteColor())
            }, completion: nil)
        
        titleLabel.text = title ?? "登录/注册"
    }
    
    override func updateConstraints() {
        
        iconView.snp_makeConstraints { (make) in
            make.left.equalTo(40.fit())
            make.centerY.equalTo(0)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(0)
            make.left.equalTo(iconView.snp_right).offset(20.fit())
        }
        
        lineView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        super.updateConstraints()
    }
}
