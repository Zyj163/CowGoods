//
//  DDBaseTableViewCell.swift
//  CowGoods
//
//  Created by ddn on 16/6/14.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

protocol CellProtocol {
    
    var viewModel: DDBaseMoreDataViewModel? {get}
    var indexPath: NSIndexPath? {get}
    
    func binding(indexPath: NSIndexPath, viewModel: BaseViewModelProtocol)
}

class DDBaseTableViewCell: UITableViewCell, CellProtocol {

    var viewModel: DDBaseMoreDataViewModel?
    var indexPath: NSIndexPath?

    func binding(indexPath: NSIndexPath, viewModel: BaseViewModelProtocol) {
        self.indexPath = indexPath
        self.viewModel = viewModel as? DDBaseMoreDataViewModel
        
        setup()
    }
    
    func setup() {
        
    }
    
}
