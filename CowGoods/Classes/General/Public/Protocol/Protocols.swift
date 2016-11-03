//
//  Protocols.swift
//  CowGoods
//
//  Created by ddn on 16/7/13.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation

/**
 *  UITableView or UICollectionView
 */
protocol DataViewProtocol {
    func registerClass(cellClass: AnyClass?, reuseIdentifier identifier: String)
    func reload()
    func refreshRows(range: NSRange)
}

/**
 *  包含上拉和下拉的UIScrollView
 */
protocol MoreDataViewControllerProtocol {
    
    associatedtype ViewModel
    associatedtype DataView
    associatedtype CellType
    
    var cellClass : CellType.Type {get}
    
    var dataView: DataView {get}
    var viewModel: ViewModel {get}
    
    func binding(dataView dataView: DataView) -> DataView
    
    func headerRefresh(completion completion:()->Void)
    func footerRefresh(completion completion:()->Void)
    func headerAction(completion completion:()->Void)
    func footerAction(completion completion:()->Void)
}

/**
 *  普通tableview的viewModel
 */
protocol BaseDataViewModelProtocol {
    
    /// 行数
    var rowCount: Int {get}
    
    func rowHeight(indexPath: NSIndexPath) -> CGFloat
}

/**
 *  包含网络请求的viewModel
 */
protocol BaseViewModelProtocol {
    
    /// 网络请求状态码 －2为网络连接失败；－1为请求失败；0为请求成功
    var code: StatusCode {get set}
    /// 网络请求后返回的消息
    var msg: String {get set}
    
    var currentTask: NSURLSessionTask? {get set}
}

/**
 *  包含上拉和下拉viewModel
 */
protocol BaseMoreDataViewModelProtocol {
    /**
     上拉加载
     - parameter pageSize: 请求数量
     */
    func getMore(pageSize: Int, completion: () -> Void)
    /**
     下拉刷新
     */
    func refresh(pageSize: Int, completion: () -> Void)
    /// 当前页
    var currentPage: Int {get set}
    /// 最大页数
    var maxPage: Int {get set}
    /// 模型数组
    var models: [DDBaseModel] {get set}
    /// 新增加模型个数
    var addCount: Int {get set}
}




