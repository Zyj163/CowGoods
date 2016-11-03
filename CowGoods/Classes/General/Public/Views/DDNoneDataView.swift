//
//  DDNoneDataView.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDNoneDataView: UIView {

    var imageNamed : String? {
        didSet {
            if let imageNamed = imageNamed {
                imageView.image = UIImage(named: imageNamed)
            }
        }
    }
    
    var message : String? {
        didSet {
            msgLabel.text = message
        }
    }
    
    private lazy var imageView : UIImageView = { [weak self] in
        let imageView = UIImageView()
        self!.addSubview(imageView)
        
        imageView.snp_makeConstraints(closure: { (make) in
            make.centerX.equalTo(0)
            make.centerY.equalTo(-20)
        })
        
        return imageView
        }()
    
    private lazy var msgLabel : UILabel = { [weak self] in
        let msgLabel = UILabel()
        self!.addSubview(msgLabel)
        
        msgLabel.textAlignment = .Center
        msgLabel.font = 24.fitFont()
        msgLabel.textColor = UIColor(hexString: "959595")
        
        msgLabel.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.top.equalTo(self!.imageView.snp_bottom).offset(5)
        })
        
        return msgLabel
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(imageName name: String? = "category_placeholder", msg: String? = "没有数据", inView: UIView) {
        
        if superview == inView {
            return
        }
        
        imageNamed = name
        
        message = msg
        
        inView.addSubview(self)
        
        snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

    func dismiss(fromView view: UIView) {
        if superview == view {
            removeFromSuperview()
        }
    }
}










