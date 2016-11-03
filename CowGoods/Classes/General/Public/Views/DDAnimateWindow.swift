//
//  DDAnimateWindow.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDAnimateWindow: UIWindow {

    override var rootViewController: UIViewController? {
        didSet {
            if let rootViewController = rootViewController {
                rootViewController.view.alpha = 0.0
                UIView .animateWithDuration(0.5) {
                    rootViewController.view.alpha = 1.0
                }
                
                if let oldValue = oldValue {
                    
                    UIGraphicsBeginImageContext(oldValue.view.bounds.size)
                    
                    oldValue.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                    
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    
                    UIGraphicsEndImageContext()
                    
                    oldValue.view.alpha = 0.0
                    
                    let imageView = UIImageView.init(image: image)
                    addSubview(imageView)
                    UIView.animateWithDuration(0.5, animations: {
                        imageView.alpha = 0.0
                        }, completion: { (_) in
                            imageView.removeFromSuperview()
                    })
                }
            }
        }
    }

}
