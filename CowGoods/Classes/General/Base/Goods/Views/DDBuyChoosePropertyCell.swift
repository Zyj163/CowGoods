//
//  DDBuyChoosePropertyCell.swift
//  CowGoods
//
//  Created by ddn on 16/7/1.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDBuyChoosePropertyCell: UITableViewCell {

    private var propertyLabel: UILabel = UILabel()
    
    private var titleBtns = [[UIButton]]()
    
    private var titlesView = UIView()
    
    private var selectedBtn: UIButton? {
        didSet {
            if oldValue == selectedBtn {
                return
            }
            if let oldValue = oldValue {
                oldValue.enabled = true
            }
            if let selectedBtn = selectedBtn {
                selectedBtn.enabled = false
            }
            if let categoryName = propertyLabel.text, propertyName = selectedBtn?.titleLabel?.text {
                if let chooseHanlder = chooseHanlder {
                    chooseHanlder(category: categoryName, property: propertyName)
                }
            }
        }
    }
    
    private let space : CGFloat = 10
    private let padding: CGFloat = 10
    
    private var chooseHanlder: ((category: String, property: String)->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(propertyLabel)
        contentView.addSubview(titlesView)
        
        propertyLabel.snp_makeConstraints { (make) in
            make.top.equalTo(padding)
            make.left.equalTo(padding)
        }
        propertyLabel.font = 26.fitFont()
        
        titlesView.snp_makeConstraints { (make) in
            make.top.equalTo(propertyLabel.snp_bottom)
            make.left.equalTo(propertyLabel)
            make.right.equalTo(-padding)
            make.bottom.equalTo(-padding)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func binding(indexPath indexPath: NSIndexPath, viewModel: DDGoodsDetailViewModel, chooseHanlder: ((category: String, property: String)->Void)?) {
        
        self.chooseHanlder = chooseHanlder
        
        propertyLabel.text = viewModel.goods_category_name(indexPath)
        if let titles = viewModel.goods_properties(indexPath) {
            layoutTitles(titles)
        }
    }
    
    func clickOnTitle(btn: UIButton) {
        selectedBtn = btn
    }
}

extension DDBuyChoosePropertyCell {
    
    func layoutTitles(titles: [String]) {
        
        titlesView.removeAllSubviews()
        titleBtns.removeAll()
        
        var w : CGFloat = padding
        var count = 0
        
        while count < titles.count {
            
            var lineArr = [UIButton]()
            var j = 0
            
            for subArr in titleBtns {
                j += subArr.count
            }
            
            for i in j..<titles.count {
                let btn = UIButton()
                btn.contentEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
                btn.setTitle(titles[i], forState: .Normal)
                btn.setTitleColor(UIColor(hexString: "333333"), forState: .Normal)
                btn.setTitleColor(UIColor.whiteColor(), forState: .Disabled)
                btn.titleLabel?.font = 24.fitFont()
                btn.sizeToFit()
                
                btn.setBackgroundImage(UIImage(named: "property_normal"), forState: .Normal)
                btn.setBackgroundImage(UIImage(named: "property_highlighted"), forState: .Disabled)
                
                btn.addTarget(self, action: #selector(clickOnTitle(_:)), forControlEvents: .TouchUpInside)
                
                if j + i == 0 {
                    clickOnTitle(btn)
                }
                
                w += btn.width + space
                if w <= width - padding * 2 {
                    titlesView.addSubview(btn)
                    lineArr.append(btn)
                    continue
                }else {
                    w = padding
                    break
                }
            }
            titleBtns.append(lineArr)
            count += lineArr.count
        }
        
        var top: CGFloat = 0
        var bottom: CGFloat = 0
        let btn = titleBtns[0][0]
        for i in 0..<titleBtns.count {
            let lineBtns = titleBtns[i]
            if !lineBtns.isEmpty {
                top = CGFloat(i) * (btn.height + space) + padding * 0.5
                bottom = space * 0.5 + CGFloat(titleBtns.count - 1 - i) * (btn.height + padding)
                
                lineButNoEqualLayout(lineBtns, setting: { (_, _) in
                    
                    }, insets: UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0), space: space)
            }
        }
    }
    
    func lineButNoEqualLayout(views: [UIView], setting: (idx: Int, view: UIView) ->Void, insets: UIEdgeInsets, space: CGFloat) {
        var preView: UIView?;
        for i in 0..<views.count {
            let view = views[i]
            view.snp_updateConstraints(closure: { (make) in
                make.top.equalTo(insets.top)
                make.bottom.equalTo(-insets.bottom)
            })
            
            setting(idx: i, view: view)
            
            if (i == 0) {
                view.snp_updateConstraints(closure: { (make) in
                    make.left.equalTo(insets.left)
                })
            }else {
                view.snp_updateConstraints(closure: { (make) in
                    make.left.equalTo(preView!.snp_right).offset(space)
                })
            }
            
            preView = view;
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
}
