//
//  DDTempCategoryViewController.swift
//  CowGoods
//
//  Created by ddn on 16/7/1.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import WebKit

class DDTempCategoryViewController: DDWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        url = NSURL(string: "http://shop.yyox.com/index.php/Mobile/Goods/categoryList.html")
        
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        let urlstr = navigationAction.request.URLString
        if let _ = urlstr.rangeOfString("goodsInfo") {
            
            decisionHandler(.Cancel)
            
            let nextVc = DDGoodsDetailViewController()
            
            let components = urlstr.componentsSeparatedByString("id/")
            
            let id = components.last?.componentsSeparatedByString(".").first
            
            nextVc.goodId = id
            
            DDGlobalNavController.pushViewController(nextVc, animated: true)
        }else {
            decisionHandler(.Allow)
        }
        
//        if (navigationAction.navigationType == .LinkActivated) {
//            decisionHandler(.Cancel)
//            
//            let nextVc = DDRecommendViewController()
//            nextVc.url = navigationAction.request.URL
//            DDGlobalNavController.pushViewController(nextVc, animated: true)
//            
//        }else {
//            decisionHandler(.Allow)
//        }
    }

}
