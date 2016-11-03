//
//  DDSearchTitlesView.swift
//  CowGoods
//
//  Created by ddn on 16/7/8.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDSearchTitlesView: UIView {
    
    private var btns : [UIButton] = [UIButton]()
    
    var clickHanlder: ((idx: Int, selected: Bool)->Void)?
    
    class func instance(titles: [String], selectedTitles: [String]) -> DDSearchTitlesView {
        let titlesView = DDSearchTitlesView()
        titlesView.backgroundColor = UIColor.whiteColor()
        
        assert(selectedTitles.count == titles.count)
        
        for i in 0..<titles.count {
            
            let title = titles[i]
            let btn = UIButton()
            btn.setTitle(title, forState: .Normal)
            btn.setTitle(selectedTitles[i], forState: .Selected)
            btn.setTitleColor(UIColor.grayColor(), forState: .Normal)
            btn.setTitleColor(UIColor.orangeColor(), forState: .Selected)
            btn.titleLabel?.font = 24.fitFont()
            btn.selected = false
            
            titlesView.addSubview(btn)
            titlesView.btns.append(btn)
            btn.addTarget(titlesView, action: #selector(clickOn(_:)), forControlEvents: .TouchUpInside)
        }
        
        return titlesView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !btns.isEmpty {
            let w = width / CGFloat(btns.count)
            for (idx, btn) in btns.enumerate() {
                btn.left = CGFloat(idx) * w
                btn.top = 0
                btn.height = height
                btn.width = w
                btn.tag = idx
            }
        }
    }
    
    private var preBtn: UIButton?
    func clickOn(btn: UIButton) {
        
        if let preBtn = preBtn where preBtn != btn {
            preBtn.selected = false
        }
        
        btn.selected = !btn.selected
        
        preBtn = btn.selected ? btn : nil
        
        if let closure = clickHanlder {
            closure(idx: btn.tag, selected: btn.selected)
        }
    }
}
