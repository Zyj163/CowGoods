//
//  SVProgressHUD+Extension.swift
//  CowGoods
//
//  Created by ddn on 16/6/14.
//  Copyright © 2016年 ddn. All rights reserved.
//

import SVProgressHUD

extension SVProgressHUD {
    class func defaultSet() {
        SVProgressHUD.setDefaultStyle(.Light)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setDefaultMaskType(.Black)
    }
    
    class func show(inView view: UIView?) {
        showWithStatus(inView: view, status: nil)
    }
    
    class func showWithStatus(inView view: UIView?, status: String?) {
        
        if let view = view {
            let hud = generateHud(inView: view)
            
            hud.showProgress(-1, status: status)
        }else {
            showWithStatus(status)
        }
    }
    
    class func showSuccessWithStatus(inView view: UIView?, status: String?) {
        
        if let view = view {
            let hud = generateHud(inView: view)
            
            hud.showImage(hud.successImage, status: status, duration: hud.minimumDismissTimeInterval)
        }else {
            showSuccessWithStatus(status)
        }
    }
    
    class func showErrorWithStatus(inView view: UIView?, status: String?) {
        
        if let view = view {
            let hud = generateHud(inView: view)
            
            hud.showImage(hud.errorImage, status: status, duration: hud.minimumDismissTimeInterval)
        }else {
            showSuccessWithStatus(status)
        }
    }
    
    class func showInfoWithStatus(inView view: UIView?, status: String?) {
        
        if let view = view {
            let hud = generateHud(inView: view)
            
            hud.showImage(hud.infoImage, status: status, duration: hud.minimumDismissTimeInterval)
        }else {
            showSuccessWithStatus(status)
        }
    }
    
    class func dismiss(fromView view: UIView?) {
        if let view = view {
            view.subviews.filter{$0 is SVProgressHUD}.flatMap{$0 as? SVProgressHUD}.forEach{$0.dismiss()}
        }else {
            dismiss()
        }
    }
    
    private class func generateHud(inView view: UIView) -> SVProgressHUD {
        
        return view.subviews.filter{$0 is SVProgressHUD}.flatMap{$0 as? SVProgressHUD}.first ??
            {
                let hud = SVProgressHUD()
            
                hud.defaultStyle = .Custom
                hud.minimumDismissTimeInterval = 1
                hud.defaultMaskType = .Black
            
                hud.frame = view.bounds
                view.addSubview(hud)
                return hud
            }()
    }
}









