//
//  DDCartViewController.swift
//  CowGoods
//
//  Created by ddn on 16/7/5.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD

class DDCartViewController: DDBaseTableViewController {
    
    private lazy var bottomView : UIImageView = { [weak self] () in
        let bottomView = UIImageView()
        bottomView.userInteractionEnabled = true
        self!.view.addSubview(bottomView)
        
        bottomView.snp_makeConstraints(closure: { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(30)
        })
        
        return bottomView
        }()
    
    lazy var payBtn : UIButton = { [weak self] () in
        let payBtn = UIButton()
        payBtn.setTitle("结算", forState: .Normal)
        payBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        payBtn.titleLabel?.font = 22.fitFont()
        payBtn.backgroundColor = UIColor.orangeColor()
        self!.bottomView.addSubview(payBtn)
        
        payBtn.snp_makeConstraints(closure: { (make) in
            make.top.bottom.right.equalTo(0)
        })
        payBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        payBtn.addTarget(self, action: #selector(clickOnPayBtn(_:)), forControlEvents: .TouchUpInside)
        
        return payBtn
        }()
    
    lazy var selectBtn : UIButton = { [weak self] () in
        let selectBtn = UIButton()
        selectBtn.setTitle("全选", forState: .Normal)
        selectBtn.titleLabel?.font = 20.fitFont()
        selectBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        selectBtn.setTitleColor(UIColor.redColor(), forState: .Selected)
        self!.bottomView.addSubview(selectBtn)
        selectBtn.snp_makeConstraints(closure: { (make) in
            make.left.top.bottom.equalTo(0)
        })
        
        selectBtn.addTarget(self, action: #selector(clickOnSelectBtn(_:)), forControlEvents: .TouchUpInside)
        return selectBtn
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setup() {
        super.setup()
        
        dataView.sectionFooterHeight = 30
        title = "购物车"
        
        selectBtn.backgroundColor = UIColor.clearColor()
        payBtn.setTitle("结算(0)", forState: .Normal)
    }
    
    override init(my_enum: MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>? = nil) {
        
        let new_enum = my_enum ??  MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: DDCartViewModel(), v: UITableView(), cell: DDCartGoodsCell.self, pageSize: 20)
        
        super.init(my_enum: new_enum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        CacheTool.clear(key: CartCache)
        CacheTool.hold(viewModel.models, forKey: CartCache)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let vm = my_enum.viewModel as! DDVistorGoodsViewModel
//        if let vc = vm.toNext(indexPath) {
//            DDGlobalNavController.pushViewController(vc, animated: true)
//        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as! DDCartGoodsCell
        
        cell.takeOrNotHanlder = { [weak self] (selected, indexPath) in
            if let viewModel = self?.viewModel {
                let viewModel = viewModel as! DDCartViewModel
                viewModel.changeStatus(selected, indexPath: indexPath)
                self!.selectBtn.selected = viewModel.allTaken
                
                if let priceView = tableView.footerViewForSection(0) {
                    if priceView is PriceView {
                        let priceView = priceView as! PriceView
                        priceView.updatePrice(viewModel.getTotalPrice())
                        self!.payBtn.setTitle("结算(¥\(viewModel.getTotalPrice()))", forState: .Normal)
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let rowCount = my_enum.tableView(tableView, numberOfRowsInSection: section)
        
        var priceView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("footer")
        if priceView == nil {
            priceView = PriceView()
        }
        let viewModel = self.viewModel as! DDCartViewModel
        let p = priceView as! PriceView
        
        rowCount > 0 ? p.updatePrice(viewModel.getTotalPrice()) : p.clearPrice()
        return priceView
    }
    
    func clickOnPayBtn(btn: UIButton) {
        
        let viewModel = self.viewModel as! DDCartViewModel
        
        SVProgressHUD.showInfoWithStatus(inView: view, status: "您未选择结算商品!")
        if viewModel.noneTaken {
            SVProgressHUD.showInfoWithStatus(inView: view, status: "您未选择结算商品!")
        }else {
            
            let confirmVc = viewModel.confirm()
            
            DDGlobalNavController.pushViewController(confirmVc, animated: true)
        }
    }
    
    func clickOnSelectBtn(btn: UIButton) {
        
        btn.selected = !btn.selected
        
        let viewModel = self.viewModel as! DDCartViewModel
        
        viewModel.changeStatus(btn.selected, indexPath: nil)
        dataView.reloadData()
        payBtn.setTitle("结算(¥\(viewModel.getTotalPrice()))", forState: .Normal)
    }
}

class PriceView: UITableViewHeaderFooterView {
    let desLabel: UILabel = UILabel()
    
    func updatePrice(price: Double) {
        desLabel.text = "合计：¥" + "\(price)"
    }
    
    func clearPrice() {
        desLabel.text = ""
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(desLabel)
        desLabel.font = 20.fitFont()
        desLabel.textColor = UIColor.grayColor()
        desLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(0)
            make.right.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







