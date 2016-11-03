//
//  DDBaseTableViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/28.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

protocol CanOverrideForChildOfDDBaseTableViewController {
    /**
     不要在viewDidLoad中写东西，全都放到setup()，并且要调用super方法
     */
    func setup()
    /// 是否需要登录
    var chargeLogin: Bool {get}
    /**
     需要登录的占位图
     */
    func needLoginView()
    /**
     没有数据的占位图
     */
    func normalNoDataView()
    /**
     隐藏占位图
     */
    func hideNoDataView()
    /**
     如果不想对登出做处理，置空该方法
     */
    func didLogout(noti: NSNotification)
    /**
     第一次加载，不需要可以置空
     */
    func doSomethingAtFirstLoad()
}

class DDBaseTableViewController: UIViewController, CanOverrideForChildOfDDBaseTableViewController {
    
    private var firstLoad: Bool = true
    
    var needIndicator: Bool = true
    
    var my_enum: MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell> = MoreDataProtocolEnum.Params(vm: DDBaseMoreDataViewModel(), v: UITableView(), cell: DDBaseTableViewCell.self, pageSize: 10)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(my_enum: MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>? = nil) {
        super.init(nibName: nil, bundle: nil)
        if let my_enum = my_enum {
            self.my_enum = my_enum
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        addLogoutNotify()
    }
    
    private func addLogoutNotify() {
        NSDC.addObserver(self, selector: #selector(didLogout(_:)), name: DDLogoutNotify, object: nil)
    }
    
    func setup() {
        
        view.addSubview(dataView)
        dataView.dataSource = self
        dataView.delegate = self
        
        dataView.sectionFooterHeight = 0.5
        
        dataView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(0)
        })
        
        dataView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] () in
            self?.headerRefresh(completion: {
                
                let count = self?.my_enum.tableView(self!.dataView, numberOfRowsInSection: 0)
                self?.needShowNoDataView = count == 0
            })
        })
        
        dataView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] () in
            self?.footerRefresh(completion: {
                
                let count = self?.my_enum.tableView(self!.dataView, numberOfRowsInSection: 0)
                self?.needShowNoDataView = count == 0
            })
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss(fromView: view)
        }
        
        if firstLoad {
            setup()
            doSomethingAtFirstLoad()
            firstLoad = false
        }
    }
    
    func doSomethingAtFirstLoad() {
        if needIndicator {
            showIndicatorView(inView: view)
        }
        headerRefresh(completion: { [weak self] () in
            if let ws = self {
                let count = ws.my_enum.tableView(ws.dataView, numberOfRowsInSection: 0)
                ws.needShowNoDataView = count == 0
                hideIndicatorView(fromView: ws.view)
            }
        })
        
        needIndicator = true
    }
    
    private var _noDataView: DDNoneDataView = DDNoneDataView()
    
    final var noDataView: DDNoneDataView {
        return _noDataView
    }
    
    private var needShowNoDataView: Bool  = false {
        didSet {
            if oldValue == needShowNoDataView {
                return
            }
            needShowNoDataView ? (chargeLogin ? (DDUserModel.userLogin() ? normalNoDataView() : needLoginView()) : normalNoDataView()) : hideNoDataView()
        }
    }
    
    var chargeLogin: Bool {
        return true
    }
    
    func needLoginView() {
        noDataView.show(imageName: nil, msg: "你还没有登录", inView: view)
    }
    
    func normalNoDataView() {
        noDataView.show(inView: view)
    }
    
    func hideNoDataView() {
        noDataView.dismiss(fromView: view)
    }
    
    func didLogout(noti: NSNotification) {
        my_enum.viewModel.models.removeAll()
        dataView.reloadData()
        needShowNoDataView = true
    }
    
    deinit {
        NSDC.removeObserver(self)
    }
}

//替代默认实现
extension DDBaseTableViewController: MoreDataViewControllerProtocol {
    
    func headerRefresh(completion completion:()->Void) {
        if !DDUserModel.userLogin() {
            dataView.mj_header.endRefreshing()
            dataView.reloadData()
            completion()
        }else {
            headerAction(completion: completion)
        }
    }
    
    func footerRefresh(completion completion:()->Void) {
        if !DDUserModel.userLogin() {
            dataView.mj_footer.endRefreshing()
            dataView.reloadData()
            completion()
        }else {
            footerAction(completion: completion)
        }
    }
}

extension DDBaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        fixCellSeperator(cell)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return my_enum.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return my_enum.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return my_enum.tableView(tableView, viewForFooterInSection: section)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return my_enum.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
}
