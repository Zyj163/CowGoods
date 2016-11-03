//
//  PageViewController.swift
//  BestGoods
//
//  Created by zhangyongjun on 16/6/11.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

@objc protocol PageViewControllerDelegate: NSObjectProtocol {
    optional func pageViewController(didSelectedIdx index: Int)
}

enum PageControllerCachePolicy {
    case None
    case LowMemory
    case Balanced
    case High
    
    var limitCount : Int {
        switch self {
        case .None:
            return 0
        case .LowMemory:
            return 1
        case .Balanced:
            return 3
        case .High:
            return 5
        }
    }
}

class PageViewController: UIViewController {
    
    /// 缓存已经加载但未显示的控制器
    private lazy var memCache : NSCache = { [weak self] in
        let memCache = NSCache()
        memCache.countLimit = self!.countLimit == 0 ? self!.vcClasses!.count : self!.countLimit
        return memCache
        }()
    
    /// 主容器视图
    private lazy var pageView : PageView = { [weak self] in
        let pageView = PageView()
        self!.view.addSubview(pageView)
        pageView.delegate = self
        return pageView
    }()
    
    /// 标题栏
    private lazy var titlesView : TitlesView = { [weak self] in
        let titlesView = TitlesView()
        titlesView.selectedIdxHanlder = {
            self!.changeView($0, idx: $1)
            
            if let delegate = self!.delegate {
                if (delegate.respondsToSelector(#selector(PageViewControllerDelegate.pageViewController(didSelectedIdx:)))) {
                    delegate.pageViewController!(didSelectedIdx: $1)
                }
            }
        }
        self!.topViewContainer.addSubview(titlesView)
        return titlesView
    }()
    
    /// 顶部容器视图（包含topView和titlesView）
    private lazy var topViewContainer : UIView = { [weak self] in
        let topViewContainer = UIView()
        self!.view.addSubview(topViewContainer)
        return topViewContainer
    }()
    
    /// 当前显示的子控制器
    private var _currentVc: UIViewController?
    var currentVc : UIViewController? {
        return _currentVc
    }
    
    /// 当前选中的位置
    var selectedIdx: Int {
        return titlesView.selectedIdx
    }
    
    /// 当前展示在屏幕上的控制器，方便在滚动的时候读取 (避免不必要计算)
    private lazy var displayVcs = [Int : UIViewController]()
    
    /// 用于记录销毁的viewController的位置 (如果它是某一种scrollView的Controller的话)
    private lazy var posRecords = [Int : CGPoint]()
    
    /// 是否纪录scrollView的contentOffset
    var remeberLocation: Bool = true
    
    /// 收到内存警告的次数
    private var memoryWarningCount : Int = 0
    
    /// 纪录子控制器的frame
    private var childViewFrames : [CGRect]?
    
    /// 顶部分离视图
    var topView : UIView? = UIView() {
        didSet {
            topView?.removeFromSuperview()
            if let topView = topView {
                topViewContainer.addSubview(topView)
            }
        }
    }
    
    /// 全局手势
    private lazy var globalPan : UIPanGestureRecognizer = { [weak self] in
        let pan = UIPanGestureRecognizer(target: self!, action: #selector(actionWithGloblePan(_:)))
        return pan
    }()
    
    /// 被观察的scrollView
    private lazy var observeredViews = [UIScrollView]()
    
    /// 是否需要滚动顶部分离视图
    var scrollTopViewIfHave = true
    
    /// 标题栏内容
    var titles = [String]()
    
    /// 标题栏每个按钮的宽度，如果初始值为0，则按照父视图宽度平分
    var titleBtnW : CGFloat = 0.0

    /// 标题栏按钮间隙
    var titleBtnSpace : CGFloat = 1.0
    
    var indicatorH : CGFloat = 3.0
    
    var indicatorInset : CGFloat = 3.0
    
    /// 标题栏的高度
    var titleViewH : CGFloat = 44.0
    
    var titleNormalFont : UIFont = UIFont.systemFontOfSize(12)
    
    var titleSelectedFont : UIFont = UIFont.systemFontOfSize(14)
    
    var titleNormalColor = UIColor.whiteColor()
    
    var titleSelectedColor = UIColor.redColor()
    
    var titleNormalBackgroundColor : UIColor?
    
    var titleSelectedBackgroundColor : UIColor?
    
    var titleNormalBackgroundImage : UIImage?
    
    var titleSelectedBackgroundImage : UIImage?
    
    /// 代理
    weak var delegate: PageViewControllerDelegate?
    
    /// 子控制器的类型
    var vcClasses : [UIViewController.Type]?
    
    /// 缓存最大个数
    var countLimit : Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     初始化必要参数
     
     - parameter viewControllerClasses: 子控制器类型
     - parameter titles:                标题栏内容
     */
    func setup(viewControllerClasses: [UIViewController.Type], titles: [String]) {
        
        let assert : Bool = viewControllerClasses.isEmpty || titles.isEmpty || viewControllerClasses.count != titles.count
        
        if assert {
            return
        }
        
        setup()
        
        vcClasses = viewControllerClasses
        self.titles = titles
        
        addVcByCreateIfNotExist(0)
            
        addTitlesView()
        
        titlesView.selectedIdx = 0
        
        view.addGestureRecognizer(globalPan)
        
        _currentVc = displayVcs[titlesView.selectedIdx]
    }
    
    /**
     添加标题栏
     */
    private func addTitlesView() {
        
        titlesView.indicatorH = indicatorH
        titlesView.indicatorInset = indicatorInset
        titlesView.titleBtnSpace = titleBtnSpace
        titlesView.titleBtnW = titleBtnW
        titlesView.titleNormalFont = titleNormalFont
        titlesView.titleSelectedFont = titleSelectedFont
        titlesView.titleNormalColor = titleNormalColor
        titlesView.titleSelectedColor = titleSelectedColor
        titlesView.titleNormalBackgroundColor = titleNormalBackgroundColor
        titlesView.titleSelectedBackgroundColor = titleSelectedBackgroundColor
        titlesView.titleNormalBackgroundImage = titleNormalBackgroundImage
        titlesView.titleSelectedBackgroundImage = titleSelectedBackgroundImage
        
        titlesView.titles = titles
    }
    
    /**
     点击按钮后切换视图
     
     - parameter preIdx: 之前选中的位置
     - parameter idx:    当前选中的位置
     */
    func changeView(preIdx: Int, idx: Int) {
        pageView.setContentOffset(CGPointMake(CGFloat(idx) * pageView.width, pageView.contentOffset.y), animated: false)
        
        let gap = labs(idx - preIdx)
        
        if gap > 1 {
            layoutChildViewControllers()
            _currentVc = displayVcs[idx]
        }
    }

    /**
     在初始化必要参数之前要做的事（修改默认参数）
     */
    func setup() {
        
    }

    /**
     接收到内存警告，清除缓存并修改缓存策略
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        memoryWarningCount += 1
        
        countLimit = PageControllerCachePolicy.LowMemory.limitCount
        
        //取消正在增长的cache操作
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(growCachePolicyAfterMemoryWarning), object: nil)
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(growCachePolicyToHigh), object: nil)
        
        memCache.removeAllObjects()
        posRecords.removeAll(keepCapacity: true)
        
        var removeObservereds = [Int]()
        for (idx, scrollView) in observeredViews.enumerate() {
            if scrollView == currentVc?.view || (currentVc?.view.subviews.contains(scrollView))! {
                
            }else {
                scrollView.removeObserver(self, forKeyPath: "contentOffset")
                removeObservereds.append(idx)
            }
        }
        
        for idx in 0..<removeObservereds.count {
            observeredViews.removeAtIndex(idx)
        }
        
        //如果收到内存警告次数小于 3，一段时间后切换到模式 Balanced
        if memoryWarningCount < 3 {
            performSelector(#selector(growCachePolicyAfterMemoryWarning), withObject: nil, afterDelay: 3.0, inModes: [NSRunLoopCommonModes])
        }
    }
    
    func growCachePolicyAfterMemoryWarning() {
        countLimit = PageControllerCachePolicy.Balanced.limitCount
        performSelector(#selector(growCachePolicyToHigh), withObject: nil, afterDelay: 2.0, inModes: [NSRunLoopCommonModes])
    }
    
    func growCachePolicyToHigh() {
        countLimit = PageControllerCachePolicy.High.limitCount
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if titles.isEmpty {
            return
        }
        titlesView.frame = CGRectMake(0, topView!.height, self.view.width, titleViewH);
        titlesView.scrollEnabled = titlesView.contentSize.width != titlesView.width;
        
        topViewContainer.frame = CGRectMake(0, topViewContainer.top, self.view.width, titlesView.height + topView!.height);
        
        var height : CGFloat = view.height - titlesView.height
        if view is UIScrollView {
            let scrollView = view as! UIScrollView
            height = self.view.height - titlesView.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        }
        
        pageView.frame = CGRectMake(0, topViewContainer.height, self.view.width, height);
        
        pageView.contentSize = CGSizeMake(pageView.width * CGFloat(vcClasses!.count), pageView.height);
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        childViewFrames = [CGRect]()
        for idx in 0..<vcClasses!.count {
            let fIdx = CGFloat(idx)
            let frame = CGRectMake(fIdx*pageView.width, 0, pageView.width, pageView.height)
            childViewFrames?.append(frame)
        }
    }
    
    deinit {
        for scrollView in observeredViews {
            scrollView.removeObserver(self, forKeyPath: "contentOffset")
        }
        observeredViews.removeAll(keepCapacity: false)
        memCache.removeAllObjects()
    }
    
    override func addChildViewController(childController: UIViewController) {
        super.addChildViewController(childController)
        
        if scrollTopViewIfHave == false {
            return
        }
        
        if let scrollView = isScrollViewController(childController) {
            if observeredViews.contains(scrollView) {
                return
            }
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.New, .Old], context: nil)
            observeredViews.append(scrollView)
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let oldValue :CGPoint = change!["old"]?.CGPointValue() {
            if let newValue : CGPoint = change!["new"]?.CGPointValue() {
                var derection : CGFloat = 0.0
                
                let scrollView = object as! UIScrollView
                
                let contentOffset = scrollView.contentOffset
                
                if keyPath == "contentOffset" {
                    derection = oldValue.y - newValue.y
                    var temp : CGFloat = topViewContainer.top
                    temp += derection
                    
                    if contentOffset.y - scrollView.contentInset.top >= 0 {
                        if (derection > 0 && contentOffset.y - scrollView.contentInset.top < topView?.bounds.size.height) {
                            //下拉
                            if (topViewContainer.top < 0) {
                                if (temp < 0) {
                                    topViewContainer.top = temp
                                }else {
                                    topViewContainer.top = 0
                                }
                            }else {
                                topViewContainer.top = 0
                            }
                            
                        }else if (derection < 0) {
                            //上拉
                            let absP = titlesView.convertPoint(titlesView.origin, toView: view)
                            if (absP.y > 0) {
                                if (temp > -(topViewContainer.height - titlesView.height)) {
                                    topViewContainer.top = temp
                                }else {
                                    topViewContainer.top = -(topViewContainer.height - titlesView.height)
                                }
                            }else {
                                topViewContainer.top = -(topViewContainer.height - titlesView.height)
                            }
                        }
                    }else {
                        if topViewContainer.top < -10 {
                            if (derection > 0) {
                                temp += 2.5
                                if (temp > 0) {
                                    topViewContainer.top = 0
                                }else {
                                    topViewContainer.top = temp
                                }
                            }
                            
                        }else {
                            topViewContainer.top = 0
                        }
                    }
                    //        [self controlScrollLink:pan];
                    pageView.top = CGRectGetMaxY(topViewContainer.frame)
                }

            }
        }
    }
    
    func actionWithGloblePan(pan: UIPanGestureRecognizer) {
        panOnTopView(pan)
    }
    
    /// 全局手势动作
    private var currentY : CGFloat = 0.0
    func panOnTopView(pan: UIPanGestureRecognizer) {
        
        var derection = pan.translationInView(pan.view).y
        
        if (pan.state == .Began) {
            currentY = topViewContainer.top
        }else if (pan.state == .Ended || pan.state == .Failed || pan.state == .Cancelled) {
            currentY = 0
            return
        }
        
        derection += currentY
        
        if (topViewContainer.top <= 0 && topViewContainer.top >= -(topViewContainer.height - titlesView.height)) {
            if (derection >= 0) {
                topViewContainer.top = 0
            }else if (derection <= -(topViewContainer.height - titlesView.height)) {
                topViewContainer.top = -(topViewContainer.height - titlesView.height)
            }else {
                topViewContainer.top = derection
            }
            
        }
        pageView.top = CGRectGetMaxY(topViewContainer.frame)
    }
}


extension PageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == pageView {
            
            layoutChildViewControllers()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if pageView.contentOffset.x >= 0 {
            let idx = Int(round(Double(pageView.contentOffset.x/pageView.width)))
            titlesView.selectedIdx = idx
            _currentVc = displayVcs[titlesView.selectedIdx]
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        _currentVc = displayVcs[titlesView.selectedIdx]
    }
    
    /**
     判断frame是否可见
     
     - parameter frame: 要判断的frame
     
     - returns: 是否可见
     */
    private func isVisable(frame: CGRect) -> Bool {
        
        let x = frame.origin.x
        let width = pageView.width
        let contentOffsetX = pageView.contentOffset.x
        
        return (CGRectGetMaxX(frame) > contentOffsetX && x-contentOffsetX < width)
    }
    
    /**
     缓存控制器
     
     - parameter vc:  被缓存控制器
     - parameter idx: 被缓存控制器位置
     */
    private func cache(vc vc: UIViewController, idx: Int) {
        
        remeberPositionIfNeed(vc: vc, idx: idx)
        
        vc.view.removeFromSuperview()
        pageView[idx] = nil
        vc.willMoveToParentViewController(nil)
        vc.removeFromParentViewController()
        displayVcs.removeValueForKey(idx)
        
        if memCache.objectForKey(idx) == nil {
            memCache.setObject(vc, forKey: idx)
        }
    }
    
    /**
     布局子控制器
     */
    private func layoutChildViewControllers() {
        let currentPage = Int(pageView.contentOffset.x/pageView.width)
        let start = currentPage == 0 ? currentPage : currentPage - 1
        let end = (currentPage == vcClasses!.count - 1) ? currentPage : currentPage + 1
        
        for idx in start...end {
            let frame = childViewFrames![idx]
            var vc = displayVcs[idx]
            if isVisable(frame) {
                if vc == nil {
                    vc = memCache.objectForKey(idx) as? UIViewController
                    if let vc = vc {
                        add(cachedVc: vc, idx: idx)
                    }else {
                        addVcByCreateIfNotExist(idx)
                    }
                }
            }else {
                if let vc = vc {
                    cache(vc: vc, idx: idx)
                }
            }
        }
    }
    
    /**
     添加缓存过的控制器
     
     - parameter cachedVc: 要被添加的控制器
     - parameter idx:      要被添加的控制器的位置
     */
    private func add(cachedVc cachedVc: UIViewController, idx: Int) {
        
        addChildViewController(cachedVc)
        cachedVc.didMoveToParentViewController(self)
        pageView[idx] = cachedVc.view
        displayVcs[idx] = cachedVc
    }
    
    /**
     添加需要创建的控制器
     
     - parameter idx: 要添加到的位置
     */
    private func addVcByCreateIfNotExist(idx: Int) {
        if idx > vcClasses?.count {
            return
        }
        
        let classType = vcClasses![idx]
        
        let vc = classType.init()
        
        addChildViewController(vc)
        vc.didMoveToParentViewController(self)
        pageView[idx] = vc.view
        displayVcs[idx] = vc
        
        backToPositionIfNeed(vc: vc, idx: idx)
    }
    
    /**
     恢复到之前显示的contentOffset
     
     - parameter vc:  被展示的控制器
     - parameter idx: 被展示的控制器的位置
     */
    private func backToPositionIfNeed(vc vc: UIViewController, idx: Int) {
        if !remeberLocation {
            return
        }
        if memCache.objectForKey(idx) != nil {
            return
        }
        
        if let scrollView = isScrollViewController(vc) {
            if let location = posRecords[idx] {
                scrollView.setContentOffset(location, animated: false)
            }
        }
    }
    
    /**
     纪录当前显示的contentOffset
     
     - parameter vc:  被纪录的控制器
     - parameter idx: 被纪录的控制器的位置
     */
    private func remeberPositionIfNeed(vc vc:UIViewController, idx: Int) {
        if !remeberLocation {
            return
        }
        if let scrollView = isScrollViewController(vc) {
            let pos = scrollView.contentOffset
            posRecords[idx] = pos
        }
    }
    
    /**
     判断控制器的主界面是否是UIScrollView
     
     - parameter vc: 被判断的控制器
     
     - returns: 是则返回对应的UIScrollView，不是则返回nil
     */
    private func isScrollViewController(vc: UIViewController) -> UIScrollView? {
        let childView = vc.view
        
        if childView is UIScrollView {
            return childView as? UIScrollView
            
        }else {
            for subview in childView.subviews {
                if subview is UIScrollView {
                    return subview as? UIScrollView
                }
            }
        }
        return nil
    }
}














