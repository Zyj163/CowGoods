//
//  DDLeftLabelTextField.swift
//  CowGoods
//
//  Created by ddn on 16/6/13.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDLeftLabelTextField: UITextField {
    
    var leftTitle : String = String() {
        didSet {
            setup()
        }
    }
    
    private func setup() {
        
        let telLabel = UILabel()
        telLabel.text = leftTitle + "  "
        telLabel.sizeToFit()
        
        leftView = telLabel
        leftViewMode = .Always
    }
}
