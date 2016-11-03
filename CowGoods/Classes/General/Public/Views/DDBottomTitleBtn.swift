//
//  DDBottomTitleBtn.swift
//  CowGoods
//
//  Created by ddn on 16/6/30.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

@IBDesignable class DDBottomTitleBtn: UIView {

    private var imageBtn: UIButton = UIButton()
    
    private var titleLabel: UILabel = UILabel()
    
    @IBInspectable var image: UIImage? {
        didSet {
            imageBtn.setImage(image, forState: .Normal)
            imageBtn.sizeToFit()
            self.sizeToFit()
        }
    }
    
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
            self.sizeToFit()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    class func instance(imageName imageName: String, title: String) -> DDBottomTitleBtn {
        let btn = DDBottomTitleBtn()
        btn.imageBtn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.titleLabel.text = title
        return btn
    }
    
    func add(target target: AnyObject, action: Selector) {
        imageBtn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    private func setup() {
        addSubview(imageBtn)
        addSubview(titleLabel)
        
        titleLabel.textAlignment = .Center
        titleLabel.font = 24.fitFont()
        
        imageBtn.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
        }
        titleLabel.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.top.equalTo(imageBtn.snp_bottom).offset(2)
        }
    }

}
