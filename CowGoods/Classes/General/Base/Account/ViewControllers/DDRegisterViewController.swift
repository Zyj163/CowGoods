//
//  DDRegisterViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/13.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class DDRegisterViewController: DDKeyboardViewController {
    
    private lazy var viewModel = DDUserViewModel()
    
    private var canUse : Bool {
        return telTextField.flagTrue && inviteTextField.flagTrue && authCodeTextField.flagTrue && passwordTextField.flagTrue && aginPasswordTextField.flagTrue
    }
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var telTextField: DDFlagTextField!
    
    @IBOutlet weak var inviteTextField: DDFlagTextField!
    
    @IBOutlet weak var authCodeTextField: DDFlagTextField!
    
    @IBOutlet weak var passwordTextField: DDFlagTextField!
    
    @IBOutlet weak var aginPasswordTextField: DDFlagTextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var noticeBtn: UIButton!
    
    private lazy var getAuthCodeBtn : DDDynamicBtn = { [weak self] in
        
        let getAuthCodeBtn = DDDynamicBtn.dynamicButton(60, normalTitle: "   获取验证吗   ", disabledTitle: " 重新获取")
        
        getAuthCodeBtn.addTarget(self!, action: #selector(clickOnAuthCode(_:)), forControlEvents: .TouchUpInside)
        
        return getAuthCodeBtn
        
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss(fromView: view)
        }
    }
    
    func clickOnAuthCode(btn: UIButton) {
        
        //检查手机号
        if let telStr = telTextField.text {
            
            let able = Regexte.isTelNumber(telStr)
            if !able {
                SVProgressHUD.showErrorWithStatus(inView: view, status: "手机号码不合法")
                return
            }
            
            //发送请求获取验证码
            SVProgressHUD.show(inView: view)
            
            viewModel.getAuthcode(Router.Authcode(tel: telStr), completion: { [weak self] () -> Void in
                
                if let viewModel = self?.viewModel {
                    switch viewModel.code {
                    case .Success:
                        SVProgressHUD.showSuccessWithStatus(inView: self?.view, status: viewModel.msg)
                        //开启倒计时
                        btn.enabled = false
                    default:
                        SVProgressHUD.showErrorWithStatus(inView: self?.view, status: viewModel.msg)
                    }
                }else {
                    SVProgressHUD.dismiss(fromView: self?.view)
                }
            })
        }
    }
    
    private func setupSubviews() {
        title = "注册"
        
        telTextField.leftTitle = "注册账号"
        telTextField.hasFlagView = true
        
        inviteTextField.leftTitle = "邀  请  码"
        inviteTextField.hasFlagView = true
        
        authCodeTextField.leftTitle = "验  证  码"
        authCodeTextField.hasFlagView = false
        authCodeTextField.rightView = getAuthCodeBtn
        authCodeTextField.rightViewMode = .Always
        
        passwordTextField.leftTitle = "输入密码"
        passwordTextField.hasFlagView = true
        
        aginPasswordTextField.leftTitle = "确认密码"
        aginPasswordTextField.hasFlagView = true
        
        textFields.append(telTextField)
        textFields.append(inviteTextField)
        textFields.append(authCodeTextField)
        textFields.append(passwordTextField)
        textFields.append(aginPasswordTextField)
    }
    
    @IBAction func clickOnRegister(sender: UIButton) {
        
        textFields.forEach { (textField) in
            let textField = textField as! DDFlagTextField
            if !textField.flagTrue || textField.isFirstResponder() {
                checkTextField(textField)
            }
        }
        
        if !canUse {
            
        }else {
            SVProgressHUD.show(inView: view)
            
            viewModel.register(Router.Register(tel: telTextField.text!, authcode: authCodeTextField.text!, password: passwordTextField.text!, inviteCode: inviteTextField.text!), completion: { [weak self] () -> Void in
                
                if let viewModel = self?.viewModel {
                    switch viewModel.code {
                    case .Success:
                        SVProgressHUD.showSuccessWithStatus(inView: self?.view, status: viewModel.msg)
                        DDGlobalNavController.popToRootViewControllerAnimated(true)
                    default:
                        SVProgressHUD.showErrorWithStatus(inView: self?.view, status: viewModel.msg)
                    }
                }else {
                    SVProgressHUD.dismiss(fromView: self?.view)
                }
            })
        }
    }
    
    @IBAction func clickOnNotice(sender: UIButton) {
    }
    
    override func checkTextField(textField: UITextField) {
        super.checkTextField(textField)
        
        if !shouldCheck {
            return
        }
        
        if let text = textField.text {
            
            switch textField {
            case telTextField:
                if Regexte.isTelNumber(text) {
                    telTextField.flagTrue = true
                }else {
                    telTextField.flagTrue = false
                    SVProgressHUD.showErrorWithStatus(inView: view, status: "手机号码不合法")
                }
                
            case inviteTextField:
                if Regexte.isInviteNumber(text) {
                    inviteTextField.flagTrue = true
                }else {
                    inviteTextField.flagTrue = false
                    SVProgressHUD.showErrorWithStatus(inView: view, status: "邀请码不合法")
                }
                
            case authCodeTextField:
                if Regexte.isAuthCodeNumber(text) {
                    authCodeTextField.flagTrue = true
                }else {
                    authCodeTextField.flagTrue = false
                    SVProgressHUD.showErrorWithStatus(inView: view, status: "验证码不合法")
                }
                
            case passwordTextField:
                
                if Regexte.isPasswordNumber(text) {
                    passwordTextField.flagTrue = true
                }else {
                    passwordTextField.flagTrue = false
                    SVProgressHUD.showErrorWithStatus(inView: view, status: "密码不合法")
                }
                
            case aginPasswordTextField:
                
                if text == passwordTextField.text && Regexte.isPasswordNumber(text) {
                    aginPasswordTextField.flagTrue = true
                }else {
                    aginPasswordTextField.flagTrue = false
                    SVProgressHUD.showErrorWithStatus(inView: view, status: "请再次确认密码")
                }
                
            default:
                break
            }
        }
    }
    
    override func doSomethingBeforeReturn(textField: UITextField) {
        if textField == aginPasswordTextField {
            view.endEditing(true)
            if canUse {
                clickOnRegister(registerBtn)
            }
        }
    }
}



























