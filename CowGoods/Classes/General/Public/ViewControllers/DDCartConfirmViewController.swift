//
//  DDCartConfirmViewController.swift
//  CowGoods
//
//  Created by ddn on 16/7/6.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDCartConfirmViewController: DDCartViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func doSomethingAtFirstLoad() {
        dataView.reloadData()
    }
    
    override func setup() {
        super.setup()
        
        title = "采购订单确认"
        payBtn.setTitle("   确  认   ", forState: .Normal)
        selectBtn.removeFromSuperview()
        
        dataView.mj_header.hidden = true
        dataView.mj_footer.hidden = true
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let rowCount = my_enum.tableView(tableView, numberOfRowsInSection: section)
        
        var priceView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("footer")
        if priceView == nil {
            priceView = MyPriceView()
        }
        let viewModel = self.viewModel as! DDCartViewModel
        let p = priceView as! MyPriceView
        
        rowCount > 0 ? p.updatePrice(viewModel.getTotalPrice()) : p.clearPrice()
        
        p.expHanlder = {
            print("供货确认说明")
        }
        
        return p
    }
    
    override func clickOnPayBtn(btn: UIButton) {
        let payVc = DDChoosePayViewController()
        
        let vm = DDPayViewModel()
        vm.order = DDOrderModel()
        
        payVc.viewModel = vm
        
        
        DDGlobalNavController.pushViewController(payVc, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

}

class MyPriceView: PriceView {
    
    private let expBtn = UIButton()
    
    var expHanlder : (()->Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(expBtn)
        
        expBtn.setTitle("供货方说明", forState: .Normal)
        expBtn.titleLabel?.font = 20.fitFont()
        expBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
        expBtn.addTarget(self, action: #selector(clickOnExp(_:)), forControlEvents: .TouchUpInside)
        expBtn.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickOnExp(btn: UIButton) {
        if let hanlder = expHanlder {
            hanlder()
        }
    }
}