//
//  ProtocolsImp.swift
//  CowGoods
//
//  Created by ddn on 16/7/13.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

extension UITableView: DataViewProtocol {
    final func registerClass(cellClass: AnyClass?, reuseIdentifier identifier: String) {
        registerClass(cellClass, forCellReuseIdentifier: identifier)
    }
    
    final func reload() {
        reloadData()
    }
    
    final func refreshRows(range: NSRange) {
        
        var indexPaths = [NSIndexPath]()
        
        for i in 0..<range.length {
            let indexPath = NSIndexPath(forRow: range.location + i, inSection: 0)
            indexPaths += [indexPath]
        }
        
        insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
}

extension MoreDataViewControllerProtocol where Self: DDBaseTableViewController {
    var dataView: UITableView {
        return my_enum.dataView
    }
    
    var viewModel: DDBaseMoreDataViewModel {
        return my_enum.viewModel
    }
    
    var cellClass : DDBaseTableViewCell.Type {
        return my_enum.cellClass
    }
    
    func binding(dataView dataView: UITableView) -> UITableView {
        return my_enum.binding(dataView: dataView)
    }
    
    func headerRefresh(completion completion:()->Void) {
        my_enum.headerRefresh(completion: completion)
    }
    
    func footerRefresh(completion completion:()->Void) {
        my_enum.footerRefresh(completion: completion)
    }
    
    func headerAction(completion completion:()->Void) {
        my_enum.headerAction(completion: completion)
    }
    
    func footerAction(completion completion:()->Void) {
        my_enum.footerAction(completion: completion)
    }
    
}
