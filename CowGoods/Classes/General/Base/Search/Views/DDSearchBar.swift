//
//  DDSearchBar.swift
//  CowGoods
//
//  Created by ddn on 16/7/8.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit

private let margin: CGFloat = 8
private let space: CGFloat = 8

class DDSearchBar: UIView {
    
    var text: String? {
        didSet {
            searchTextField.text = text
        }
    }
    
    var searchClosure: ((searchBar: DDSearchBar, text: String?)->Void)?
    
    private lazy var searchBtn : UIButton = UIButton.button(self, action: #selector(clickOnSearchBtn(_:)))
    
    private lazy var searchTextField: UITextField = { [weak self] in
        let searchTextField = DDSearchTextField()
        searchTextField.delegate = self
        return searchTextField
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(searchTextField)
        addSubview(searchBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let h = searchBtn.height
        
        searchTextField.frame = CGRect(x: 0, y: (height - h) * 0.5, width: width - margin - searchBtn.width, height: h)
        
        searchBtn.origin = CGPoint(x: CGRectGetMaxX(searchTextField.frame) + space, y: (height - h) * 0.5)
    }
    
    override func becomeFirstResponder() -> Bool {
        return searchTextField.becomeFirstResponder() && super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return searchTextField.resignFirstResponder() && super.resignFirstResponder()
    }
}

extension DDSearchBar: UITextFieldDelegate {
    
    func clickOnSearchBtn(btn: UIButton) {
        textFieldShouldReturn(searchTextField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        resignFirstResponder()
        
        if let closure = searchClosure {
            closure(searchBar: self, text: textField.text)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        
        return true
    }
}
