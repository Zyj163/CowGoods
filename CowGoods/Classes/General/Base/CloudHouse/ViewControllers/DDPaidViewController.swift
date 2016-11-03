//
//  DDPaidViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/20.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class DDPaidViewController: DDBaseTableViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
}