//
//  DDBuyChooseViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/30.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

@objc protocol DDBuyChooseViewControllerDelegate: NSObjectProtocol {
    optional func BuyChooseViewC(vc: DDBuyChooseViewController, dismissWithInfo: [String : AnyObject]?)
}

class DDBuyChooseViewController: UIViewController {
    
    var cells = [NSIndexPath : UITableViewCell]()
    
    var viewModel: DDGoodsDetailViewModel?
    
    weak var delegate: DDBuyChooseViewControllerDelegate?
    
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    @IBAction func clickOnSure(sender: UIButton) {
        dismissViewControllerAnimated(true) { 
            if let delegate = self.delegate where delegate.respondsToSelector(#selector(DDBuyChooseViewControllerDelegate.BuyChooseViewC(_:dismissWithInfo:))) {
                delegate.BuyChooseViewC!(self, dismissWithInfo: ["" : ""])
            }
        }
    }
    
    @IBAction func clickOnCancel(sender: UIButton) {
        dismissViewControllerAnimated(true) {
            if let delegate = self.delegate where delegate.respondsToSelector(#selector(DDBuyChooseViewControllerDelegate.BuyChooseViewC(_:dismissWithInfo:))) {
                delegate.BuyChooseViewC!(self, dismissWithInfo: nil)
            }
        }
    }
    
    private lazy var iconView : UIImageView = { [weak self] in
        let iconView = UIImageView()
        iconView.backgroundColor = UIColor.greenColor()
        
        let iconBackground = UIView()
        iconBackground.backgroundColor = UIColor.whiteColor()
        iconBackground.layer.cornerRadius = 8
        iconBackground.layer.borderColor = UIColor.lightGrayColor().CGColor
        iconBackground.layer.borderWidth = 1
        iconBackground.layer.masksToBounds = true
        
        self?.tableView.addSubview(iconBackground)
        
        iconBackground.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(-self!.tableViewTop.constant)
            make.left.equalTo(10)
            make.size.equalTo(CGSize(width: 100, height: 100))
        })
        
        iconBackground.addSubview(iconView)
        
        iconView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5))
        })
        
        
        return iconView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = 0.5
        tableView.clipsToBounds = false
        iconView.image = UIImage(named: "category_placeholder")
        iconView.layer.cornerRadius = 5
    }

}

private let identifier = "cell"
extension DDBuyChooseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rowCountForChoose ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        switch indexPath.row {
        case 0:
            addheaderCell(&cell)
        case viewModel!.rowCountForChoose - 1:
            addFooterCell(&cell)
        default:
            addPropertyCell(&cell, tableView: tableView, indexPath: indexPath)
        }
        cells[indexPath] = cell
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func addheaderCell(inout cell: UITableViewCell?) {
        cell = DDBuyChooseFirstTableViewCell(style: .Default, reuseIdentifier: "firstCell")
        let cell = cell as? DDBuyChooseFirstTableViewCell
        iconView.yy_setImageWithURL(viewModel?.goods_img, placeholder: UIImage(named: "category_placeholder"), options: .SetImageWithFadeAnimation, completion: nil)
        cell?.binding(viewModel!, properties: viewModel?.current_properties ?? [""])
    }
    
    func addPropertyCell(inout cell: UITableViewCell?, tableView: UITableView, indexPath: NSIndexPath) {
        cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = DDBuyChoosePropertyCell(style: .Default, reuseIdentifier: identifier)
        }
        let cell = cell as! DDBuyChoosePropertyCell
        cell.binding(indexPath: indexPath, viewModel: viewModel!, chooseHanlder: { [weak self] (category: String, property: String) in
            
            self?.viewModel?.updateChoose(indexPath, value: property)
            
            if let firstCell = self?.cells[NSIndexPath(forRow: 0, inSection: 0)] as? DDBuyChooseFirstTableViewCell {
                if let viewModel = self?.viewModel, properties = viewModel.current_properties {
                    firstCell.binding(viewModel, properties: properties)
                }
            }
            
            if let countCell = self?.cells[NSIndexPath(forRow: self!.viewModel!.rowCountForChoose - 1, inSection: 0)] as? DDBuyChooseCountCell {
                if let viewModel = self?.viewModel, properties = viewModel.current_properties {
                    countCell.maxNum = Int(viewModel.goods_store(properties) ?? "0")!
                    countCell.num = 1
                }
            }
        })
    }
    
    func addFooterCell(inout cell: UITableViewCell?) {
        cell = DDBuyChooseCountCell(style: .Default, reuseIdentifier: "cout")
        let cell = cell as! DDBuyChooseCountCell
        
        if let viewModel = viewModel, properties = viewModel.current_properties {
            cell.maxNum = Int(viewModel.goods_store(properties) ?? "0")!
            cell.num = 1
            viewModel.current_count = cell.num
        }
        
        cell.chooseHanlder = { [weak self] (count) in
            if let viewModel = self?.viewModel {
                viewModel.current_count = count
            }
        }
    }
}
