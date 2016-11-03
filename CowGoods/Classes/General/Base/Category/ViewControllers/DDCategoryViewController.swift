//
//  DDCategoryViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/21.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD
import pop

private let identifier = "cell"
private let collectIdentifier = "item"
private let collectHeader = "header"
private let collectFooter = "footer"
class DDCategoryViewController: UIViewController {

    var viewModel = DDCategoryViewModel()
    
    var didLoad: Bool = false
    
    private lazy var headerHolderView : UIView = { [weak self] in
        let headerHolderView = UIView()
        headerHolderView.backgroundColor = UIColor(hexString: "eeeeee")
        self!.rightCollectionView.addSubview(headerHolderView)
        return headerHolderView
        }()
    
    private lazy var leftTableView : UITableView = { [weak self] in
        let leftTableView = UITableView()
        
        leftTableView.dataSource = self
        leftTableView.delegate = self
        
        leftTableView.scrollEnabled = false
        leftTableView.sectionFooterHeight = 0.5
        leftTableView.separatorStyle = .None
        leftTableView.alpha = 0
        leftTableView.contentInset.top = NavBarHeight + StatusBarHeight
        
        leftTableView.backgroundColor = UIColor.clearColor()
        
        self!.view.addSubview(leftTableView)
        
        leftTableView.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(TabBarHeight)
            make.width.equalTo(180.fit())
        })
        
        return leftTableView
        }()
    
    private lazy var rightCollectionView : UICollectionView = { [weak self] in
        
        let layout = DDCategoryCollectionViewLayout()
        layout.fontSize = 20.fit()
        
        let rightCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self!.view.addSubview(rightCollectionView)
        rightCollectionView.registerClass(DDCategoryCollectionViewCell.self, forCellWithReuseIdentifier: collectIdentifier)
        rightCollectionView.registerClass(DDHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectHeader)
        rightCollectionView.registerClass(DDHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: collectFooter)
        
        rightCollectionView.dataSource = self
        rightCollectionView.delegate = self
        
        rightCollectionView.backgroundColor = UIColor.whiteColor()
        rightCollectionView.showsVerticalScrollIndicator = false
        rightCollectionView.alpha = 0
        
        rightCollectionView.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self!.leftTableView.snp_right).offset(20.fit())
            make.bottom.equalTo(-TabBarHeight)
            make.top.equalTo(NavBarHeight + StatusBarHeight)
            make.right.equalTo(-20.fit())
        })
        
        return rightCollectionView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "eeeeee")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let _ = leftTableView
        if didLoad == false {
            didLoad = true
            loadFirstTime()
        }else {
            for (index, cell) in leftTableView.visibleCells.enumerate() {
                animation(index: index, cell: cell)
            }
        }
    }
    
    private func loadFirstTime() {
        //获取一级分类列表
        SVProgressHUD.show(inView: self.view)
        viewModel.getCategoryList(0) { [weak self] () in
            if let sf = self {
                switch sf.viewModel.code {
                case .Success:
                    sf.leftTableView.reloadData()
                    
                    UIView.animateWithDuration(0.5, animations: {
                        sf.leftTableView.alpha = 1
                        }, completion: nil)
                    
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    sf.leftTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                    sf.tableView(sf.leftTableView, didSelectRowAtIndexPath: indexPath)
                    sf.needShowNoDataView = false
                default:
                    SVProgressHUD.showErrorWithStatus(inView: sf.view, status: sf.viewModel.msg)
                    sf.didLoad = false
                    sf.needShowNoDataView = true
                    sf.justRightNoData = false
                }
            }else {
                SVProgressHUD.dismiss(fromView: self?.view)
            }
        }
    }
    
    
    private var noDataView: DDNoneDataView = DDNoneDataView()
    
    var needShowNoDataView: Bool  = false {
        didSet {
            needShowNoDataView ? normalNoDataView() : hideNoDataView()
        }
    }
    
    var justRightNoData: Bool = false {
        didSet {
            if oldValue == justRightNoData {
                return
            }
            if justRightNoData {
                noDataView.snp_remakeConstraints { (make) in
                    make.left.equalTo(leftTableView.snp_right)
                    make.top.bottom.right.equalTo(0)
                }
            }else {
                noDataView.snp_remakeConstraints(closure: { (make) in
                    make.edges.equalTo(0)
                })
            }
        }
    }
    
    func normalNoDataView() {
        noDataView.show(inView: view)
    }
    
    func hideNoDataView() {
        noDataView.dismiss(fromView: view)
    }
}


