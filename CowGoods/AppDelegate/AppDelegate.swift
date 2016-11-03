//
//  AppDelegate.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD
import YYWebImage
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setPay()
        
        SVProgressHUD.defaultSet()
        
        addNotify()
        
        globalSetting()
        
        window = DDAnimateWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.rootViewController = defaultContoller()
        window?.makeKeyAndVisible()
        
        return true
    }

    deinit {
        removeNotify()
    }
    
    /**
     清理图片缓存
     */
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        YYWebImageManager.sharedManager().cache?.diskCache.removeAllObjects()
        YYWebImageManager.sharedManager().cache?.memoryCache.removeAllObjects()
    }

}

extension AppDelegate {
    
    /**
     添加通知
     */
    private func addNotify() {
        NSDC.addObserver(self, selector: #selector(switchRootViewController(_:)), name: DDSwitchRootViewControllerNotify, object: nil)
        
        NSDC.addObserver(self, selector: #selector(NetTaskStatusChanged(_:)), name: Notifications.Task.DidResume, object: nil)
        NSDC.addObserver(self, selector: #selector(NetTaskStatusChanged(_:)), name: Notifications.Task.DidComplete, object: nil)
        NSDC.addObserver(self, selector: #selector(NetTaskStatusChanged(_:)), name: Notifications.Task.DidCancel, object: nil)
        NSDC.addObserver(self, selector: #selector(NetTaskStatusChanged(_:)), name: Notifications.Task.DidSuspend, object: nil)
    }
    
    /**
     监听Alamofire
     
     - parameter notify: 通知
     */
    func NetTaskStatusChanged(notify: NSNotification) {
        if let obj = notify.object as? NSURLSessionTask {
            if obj.state == .Running {
                NetVisable = true
            }else {
                NetVisable = false
            }
        }
    }
    
    /**
     移除通知
     */
    private func removeNotify() {
        NSDC.removeObserver(self)
    }
    
    /**
     全局属性设置
     */
    private func globalSetting() {
        
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: 26.fitFont()]
    }
    
    /**
     接收改变根控制器通知
     
     - parameter notify: 通知
     */
    func switchRootViewController(notify: NSNotification) {
        
        window?.rootViewController = DDGlobalNavController.sharedInstace(DDTabBarController())
    }
    
    /**
     用于获取默认界面
     
     :returns: 默认界面
     */
    private func defaultContoller() ->UIViewController {
        return isNewupdate() ? DDNewFeatureViewController() : DDGlobalNavController.sharedInstace(DDTabBarController())
    }
    
    /**
     版本判断
     
     - returns: 是否显示新特性
     */
    private func isNewupdate() -> Bool {
        
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        let sandboxVersion =  NSUD.objectForKey("CFBundleShortVersionString") as? String ?? ""
        
        if currentVersion.compare(sandboxVersion) == .OrderedDescending {
            
            NSUD.setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        return false
    }
    
    /**
     支付设置
     */
    private func setPay() {
        WXApi.registerApp(WX_APPID)
    }
    
    /**应用跳转*/
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if url.scheme == WX_APPID {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        
        AlipaySDK.defaultService().processOrderWithPaymentResult(url) { (result) in
            print(result)
        }
        
        return true
    }
    /**应用跳转*/
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        if url.scheme == WX_APPID {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        
        AlipaySDK.defaultService().processOrderWithPaymentResult(url) { (result) in
            print(result)
        }
        
        return true
    }
}

// MARK: - 微信支付代理
extension AppDelegate: WXApiDelegate {
    func onResp(resp: BaseResp!) {
        if resp is PayResp {
            NSDC.postNotificationName(WXPayNotification, object: nil, userInfo: ["WXPayResultKey" : resp])
        }
    }
}









