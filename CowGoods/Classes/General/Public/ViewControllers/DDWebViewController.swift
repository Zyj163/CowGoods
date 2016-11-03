//
//  DDWebViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import WebKit

protocol DDWebViewControllerProtocol {
    func javasciptObj(fileName: String) -> WKUserScript?
    var url: NSURL? {get set}
}

extension DDWebViewControllerProtocol where Self : DDWebViewController {
    
    func javasciptObj(fileName: String) -> WKUserScript? {
        if let file = NSBundle.mainBundle().pathForResource(fileName, ofType: "js") {
            if let js = try? String(contentsOfFile: file, encoding: NSUTF8StringEncoding) {
                return WKUserScript(source: js, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
            }
        }
        return nil
    }
}

class DDWebViewController: UIViewController, DDWebViewControllerProtocol {

    private var _url: NSURL?
    var url : NSURL? {
        get {
            return _url
        }
        set {
            _url = newValue
        }
    }
    
    var didLoad : Bool = false
    
    private lazy var progressView : UIProgressView = { [weak self] in
        let progressView = UIProgressView(progressViewStyle: .Default)
        self!.webview.addSubview(progressView)
        progressView.progress = 0.0
        progressView.snp_makeConstraints(closure: { (make) in
            make.left.right.equalTo(self!.webview)
            make.top.equalTo(self!.webview.scrollView.contentInset.top)
        })
        return progressView
    }()
    
    var config: WKWebViewConfiguration {
        get {
            return WKWebViewConfiguration()
        }
    }

    lazy var webview : WKWebView = { [weak self] () in
        let config = self!.config
        let webView = WKWebView(frame: CGRectZero, configuration: config)
        webView.backgroundColor = UIColor.clearColor()
        return webView
    }()
    
    deinit {
        webview.stopLoading()
        webview.removeObserver(self, forKeyPath: "loading")
        webview.removeObserver(self, forKeyPath: "estimatedProgress")
        NetVisable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        webview.navigationDelegate = self
        
        view.addSubview(webview)
        
        webview.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(0)
        })
        
        webview.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !didLoad {
            if let url = url {
                didLoad = true
                let request = NSURLRequest(URL: url)
                webview.loadRequest(request)
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "loading" {
            NetVisable = webview.loading
            progressView.hidden = !webview.loading
        }else if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webview.estimatedProgress), animated: true)
        }
    }
    
    private var noDataView: DDNoneDataView = DDNoneDataView()
    
    var needShowNoDataView: Bool  = false {
        didSet {
            if oldValue == needShowNoDataView {
                return
            }
            needShowNoDataView ? noDataView.show(inView: view) : noDataView.dismiss(fromView: view)
        }
    }
}

extension DDWebViewController: WKNavigationDelegate {
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        needShowNoDataView = true
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        needShowNoDataView = true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        needShowNoDataView = false
    }
}


