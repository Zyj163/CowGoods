//
//  DDNewFeatureViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

import SnapKit
import pop

private let reuseIdentifier = "reuseIdentifier"

class DDNewFeatureViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var changeVcBtn: UIButton = { [weak self] in
        let btn = UIButton()
        btn.setTitle("进入牛品", forState: .Normal)
        btn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        btn.sizeToFit()
        btn.backgroundColor = UIColor.whiteColor()
        
        self!.view.addSubview(btn)
        
        btn.addTarget(self!, action: #selector(clickOnBtn(_:)), forControlEvents: .TouchUpInside)
        
        btn.snp_makeConstraints(closure: { (make) in
            make.bottom.right.equalTo(-20)
        })
        
        return btn
    }()
    
    lazy var collectionView: UICollectionView = { [weak self] in
        
        let layout = DDNewfeatureLayout()
        
        let collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
        self!.view.addSubview(collectionView)
        collectionView.dataSource = self!;
        collectionView.delegate = self!;
        
        return collectionView
    }()
    
    private let  pageCount = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerClass(DDNewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func clickOnBtn(btn: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(DDSwitchRootViewControllerNotify, object: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DDNewfeatureCell
        
        cell.imageIndex = indexPath.item
        
        
        return cell
    }
    
    // 完全显示一个cell之后调用
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems().last!
        
        if path.item == (pageCount - 1) {
            startBtnAnimation()
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item != (pageCount - 1) {
            stopBtnAnimation()
        }
    }
    
    /**
     让按钮做动画
     */
    private func startBtnAnimation() {
        changeVcBtn.hidden = false
        
        changeVcBtn.userInteractionEnabled = false
        
        changeVcBtn.transform = CGAffineTransformScale(changeVcBtn.transform, 0, 0)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .CurveEaseInOut, animations: {
                self.changeVcBtn.transform = CGAffineTransformIdentity
            }, completion: { (_) in
                self.changeVcBtn.userInteractionEnabled = true
        })
    }
    
    private func stopBtnAnimation() {
        changeVcBtn.hidden = true
        changeVcBtn.layer.pop_removeAllAnimations()
    }
}

// 如果当前类需要监听按钮的点击方法, 那么当前类不能是私有的
class DDNewfeatureCell: UICollectionViewCell
{
    // Swift中被private修饰的东西, 如果是在同一个文件中是可以访问的
    private var imageIndex:Int? {
        didSet{
            iconView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = randomColor()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(iconView)
        
        
        iconView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    // MARK: - 懒加载
    private lazy var iconView = UIImageView()
    
}

private class DDNewfeatureLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }
}
