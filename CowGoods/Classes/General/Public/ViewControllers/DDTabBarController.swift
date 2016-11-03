//
//  DDTabBarController.swift
//  CowGoods
//
//  Created by ddn on 16/6/12.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDTabBarController: UITabBarController {
    
    private lazy var searchBar : DDSearchBar = { [weak self] in
        let searchItem = DDSearchBar()
        
        searchItem.searchClosure = {
            if let text = $1 {
                let viewModel = DDSearchViewModel()
                viewModel.keywords = text
                
                viewModel.refresh(10) {
                    switch viewModel.code {
                    case .Success:
                        
                        let searchVc = DDSearchViewController()
                        
                        searchVc.my_enum = MoreDataProtocolEnum<DDBaseMoreDataViewModel, UITableView, DDBaseTableViewCell>.Params(vm: viewModel, v: UITableView(), cell: DDVistorGoodsCell.self, pageSize: 10)
                        
                        DDGlobalNavController.pushViewController(searchVc, animated: true)
                    default:
                        break
                    }
                }
            }
        }
        
        return searchItem
        }()
    
    override func loadView() {
        delegate = self
        super.loadView()
    }
    
    private lazy var globalCart : DDGlobalCart = { [weak self] () in
        let globalCart = DDGlobalCart.sharedGlobalCart()
        self!.view.addSubview(globalCart)
        globalCart.snp_makeConstraints(closure: { (make) in
            make.bottom.equalTo(-60)
            make.left.equalTo(20)
        })
        return globalCart
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        tabBar.tintColor = UIColor.orangeColor()
        
        // 添加子控制器
        addChildViewControllers()
        
        tabBarController(self, didSelectViewController: (viewControllers?.first)!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        globalCart.hidden = false
    }
    
    private func addChildViewControllers() {
        
        addChildViewController("DDRecommendViewController", title: "商城", imageName: "tabbar_home")
        addChildViewController("DDCategoryViewController", title: "分类", imageName: "tabbar_category")
//        addChildViewController("DDTempCategoryViewController", title: "分类", imageName: "tabbar_category")
        addChildViewController("DDCloudHouseViewController", title: "云仓", imageName: "tabbar_cloud")
        addChildViewController("DDGoodsCenterViewController", title: "发货", imageName: "tabbar_send")
        addChildViewController("DDUserCenterViewController", title: "个人中心", imageName: "tabbar_user")
    }
    
    private func addChildViewController(childControllerName: String, title:String, imageName:String) {
        
        if let cls = classFromString(childControllerName) {
            let vcCls = cls as! UIViewController.Type
            
            let vc = vcCls.init()
            
            addChildViewController(vc)
            
            vc.tabBarItem.title = title
            
            vc.tabBarItem.image = UIImage(named: imageName)
            vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        }
    }
}


extension DDTabBarController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        //配置Nav
        let index = (viewControllers?.indexOf(viewController))!
        switch index {
        case 0:
            setNavForMallController()
        case 1:
            setNavForCategoryController()
        case 4:
            setNavForUserCenter(viewController)
        default:
            setNavForNormalController(viewController)
            break
        }
        
        itemAnimation(index)
    }
    
    private func itemAnimation(index: Int) {
        if !tabBar.subviews.isEmpty {
            let animationView = tabBar.subviews[index + 1]
            
            UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseInOut, animations: {
                animationView.layer.transformScale = 1.25
                }, completion: { (flag) in
                    UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseInOut, animations: {
                        animationView.layer.transformScale = 1
                        }, completion: nil)
            })
        }
    }
    
    private func setNavForCategoryController() {
        if navigationItem.titleView == nil {
            navigationItem.titleView = searchBar;
            searchBar.origin = CGPoint(x: 0, y: 0)
            searchBar.width = view.width
            searchBar.height = NavBarHeight
        }
    }
    
    private func setNavForMallController() {
        navigationItem.titleView = nil
        navigationItem.title = "牛品商城"
        navigationItem.rightBarButtonItems = nil
    }
    
    private func setNavForNormalController(vc: UIViewController) {
        navigationItem.titleView = nil
        navigationItem.title = vc.tabBarItem.title
        navigationItem.rightBarButtonItems = nil
    }
    
    private func setNavForUserCenter(vc: UIViewController) {
        navigationItem.titleView = nil
        navigationItem.title = vc.tabBarItem.title
        let rightItem = UIBarButtonItem(image: UIImage(named: "setting")?.imageWithRenderingMode(.AlwaysOriginal), style: .Done, target: self, action: #selector(clickOnSettingBtn(_:)))
        
        navigationItem.setFixedRightItem(rightItem)
    }
    
    func clickOnSettingBtn(item: UIBarButtonItem) {
        print(#function)
    }
}











