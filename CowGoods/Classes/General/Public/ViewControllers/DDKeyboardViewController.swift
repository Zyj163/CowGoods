//
//  DDKeyboardViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/14.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import YYKeyboardManager

class DDKeyboardViewController: UIViewController, YYKeyboardObserver, UITextFieldDelegate {

    var textFields: [UITextField] = [UITextField]()
    var currentTextField: UITextField?
    
    var shouldCheck: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YYKeyboardManager.defaultManager().addObserver(self)
        
    }
    
    override func viewDidLayoutSubviews() {
        if !(textFields.isEmpty) {
            textFields.forEach{$0.delegate = self}
        }
    }
    
    func doSomethingBeforeReturn(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField != textFields.last {
            let idx = textFields.indexOf(textField)
            let next = textFields[idx! + 1]
            
            next.becomeFirstResponder()
        }
        
        doSomethingBeforeReturn(textField)
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        currentTextField = nil
        
        checkTextField(textField)
        
        return true
    }
    
    func checkTextField(textField: UITextField){
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    deinit {
        YYKeyboardManager.defaultManager().removeObserver(self)
    }
    
    func keyboardChangedWithTransition(transition: YYKeyboardTransition) {
        if let currentTextField = currentTextField {
            
            let manager = YYKeyboardManager.defaultManager()
            
            let toFrame = manager.convertRect(transition.toFrame, toView: view)
            
            let animationDuration = transition.animationDuration;
            
            let textFieldFrame = currentTextField.convertRect(currentTextField.bounds, toView: view)
            
            if toFrame.origin.y < CGRectGetMaxY(textFieldFrame) {
                
                UIView.animateWithDuration(animationDuration, animations: {
                    self.view.transform = CGAffineTransformMakeTranslation(0, toFrame.origin.y - CGRectGetMaxY(textFieldFrame))
                })
            }else {
                UIView.animateWithDuration(animationDuration, animations: {
                    self.view.transform = CGAffineTransformIdentity
                })
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        shouldCheck = true
        textFields.first?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        shouldCheck = false
    }
}