extension DDCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        fixCellSeperator(cell)
        
        animation(index: indexPath.row, cell: cell)
    }
    
    private func animation(index index: Int, cell: UITableViewCell) {
        
        cell.layer.transformTranslationX = -cell.width / 2
        
        UIView.animateWithDuration(0.4, delay: NSTimeInterval(Double(index) / 10.0), usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .CurveEaseInOut, animations: {
            cell.layer.transformTranslationX = 0
            }, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.leftItemCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
            cell?.textLabel?.font = 26.fitFont()
            cell?.textLabel?.textAlignment = .Center
            let view = UIView()
            view.backgroundColor = UIColor(hexString: "eeeeee")
            cell!.selectedBackgroundView = view
            cell!.backgroundView = UIImageView(image: UIImage(named: "category_background_normal"))
            cell!.textLabel?.textColor = UIColor(hexString: "959595")
        }
        cell?.textLabel?.text = viewModel.leftTitle(indexPath)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == viewModel.currentIndexPath?.row {
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.textLabel?.textColor = UIColor(hexString: "f19a00")
        
        SVProgressHUD.show(inView: self.view)
        viewModel.setSelectedLeftIndexPath(indexPath) { [weak self] () in
            if let sf = self {
                sf.rightCollectionView.reloadData()
                switch sf.viewModel.code {
                case .Success:
                    SVProgressHUD.dismiss(fromView: sf.view)
                    if sf.rightCollectionView.alpha == 0 {
                        UIView.animateWithDuration(0.5, animations: {
                            sf.rightCollectionView.alpha = 1
                        })
                    }
                    sf.needShowNoDataView = false
                default:
                    SVProgressHUD.showErrorWithStatus(inView: sf.view, status: sf.viewModel.msg)
                    sf.needShowNoDataView = true
                    sf.justRightNoData = true
                }
            }else {
                SVProgressHUD.dismiss(fromView: self?.view)
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.textLabel?.textColor = UIColor(hexString: "959595")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.fit()
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}


extension DDCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.rightSectionCount
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rightCellCount(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectIdentifier, forIndexPath: indexPath) as! DDCategoryCollectionViewCell
        cell.binding(indexPath, viewModel: viewModel)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var view :DDHeaderReusableView? = nil
        if kind == UICollectionElementKindSectionHeader {
            view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: collectHeader, forIndexPath: indexPath) as? DDHeaderReusableView
            view!.binding(indexPath, viewModel: viewModel)
        }else {
            view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: collectFooter, forIndexPath: indexPath) as? DDHeaderReusableView
            if indexPath.section == viewModel.rightSectionCount - 1 {
                view?.height = collectionView.height
            }
        }
        return view!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let vc = viewModel.setSelectedRightIndexPath(indexPath) {
            DDGlobalNavController.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == rightCollectionView {
            headerHolderView.frame = CGRect(origin: CGPointZero, size: CGSize(width: rightCollectionView.width, height: rightCollectionView.contentOffset.y))
        }
    }
}


class DDCategoryCollectionViewLayout: UICollectionViewFlowLayout {
    
    let itemCountLine : CGFloat = 3
    var fontSize : CGFloat = 13
    
    override func prepareLayout() {
        super.prepareLayout()
        
        headerReferenceSize = CGSize(width: collectionView!.width, height: 42.fit())
        footerReferenceSize = CGSize(width: 0.5, height: 0.5)
        minimumLineSpacing = 40.fit()
        minimumInteritemSpacing = 30.fit()
        sectionInset = UIEdgeInsets(top: 20.fit(), left: 30.fit(), bottom: 40.fit(), right: 30.fit())
        let width = (collectionView!.width - collectionView!.contentInset.left - collectionView!.contentInset.right - sectionInset.left - sectionInset.right - 30.fit() * (itemCountLine - 1)) / itemCountLine
        let height = width + 10.fit() + fontSize
        
        itemSize = CGSize(width: width > 0 ? width : 50, height: height)
    }
}























