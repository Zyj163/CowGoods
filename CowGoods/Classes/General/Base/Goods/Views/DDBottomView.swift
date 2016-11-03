//
//  DDBottomView.swift
//  CowGoods
//
//  Created by ddn on 16/6/23.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

enum BtnType: String {
    case clickOnCollect
    case clickOnCart
    case clickOnAddToCart
    case clickOnBuy
}

class DDBottomView: UIView, UITabBarDelegate {
    
    var bageValue: Int? {
        didSet {
            tabbar.items![2].badgeValue = (bageValue == 0 || bageValue == nil) ? nil : "\(bageValue!)"
            DDGlobalCart.sharedGlobalCart().badgeValue = bageValue ?? 0
        }
    }
    
    var collect: Bool = false {
        didSet {
            let item = tabbar.items![1]
            if collect {
                item.title = "已收藏"
                item.image = UIImage(named: "collect_highlighted")?.imageWithRenderingMode(.AlwaysOriginal)
            }else {
                item.title = "收藏"
                item.image = UIImage(named: "collect_normal")
            }
        }
    }
    
    var collecting: Bool = false
    
    @IBOutlet weak var tabbar: UITabBar!
    
    var function: ((BtnType) ->Void)?
    
    class func instance() ->DDBottomView {
        return NSBundle.mainBundle().loadNibNamed("DDBottomView", owner: nil, options: nil)[0] as! DDBottomView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = 0.3
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        tabBar.selectedItem = nil
        
        let idx = tabBar.items!.indexOf(item)! as Int
        
        switch idx {
        case 0:
            print("客服")
        case 1:
            if collecting {
                break
            }
            if let function = function {
                function(BtnType.clickOnCollect)
            }
        case 2:
            if let function = function {
                function(BtnType.clickOnCart)
            }
        default:
            break
        }
    }
    
    @IBAction func clickOnAddToCart(sender: UIButton) {
        
        if let function = function {
            function(BtnType.clickOnAddToCart)
        }
    }

    @IBAction func clickOnBuy(sender: UIButton) {
        
        if let function = function {
            function(BtnType.clickOnBuy)
        }
    }
    
}
