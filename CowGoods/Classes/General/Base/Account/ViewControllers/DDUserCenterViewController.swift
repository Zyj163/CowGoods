//
//  DDUserCenterViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/15.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

private let footerH = 10.0.fit()
private let headerViewH = 250.0.fit()

private let identifier = "cell"
class DDUserCenterViewController: UIViewController {
    
    let tableView = UITableView()
    
    let headerView = DDUserHeaderView()
    
    var viewM : DDUserCenterViewModel = DDUserCenterViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    func setup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.contentInset.top = NavBarHeight + StatusBarHeight
        tableView.contentInset.bottom = TabBarHeight
        tableView.scrollIndicatorInsets.bottom = TabBarHeight
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.snp_updateConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.sectionFooterHeight = footerH
        
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: headerViewH)
        
        tableView.tableHeaderView = headerView
        
        headerView.clickCallback = { [weak self] () in
            if let viewModel = self?.viewM {
                if !viewModel.userLogin {
                    DDGlobalNavController.pushViewController(DDLoginViewController(), animated: true)
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        headerView.binding(viewM.userIcon(), title: viewM.userName())
        tableView.reloadData()
    }
}

extension DDUserCenterViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewM.sectionCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewM.rowCount(section)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 0 {
            view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        }
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil {
            let newCell = DDUserCenterCell(style: .Default, reuseIdentifier: identifier)
            newCell.binding(UIImage(named: viewM.image(indexPath)!)!, title: viewM.title(indexPath)!, indicator: indexPath.section == 0)
            cell = newCell
        }
        
        return cell!
    }
    
}

extension DDUserCenterViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        fixCellSeperator(cell)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print(indexPath.row)
        if let (vc, push) = viewM.selectToNext(indexPath) {
            push ? DDGlobalNavController.pushViewController(vc, animated: true) : presentViewController(vc, animated: true, completion: nil)
        }
    }
}