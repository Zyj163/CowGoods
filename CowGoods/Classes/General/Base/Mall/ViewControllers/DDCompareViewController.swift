//
//  DDCompareViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD

class DDCompareViewController: DDBaseTableViewController {
    
    override init(my_enum: MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>? = nil) {
        
        let new_enum = my_enum ??  MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: DDCartViewModel(), v: UITableView(), cell: DDCartGoodsCell.self, pageSize: 20)
        
        super.init(my_enum: new_enum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
