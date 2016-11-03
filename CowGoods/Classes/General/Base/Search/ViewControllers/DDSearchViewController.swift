//
//  DDSearchViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

private let titlesViewH: CGFloat = 30
class DDSearchViewController: DDBaseTableViewController {
    
    private lazy var searchBtn : DDSearchBar = { [weak self] in
        let searchItem = DDSearchBar()
        searchItem.searchClosure = {
            if let text = $1, viewModel = self?.viewModel as? DDSearchViewModel {
                viewModel.keywords = text
                self?.headerRefresh(completion: {})
            }
        }
        return searchItem
        }()
    
    private lazy var titlesView : DDSearchTitlesView = { [weak self] in
        let titlesView = DDSearchTitlesView.instance(["综合排序 ▼", "近看促销", "筛选 ▼"], selectedTitles: ["综合排序 ▲", "近看促销", "筛选 ▲"])
        
        self!.view.addSubview(titlesView)
        
        titlesView.snp_makeConstraints(closure: { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(NavBarHeight + StatusBarHeight)
            make.height.equalTo(titlesViewH)
        })
        
        return titlesView
        }()
    
    override init(my_enum: MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>? = nil) {
        
        let new_enum = my_enum ??  MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: DDSearchViewModel(), v: UITableView(), cell: DDVistorGoodsCell.self, pageSize: 5)
        
        super.init(my_enum: new_enum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBtn;
        
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func doSomethingAtFirstLoad() {}
    
    override func setup() {
        super.setup()
        
        dataView.snp_remakeConstraints { (make) in
            make.top.equalTo(titlesView.snp_bottom).offset(8)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let viewModel = self.viewModel as! DDSearchViewModel
        searchBtn.text = viewModel.keywords
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBtn.origin = CGPoint(x: 0, y: 0)
        searchBtn.width = view.width
        searchBtn.height = NavBarHeight
    }
    
    override func headerRefresh(completion completion: () -> Void) {
        headerAction(completion: completion)
    }
    
    override func footerRefresh(completion completion: () -> Void) {
        footerAction(completion: completion)
    }
    
    //取消未登录的提示，因为这个页面不需要登录
    override func needLoginView() {
        noDataView.show(inView: view)
    }
}
