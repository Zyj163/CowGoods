//
//  DDRecommendViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import WebKit

class DDRecommendViewController: DDWebViewController {

    override var config: WKWebViewConfiguration {
        get {
            let config = WKWebViewConfiguration()
            if let js = javasciptObj("hideElement") {
                config.userContentController.addUserScript(js)
            }
            return config
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            webview.scrollView.contentInset.bottom = TabBarHeight
            webview.scrollView.scrollIndicatorInsets.bottom = TabBarHeight
            webview.scrollView.contentInset.top = NavBarHeight + StatusBarHeight
            webview.scrollView.scrollIndicatorInsets.top = NavBarHeight + StatusBarHeight
        }
        url = url ?? NSURL(string: "http://huil.com.cn/")
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if (navigationAction.navigationType == .LinkActivated) {
            decisionHandler(.Cancel);
            
            let nextVc = DDRecommendViewController()
            nextVc.url = navigationAction.request.URL
            DDGlobalNavController.pushViewController(nextVc, animated: true)
            
        }else {
            decisionHandler(.Allow);
        }
    }
    
}








