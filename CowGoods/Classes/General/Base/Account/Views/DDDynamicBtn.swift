//
//  DDDynamicBtn.swift
//  CowGoods
//
//  Created by ddn on 16/6/13.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDDynamicBtn: UIButton {
    
    override var enabled: Bool {
        didSet {
            if enabled {
                reset()
            }else {
                timer.fireDate = NSDate()
            }
        }
    }
    
    private var totalTime: NSTimeInterval = 0
    
    private var dynamicTime: NSTimeInterval = 0
    
    private lazy var timer : NSTimer = { [weak self] in
        
        let timer = NSTimer(timeInterval: 1, block: { (timer) in
            
            self!.dynamicTime -= 1
            
            self!.refreshTitle()
            
            if self!.dynamicTime <= 0 {
                self!.enabled = true
            }
            }, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        return timer
        
        }()
    
    deinit {
        if let text = titleLabel?.text {
            if text.rangeOfString("(") != nil {
                reset()
            }
        }
    }
    
    class func dynamicButton(totalTime: NSTimeInterval, normalTitle: String, disabledTitle: String) ->DDDynamicBtn {
        
        let btn = DDDynamicBtn()
        btn.totalTime = totalTime
        btn.dynamicTime = totalTime
        
        btn.setTitle(normalTitle, forState: .Normal)
        btn.setTitle(disabledTitle, forState: .Disabled)
        
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(11)
        btn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        
        btn.sizeToFit()
        
        btn.backgroundColor = UIColor.orangeColor()
        
        btn.layer.cornerRadius = 4
        
        return btn
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        if let title = title {
            if state == .Disabled {
                if title.rangeOfString("(") == nil {
                    let newTitle = title + "(\(Int(totalTime))) "
                    super.setTitle(newTitle, forState: state)
                    return
                }
            }
        }
        super.setTitle(title, forState: state)
    }
    
    func refreshTitle() {
        let currentTime = self.dynamicTime
        if var text = self.titleLabel!.text {
            if let range = text.rangeOfString("(") {
                text = text.substringToIndex(range.startIndex)
            }
            self.setTitle(text + "(\(Int(currentTime))) ", forState: .Disabled)
        }else {
            self.setTitle("\(Int(currentTime)) ", forState: .Disabled)
        }
    }
    
    private func reset() {
        timer.fireDate = NSDate.distantFuture()
        dynamicTime = totalTime
    }
}
