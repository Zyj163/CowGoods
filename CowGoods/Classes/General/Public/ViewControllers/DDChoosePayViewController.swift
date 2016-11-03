//
//  DDChoosePayViewController.swift
//  CowGoods
//
//  Created by ddn on 16/7/11.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD

class DDChoosePayViewController: UITableViewController {
    
    var viewModel: DDPayViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "生成采购订单"
        tableView.sectionFooterHeight = 50
        
    }
    
    private func aliPayAction() {
        
        viewModel?.payForAli({ [weak self] () in
            if let vm = self?.viewModel {
                switch vm.code {
                case .Success:
                    SVProgressHUD.showSuccessWithStatus(inView: self?.view, status: vm.msg)
                default:
                    SVProgressHUD.showErrorWithStatus(inView: self?.view, status: vm.msg)
                    break
                }
            }
        })
    }
    
    private func wxPayAction() {
        viewModel?.parForWx({ [weak self] () in
            if let vm = self?.viewModel {
                switch vm.code {
                case .Success:
                    SVProgressHUD.showSuccessWithStatus(inView: self?.view, status: vm.msg)
                default:
                    SVProgressHUD.showErrorWithStatus(inView: self?.view, status: vm.msg)
                    break
                }
            }
        })
    }
}

//MARK: UITableViewDelegate&&UITableViewDataSource
extension DDChoosePayViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel!.sectionCount
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.rowCount(section: section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return viewModel!.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel?.tableView(tableView, viewForFooterInSection: section)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                //微信支付
                wxPayAction()
            }else if indexPath.row == 2 {
                //支付宝支付
                aliPayAction()
            }
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        fixCellSeperator(cell)
    }
}




