//
//  DDFlagTextField.swift
//  CowGoods
//
//  Created by ddn on 16/6/14.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

class DDFlagTextField: DDLeftLabelTextField {

    var hasFlagView: Bool = false {
        didSet {
            if hasFlagView {
                setupFlagView()
            }else {
                resetFlagView()
            }
        }
    }
    
    var flagTrue: Bool = false {
        didSet {
            if hasFlagView {
                rightView?.hidden = !flagTrue
            }
        }
    }
    
    private func setupFlagView() {
        let flagView = UIImageView(image: UIImage(named: ""))
        rightView = flagView
        rightViewMode = .Always
    }
    
    private func resetFlagView() {
        rightView = nil
        rightViewMode = .Never
    }

}
