//
//  DDGlobalCart.swift
//  CowGoods
//
//  Created by ddn on 16/7/5.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDGlobalCart: UIView {

    private let button = UIButton()
    
    var badgeValue: Int {
        get {
            return NSUD.integerForKey(BadgeValueDefaultKey)
        }
        
        set {
            NSUD.setInteger(newValue, forKey: BadgeValueDefaultKey)
        }
    }
    
    static let globalCart: DDGlobalCart = DDGlobalCart()
    class func sharedGlobalCart() -> DDGlobalCart {
        return globalCart
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        button.setImage(UIImage(named: "cart_gray"), forState: .Normal)
        button.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        button.addTarget(self, action: #selector(clickOn(_:)), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickOn(btn: UIButton) {
        if DDUserModel.userLogin() {
            DDGlobalNavController.pushViewController(DDCartViewController(), animated: true)
        }else {
            DDGlobalNavController.pushViewController(DDLoginViewController(), animated: true)
        }
    }
}







