//
//  DDCloudHouseViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDCloudHouseViewController: PageViewController {

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
        setup([DDNotPaidViewController.self, DDPaidViewController.self], titles: ["未付款", "已付款"])
    }

}

extension DDCloudHouseViewController: PageViewControllerDelegate {
    func pageViewController(didSelectedIdx index: Int) {
        
    }
}