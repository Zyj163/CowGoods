//
//  DDGlobalNavController.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDGlobalNavController: UINavigationController {
    
    static let globalNav: DDGlobalNavController = DDGlobalNavController()
    
    class func sharedInstace(rootVC: UIViewController?) -> DDGlobalNavController {
        
        if globalNav.viewControllers.count > 0 {
            return globalNav
        }else {
            assert(rootVC != nil, "no rootVC")
            globalNav.pushViewController(rootVC!, animated: false)
            return globalNav
        }
    }
    
    class func pushViewController(viewController: UIViewController, animated: Bool) {
        globalNav.pushViewController(viewController, animated: animated)
    }
    
    class func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        globalNav.presentViewController(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    class func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        return globalNav.popViewControllerAnimated(animated)
    }
    
    class func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        return globalNav.popToRootViewControllerAnimated(animated)
    }
    
    class func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return globalNav.popToViewController(viewController, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}




























