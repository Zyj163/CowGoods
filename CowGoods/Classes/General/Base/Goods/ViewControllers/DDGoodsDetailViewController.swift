//
//  DDGoodsDetailViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/22.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class DDGoodsDetailViewController: DDWebViewController {

    let bottomView: DDBottomView = DDBottomView.instance()
    
    let viewModel: DDGoodsDetailViewModel = DDGoodsDetailViewModel()
    
    var load: Bool = false
    
    var goodId: String? {
        didSet {
            if let _ = goodId {
                url = NSURL(string: "http://shop.yyox.com/index.php/Mobile/Goods/goodsInfo/id/" + goodId! + ".html")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !load {
            load = true
            bottomView.tabbar.subviews.forEach { (view) in
                if view is UIImageView {
                    view.alpha = 0
                }
            }
            bottomView.bageValue = DDGlobalCart.sharedGlobalCart().badgeValue
        }
        
        //预加载
        if let _ = viewModel.model {}
        else {
            if let goodId = goodId {
                viewModel.getGoodsInfo(goodId){ [weak self] in
                    self?.bottomView.collect = self!.viewModel.isCollected
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "商品详情"
        
        let item = UIBarButtonItem(image: UIImage(named: "share"), style: .Done, target: self, action: #selector(clickOnNavItem(_:)))
        navigationItem.setFixedRightItem(item)
        
        view.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(TabBarHeight)
        }
        bottomView.function = { [weak self] (btnType) in
            switch btnType {
            case .clickOnCollect:
                self?.clickOnCollect()
            case .clickOnCart:
                self?.clickOnCart()
            case .clickOnAddToCart:
                self?.clickOnAddToCart()
            case .clickOnBuy:
                self?.clickOnBuy()
            }
        }
    }
    
    func clickOnCollect() {
        if let _ = viewModel.user {
            bottomView.collect = !bottomView.collect
            //加载过程中禁止操作，保证线程安全
            bottomView.collecting = true
            
            viewModel.changeCollect({ [weak self] in
                if let viewModel = self?.viewModel {
                    switch viewModel.code {
                    case .Success:
                        self?.bottomView.collecting = false
                        break
                    default:
                        SVProgressHUD.showErrorWithStatus(inView: self?.view, status: viewModel.msg)
                        self?.bottomView.collect = self!.viewModel.isCollected
                        self?.bottomView.collecting = false
                    }
                }
            })
        }else {
            DDGlobalNavController.pushViewController(DDLoginViewController(), animated: true)
        }
    }
    
    func clickOnCart() {
        if let _ = viewModel.user {
            
            DDGlobalNavController.pushViewController(DDCartViewController(), animated: true)
        }else {
            DDGlobalNavController.pushViewController(DDLoginViewController(), animated: true)
        }
    }
    
    
    private lazy var transitionDelegate = CustomTransition()
    private var buy: Bool = false
    func clickOnAddToCart() {
        
        getGoodsInfo({[weak self] () in
            if let ws = self {
                ws.buy = false
                
                let buyChooseVc = DDBuyChooseViewController()
                buyChooseVc.delegate = ws
                buyChooseVc.viewModel = ws.viewModel
                
                let height : CGFloat = ScreenHeight * 0.7
                let frame = CGRectMake(0, ws.view.height - height, ws.view.width, height)
                ws.customPresent(buyChooseVc, targetFrame: frame)
            }
        })
        
    }
    func clickOnBuy() {
        
        getGoodsInfo({[weak self] () in
            if let ws = self {
                ws.buy = true
                
                let buyChooseVc = DDBuyChooseViewController()
                buyChooseVc.delegate = ws
                buyChooseVc.viewModel = ws.viewModel
                
                let height : CGFloat = ScreenHeight * 0.7
                let frame = CGRectMake(0, ws.view.height - height, ws.view.width, height)
                ws.customPresent(buyChooseVc, targetFrame: frame)
            }
        })
        
    }
    
    private func getGoodsInfo(completion: ()->Void) {
        if let _ = viewModel.model {
            completion()
            return
        }
        if viewModel.currentTask != nil {
            viewModel.currentTask?.cancel()
        }
        if let goodId = goodId {
            SVProgressHUD.show(inView: self.view)
            viewModel.getGoodsInfo(goodId, completion: { 
                [weak self] () -> Void in
                if let viewModel = self?.viewModel {
                    switch viewModel.code {
                    case .Success, .NoProperty:
                        SVProgressHUD.dismiss(fromView: self?.view)
                        completion()
                    default:
                        SVProgressHUD.showErrorWithStatus(inView: self?.view, status: viewModel.msg)
                    }
                }else {
                    SVProgressHUD.dismiss(fromView: self?.view)
                }
            })
        }
    }
    
    func clickOnNavItem(item: UIBarButtonItem) {
        
        let shareVc = DDShareViewController()
        let height : CGFloat = ScreenHeight * 0.48
        let frame = CGRectMake(0, view.height - height, view.width, height)
        customPresent(shareVc, targetFrame: frame)
    }
    
    private func customPresent(vc: UIViewController, targetFrame: CGRect) {
        let duration = 0.3
        
        transitionDelegate.animationTuple = (duration: duration, presentFrame: targetFrame, animation: {
            (isPresent : Bool, presentedView : UIView?, presentingView : UIView?, completion : (flag : Bool) -> Void) in
            if isPresent {
                presentedView!.transform = CGAffineTransformMakeScale(1.0, 0.0);
                
                presentedView!.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    presentedView!.transform = CGAffineTransformIdentity
                    }, completion: { (flag) in
                        completion(flag: flag)
                })
            }else {
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    presentingView!.transform = CGAffineTransformMakeScale(1.0, 0.00001)
                    }, completion: { (flag) in
                        completion(flag: flag)
                })
            }
        })
        
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .Custom
        
        presentViewController(vc, animated: true, completion: nil)
    }
}

extension DDGoodsDetailViewController: DDBuyChooseViewControllerDelegate {
    func BuyChooseViewC(vc: DDBuyChooseViewController, dismissWithInfo: [String : AnyObject]?) {
        if !buy {
            if let _ = dismissWithInfo {
                
                viewModel.addToCart(goodId ?? "", goodsNum: viewModel.current_count, goodsSpec: viewModel.current_properties ?? [""], completion: { [weak self] () -> Void in
                    
                    if let viewModel = self?.viewModel {
                        switch viewModel.code {
                        case .Success:
                            SVProgressHUD.showSuccessWithStatus(inView: self?.view, status: viewModel.msg)
                            self?.bottomView.bageValue = viewModel.current_count + (self?.bottomView.bageValue ?? 0)
                        case .NotLogin:
                            SVProgressHUD.dismiss(fromView: self?.view)
                            DDGlobalNavController.pushViewController(DDLoginViewController(), animated: true)
                        default:
                            SVProgressHUD.showErrorWithStatus(inView: self?.view, status: viewModel.msg)
                        }
                        
                        viewModel.current_count = 1
                        viewModel.clearChoose()
                    }else {
                        SVProgressHUD.dismiss(fromView: self?.view)
                    }
                })
            }
        }else {
            //购买
        }
    }
}


extension DDGoodsDetailViewController {
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.Allow)
        
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








