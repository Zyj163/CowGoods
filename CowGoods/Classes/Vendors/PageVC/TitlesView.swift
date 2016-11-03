//
//  TitlesView.swift
//  CowGoods
//
//  Created by ddn on 16/6/16.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import pop

class TitlesView: UIScrollView {
    
    var selectedIdxHanlder: ((preIdx: Int, idx: Int) -> Void)?
    
    private lazy var titleBtns = [UIButton]()
    
    var titleBtnW : CGFloat = 0.0
    
    var titleBtnSpace : CGFloat = 1.0
    
    var indicatorH : CGFloat = 3.0
    
    var indicatorInset : CGFloat = 3.0
    
    var titleNormalFont : UIFont = UIFont.systemFontOfSize(12)
    
    var titleSelectedFont : UIFont = UIFont.systemFontOfSize(14)
    
    var titleNormalColor = UIColor.whiteColor()
    
    var titleSelectedColor = UIColor.redColor()
    
    var titleNormalBackgroundColor : UIColor?
    
    var titleSelectedBackgroundColor : UIColor?
    
    var titleNormalBackgroundImage : UIImage?
    
    var titleSelectedBackgroundImage : UIImage?
    
    var titles: [String]? {
        didSet {
            if let titles = titles {
                for idx in 0..<titles.count {
                    let btn = UIButton()
                    btn.setTitle(titles[idx], forState: .Normal)
                    
                    btn.setTitleColor(titleNormalColor, forState: .Normal)
                    btn.setTitleColor(titleSelectedColor, forState: .Disabled)
                    
                    btn.setBackgroundImage(titleNormalBackgroundImage, forState: .Normal)
                    btn.setBackgroundImage(titleSelectedBackgroundImage, forState: .Disabled)
                    
                    btn.titleLabel?.font = titleNormalFont
                    
                    btn.backgroundColor = titleNormalBackgroundColor
                    
                    titleBtns.append(btn)
                    addSubview(btn)
                    
                    btn.addTarget(self, action: #selector(clickOnItem(_:)), forControlEvents: .TouchUpInside)
                }
            }
        }
    }
    
    var selectedIdx = -1 {
        
        willSet {
            if selectedIdx == newValue {
                return
            }
            if selectedIdx >= 0 && newValue >= 0 {
                let btn = titleBtns[selectedIdx]
                btn.enabled = true
                
                UIView.animateWithDuration(0.25, animations: {
                    btn.backgroundColor = self.titleNormalBackgroundColor
                    btn.titleLabel?.font = self.titleNormalFont
                })
            }
        }
        
        didSet {
            if selectedIdx == oldValue {
                return
            }
            if selectedIdx < 0 {
                return
            }
            let btn = titleBtns[selectedIdx]
            btn.enabled = false
            
            UIView.animateWithDuration(0.25, animations: {
                btn.backgroundColor = self.titleSelectedBackgroundColor
                btn.titleLabel?.font = self.titleSelectedFont
            })
            
            if let hanlder = selectedIdxHanlder {
                hanlder(preIdx: oldValue, idx: selectedIdx)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickOnItem(btn: UIButton) {
        let idx = titleBtns.indexOf(btn)
        
        if selectedIdx != -1 {
            selectedIdx = idx!
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if titleBtnW <= 0.5 {
            titleBtnW = (width - (titleBtnSpace * CGFloat(titleBtns.count - 1))) / CGFloat(titleBtns.count)
        }
        
        lineLayout(titleBtns, withSetting: { [weak self] (idx, view) in
            view.width = self!.titleBtnW
            let width = self!.titleBtnW * (CGFloat(idx) + self!.titleBtnSpace) + self!.titleBtnSpace * CGFloat(idx)
            self!.contentSize = CGSizeMake(width, view.height)
            }, withInset: UIEdgeInsetsZero, andSpace: titleBtnSpace)
    }
    
    func update(percent: CGFloat) {
        
    }
    
}
