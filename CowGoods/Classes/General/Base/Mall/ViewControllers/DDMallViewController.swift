//
//  DDMallViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDMallViewController: PageViewController {

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
        
        setup([DDRecommendViewController.self, DDCompareViewController.self, DDGoodProductsViewController.self], titles: ["推荐区", "比较区", "推好货"])
    }
}

extension DDMallViewController: PageViewControllerDelegate {
    func pageViewController(didSelectedIdx index: Int) {
        DDGlobalNavController.sharedInstace(nil).setNavigationBarHidden(index != 0, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        DDGlobalNavController.sharedInstace(nil).setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        DDGlobalNavController.sharedInstace(nil).setNavigationBarHidden(selectedIdx != 0, animated: true)
    }
}
