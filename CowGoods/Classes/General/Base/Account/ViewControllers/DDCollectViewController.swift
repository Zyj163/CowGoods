//
//  DDCollectViewController.swift
//  CowGoods
//
//  Created by ddn on 16/7/25.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD

class DDCollectViewController: DDBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vm = my_enum.viewModel as! DDCollectViewModel
        if let vc = vm.toNext(indexPath) {
            DDGlobalNavController.pushViewController(vc, animated: true)
        }
    }
}
