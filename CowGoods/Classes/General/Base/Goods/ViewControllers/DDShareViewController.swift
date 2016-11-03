//
//  DDShareViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/30.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDShareViewController: UIViewController {

    private static let identifier = "item"
    
    private lazy var iconView : UICollectionView = { [weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 30, height: 40)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 35, bottom: 0, right: 35)
        
        let iconView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        iconView.delegate = self
        iconView.dataSource = self
        iconView.scrollEnabled = false
        
        iconView.registerClass(DDShareCell.self, forCellWithReuseIdentifier: DDShareViewController.identifier)
        
        self?.view.addSubview(iconView)
        iconView.snp_makeConstraints(closure: { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(self!.cancelBtn.snp_top).offset(-1)
        })
        
        return iconView
        }()
    
    private lazy var cancelBtn : UIButton = { [weak self] in
        let cancelBtn = UIButton()
        
        self?.view.addSubview(cancelBtn)
        cancelBtn.snp_makeConstraints(closure: { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(TabBarHeight)
        })
        
        cancelBtn.backgroundColor = UIColor.whiteColor()
        cancelBtn.setTitle("取  消", forState: .Normal)
        cancelBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        cancelBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        cancelBtn.addTarget(self, action: #selector(clickOnCancel(_:)), forControlEvents: .TouchUpInside)
        return cancelBtn
        }()
    
    private let viewModel = DDShareViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        iconView.backgroundColor = UIColor.whiteColor()
    }
    
    func clickOnCancel(btn: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension DDShareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DDShareViewController.identifier, forIndexPath: indexPath) as! DDShareCell
        
        cell.binding(imageName: viewModel.imageName(indexPath: indexPath), title: viewModel.title(indexPath: indexPath)) {
            print(indexPath.row)
        }
        return cell
    }
}

class DDShareCell: UICollectionViewCell {
    
    private var iconView: DDBottomTitleBtn = DDBottomTitleBtn()
    
    var callback: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconView)
        iconView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        iconView.add(target: self, action: #selector(clickOn))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func binding(imageName imageName: String?, title: String?, callback: (()->Void)?) {
        if let imageName = imageName {
            iconView.image = UIImage(named: imageName)
        }
        if let title = title {
            iconView.title = title
        }
        if let callback = callback {
            self.callback = callback
        }
    }
    
    func clickOn() {
        if let callback = callback {
            callback()
        }
    }
}






