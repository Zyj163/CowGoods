//
//  DDVistorGoodsListViewController.swift
//  CowGoods
//
//  Created by ddn on 16/7/1.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDVistorGoodsListViewController: DDBaseTableViewController {
    
    override init(my_enum: MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>? = nil) {
        
        let new_enum = my_enum ??  MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: DDVistorGoodsViewModel(), v: UITableView(), cell: DDVistorGoodsCell.self, pageSize: 5)
        
        super.init(my_enum: new_enum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vm = my_enum.viewModel as! DDVistorGoodsViewModel
        if let vc = vm.toNext(indexPath) {
            DDGlobalNavController.pushViewController(vc, animated: true)
        }
    }
    
    override func headerRefresh(completion completion: () -> Void) {
        headerAction(completion: completion)
    }
    
    override func footerRefresh(completion completion: () -> Void) {
        footerAction(completion: completion)
    }
    
    override var chargeLogin: Bool {
        return false
    }
}
