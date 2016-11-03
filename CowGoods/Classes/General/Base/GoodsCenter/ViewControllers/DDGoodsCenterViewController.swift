//
//  DDGoodsCenterViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/20.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDGoodsCenterViewController: PageViewController {

    override func loadView() {
        view = UIScrollView()
        
        let scrollView = view as! UIScrollView
        scrollView.contentInset.bottom = TabBarHeight
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    override func setup() {
        
        titleViewH = 35
        titleNormalBackgroundColor = UIColor.blueColor()
        titleSelectedBackgroundColor = UIColor.brownColor()
    }
    
    override func viewDidLoad() {
        
        delegate = self
        
        super.viewDidLoad()
        
        setup([DDSendGoodsViewController.self, DDGetGoodsViewController.self, DDGoodsListViewController.self], titles: ["待发货", "待收货", "全部"])
    }

}

extension DDGoodsCenterViewController: PageViewControllerDelegate {
    func pageViewController(didSelectedIdx index: Int) {
        
    }
}