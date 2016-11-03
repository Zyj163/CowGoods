//
//  DDNotPaidViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/20.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class DDNotPaidViewController: DDBaseTableViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        my_enum = MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: DDNotPaidViewModel(), v: UITableView(), cell: DDNotPaidTableViewCell.self, pageSize: 5)
    }
    
    override init(my_enum: MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>? = nil) {
        
        let new_enum = my_enum ??  MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: DDPaidViewModel(), v: UITableView(), cell: DDPaidTableViewCell.self, pageSize: 5)
        
        super.init(my_enum: new_enum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVc = DDGoodsDetailViewController()
        detailVc.url = NSURL(string: "www.baidu.com")
        
        DDGlobalNavController.pushViewController(detailVc, animated: true)
    }
}




