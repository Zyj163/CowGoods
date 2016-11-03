//
//  CustomTransition.swift
//  微博
//
//  Created by zhangyongjun on 16/5/29.
//  Copyright © 2016年 张永俊. All rights reserved.
//

/*
 示例代码
 
let popoverVc = PopoverViewController()

let duration = 0.5

transitionDelegate.animationTuple = (duration: duration, presentFrame: CGRectMake(100, 56, 200, 200), animation: {
    (isPresent : Bool, presentedView : UIView?, presentingView : UIView?, completion : (flag : Bool) -> Void) in
    if isPresent {
        if let presentedView = presentedView {
 
            presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0);
 
            // 设置锚点
            presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
 
            UIView.animateWithDuration(duration, animations: { () -> Void in
                presentedView.transform = CGAffineTransformIdentity
            }, completion: { (flag) in
                completion(flag: flag)
            })
        }
 
    }else {
        if let presentingView = presentingView {
 
            UIView.animateWithDuration(duration, animations: { () -> Void in
                // 注意:由于CGFloat是不准确的, 所以如果写0.0会没有动画
                presentingView!.transform = CGAffineTransformMakeScale(1.0, 0.00001)
            }, completion: { (flag) in
                completion(flag: flag)
            })
        }
 
    }
})

popoverVc.transitioningDelegate = transitionDelegate
popoverVc.modalPresentationStyle = .Custom

presentViewController(popoverVc, animated: true, completion: nil)
 
*/

import UIKit

// 定义常量保存通知的名称
let PresentationTransitionWillBeginNotify = "PresentationTransitionWillBeginNotify"
let DismissalTransitionWillBeginNotify = "DismissalTransitionWillBeginNotify"

class CustomPresentationController: UIPresentationController {

    
    //MARK:    UIPresentationController
    
        /// 被推出控制器的视图frame
    var presentFrame: CGRect? = CGRectZero
    
    var animating : Bool = false
    
        /// 蒙版
    private lazy var coverView: UIView = { [weak self] () in
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        
        self!.containerView?.insertSubview(view, atIndex: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    /**
     初始化方法, 用于创建负责转场动画的对象
     
     :param: presentedViewController  被展现的控制器
     :param: presentingViewController 发起的控制器
     
     :returns: 负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    func close() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        if presentFrame == CGRectZero {
            
            presentedView()?.frame = (containerView?.bounds)!
        }else {
            presentedView()?.frame = presentFrame ?? (containerView?.bounds)!
        
            coverView.frame = (containerView?.bounds)!
        }
    
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
    }
    
    /**
     不知道这个方法是怎么作用的
     
     - returns: frame
     */
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return (containerView?.bounds)!
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(presentedView()!)
        animating = true
        // 发送通知, 通知控制器即将展开
        NSNotificationCenter.defaultCenter().postNotificationName(PresentationTransitionWillBeginNotify, object: self)
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        animating = false
    }
    
    override func dismissalTransitionWillBegin() {
        animating = true
        // 发送通知, 通知控制器即将消失
        NSNotificationCenter.defaultCenter().postNotificationName(DismissalTransitionWillBeginNotify, object: self)
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        animating = false
    }
}

class CustomTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var animationTuple : (duration : NSTimeInterval, presentFrame : CGRect?, animation : (isPresent : Bool, presentedView : UIView?, presentingView : UIView?, completion : (flag : Bool) -> Void) -> Void)?
    
    var isPresent: Bool = false
    
    //MARK:    UIViewControllerTransitioningDelegate
    /**
      实现代理方法, 告诉系统谁来负责转场动画
      UIPresentationController iOS8推出的专门用于负责转场动画的
     
     - parameter presented:  被展现的控制器
     - parameter presenting: 不知道这个是干嘛的（野指针）
     - parameter source:     发起的控制器
     
     - returns: 负责转场动画的对象
     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        if animationTuple == nil {
            return nil
        }
        let pc = CustomPresentationController(presentedViewController: presented, presentingViewController: source)
        if let _ = animationTuple {
            pc.presentFrame = animationTuple!.presentFrame
        }
        return pc
    }
    
    // 只要实现了以下方法, 那么系统自带的默认动画就没有了, "所有"东西都需要程序员自己来实现
    /**
     告诉系统谁来负责Modal的展现动画
     
     :param: presented  被展现视图
     :param: presenting 发起的视图
     :returns: 谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if animationTuple == nil {
            return nil
        }
        isPresent = true
        return self
    }
    
    /**
     告诉系统谁来负责Modal的消失动画
     
     :param: dismissed 被关闭的视图
     
     :returns: 谁来负责
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if animationTuple == nil {
            return nil
        }
        isPresent = false
        return self
    }
    
    
    //MARK:    UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        if let animator = animationTuple {
            return animator.duration
        }
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let toView = toVC?.view
        let fromView = fromVC?.view
        
        if let animator = animationTuple {
            
            animator.animation(isPresent: isPresent, presentedView : toView, presentingView : fromView, completion: {
                (flag) in
                if flag {
                    transitionContext.completeTransition(true)
                }
            })
        }else {
            transitionContext.completeTransition(true)
        }
    }
    
    func animationEnded(transitionCompleted: Bool) {
       
        
    }
}























