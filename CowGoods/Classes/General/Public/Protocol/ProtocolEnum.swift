//
//  ProtocolEnum.swift
//  CowGoods
//
//  Created by ddn on 16/6/29.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation
import MJRefresh
import SVProgressHUD

private let identifier = "cell"
enum MoreDataProtocolEnum<VM: AnyObject, V: UIScrollView, CE: UIView where CE: CellProtocol, V: DataViewProtocol, VM: protocol<BaseDataViewModelProtocol, BaseViewModelProtocol, BaseMoreDataViewModelProtocol>> {
    
    case Params(vm: VM, v: V, cell: CE.Type, pageSize: Int)
    
    private var vM: VM {
        switch self {
        case .Params(let vm, _, _, _):
            return vm
        }
    }
    
    private var v: V {
        switch self {
        case .Params(_, let v, _, _):
            return v
        }
    }
    
    private var cell: CE.Type {
        switch self {
        case .Params(_, _, let ce, _):
            return ce
        }
    }
    
    private var pageSize: Int {
        switch self {
        case .Params(_, _, _, let ps):
            return ps
        }
    }
}

// MARK: MoreDataViewControllerProtocol
extension MoreDataProtocolEnum {
    
    var cellClass : CE.Type {
        return cell
    }
    
    var dataView: V {return binding(dataView: v)}
    var viewModel: VM {return vM}
    
    func binding(dataView dataView: V) -> V {
        if dataView.mj_header == nil {
            
            dataView.registerClass(cellClass, reuseIdentifier: identifier)
        }
        
        return dataView
    }
    
    func headerRefresh(completion completion:()->Void) {
        headerAction(completion: completion)
    }
    func footerRefresh(completion completion:()->Void) {
        footerAction(completion: completion)
    }
    func headerAction(completion completion:()->Void) {
        viewModel.refresh(pageSize, completion: {
            self.dataView.mj_header.endRefreshing()
            
            switch self.viewModel.code {
            case .Success:
                self.dataView.reload()
                self.dataView.mj_footer?.hidden = self.viewModel.currentPage >= self.viewModel.maxPage
            case .NotLogin:
                DDUserModel.clearAccount()
            default:
                SVProgressHUD.showErrorWithStatus(self.viewModel.msg)
            }
            completion()
        })
    }
    func footerAction(completion completion:()->Void) {
        viewModel.getMore(pageSize) {
            self.dataView.mj_footer.endRefreshing()
                
            switch self.viewModel.code {
            case .Success:
                let preCount = self.viewModel.models.count - self.viewModel.addCount
                
                let range = NSRange(location: preCount, length: self.viewModel.addCount)
                
                self.dataView.refreshRows(range)
                
                self.dataView.mj_footer?.hidden = self.viewModel.currentPage >= self.viewModel.maxPage
            case .NotLogin:
                DDUserModel.clearAccount()
            default:
                SVProgressHUD.showErrorWithStatus(self.viewModel.msg)
            }
            completion()
        }
    }
}

// MARK: UITableViewDataSource && UITableViewDelegate
extension MoreDataProtocolEnum {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! DDBaseTableViewCell
        
        cell.binding(indexPath, viewModel: viewModel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return viewModel.rowHeight(indexPath)
    }
}





