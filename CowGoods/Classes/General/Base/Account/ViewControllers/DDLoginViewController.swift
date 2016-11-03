//
//  DDLoginViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/13.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD

class DDLoginViewController: DDKeyboardViewController {
    
    private lazy var viewModel = DDUserViewModel()
    
    private var canUse : Bool {
        return telTextField.flagTrue && passwordTextField.flagTrue
    }
    
    var isDynamic = false
    @IBOutlet weak var telTextField: DDFlagTextField!
    
    @IBOutlet weak var passwordTextField: DDFlagTextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var dynamicPasswordBtn: UIButton!
    
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    
    private lazy var getDynamicPasswordBtn : DDDynamicBtn = { [weak self] in
        
        let getDynamicPasswordBtn = DDDynamicBtn.dynamicButton(60, normalTitle: " 获取动态密码 ", disabledTitle: " 重新获取")
        
        getDynamicPasswordBtn.addTarget(self!, action: #selector(clickOnGetDynamicPassword(_:)), forControlEvents: .TouchUpInside)
        
        return getDynamicPasswordBtn
        
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupSubviews()
        
        forgetPasswordBtn.hidden = isDynamic
        getDynamicPasswordBtn.hidden = !isDynamic
        
        dynamicPasswordBtn.setTitle(isDynamic ? "返回密码登陆" : "获取动态密码", forState: .Normal)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss(fromView: view)
        }
    }
    
    private func setupSubviews() {
        
        telTextField.leftTitle = "账号"
        telTextField.hasFlagView = false
        
        passwordTextField.leftTitle = "密码"
        passwordTextField.hasFlagView = false
        passwordTextField.rightView = getDynamicPasswordBtn
        passwordTextField.rightViewMode = .Always
        
        textFields.append(telTextField)
        textFields.append(passwordTextField)
        
        loginBtn.layer.cornerRadius = 5
        title = "登陆"
        let rightItem = UIBarButtonItem(title: "注册", style: .Done, target: self, action: #selector(clickOnRightItem(_:)))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func clickOnRightItem(item: UIBarButtonItem) {
        let registerVc = DDRegisterViewController()
        
        self.navigationController?.pushViewController(registerVc, animated: true)
        
    }
    
    func clickOnGetDynamicPassword(btn: DDDynamicBtn) {
        
        //检查手机号
        if let telStr = telTextField.text {
            
            let able = Regexte.isTelNumber(telStr)
            if !able {
                SVProgressHUD.showErrorWithStatus(inView: view, status: "手机号码不合法")
                return
            }
            
            //发送请求获取动态密码
            SVProgressHUD.show(inView: view)
            
            viewModel.getDynamicPassword(Router.DynamicPassword(tel: telStr), completion: { [weak self] () -> Void in
                
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
    
    @IBAction func login(sender: UIButton) {
        
        textFields.forEach { (textField) in
            let textField = textField as! DDFlagTextField
            if !textField.flagTrue || textField.isFirstResponder() {
                checkTextField(textField)
            }
        }
        
        if !canUse {
            
        }else {
            //登录
            SVProgressHUD.show(inView: view)
            
            viewModel.login(Router.Login(tel: telTextField.text!, password: isDynamic ? "" :  passwordTextField.text!, dynamicPassword: isDynamic ? passwordTextField.text! : "", cid: ""), completion: { [weak self] () -> Void in
                if let viewModel = self?.viewModel {
                    switch viewModel.code {
                    case .Success://成功
                        SVProgressHUD.showSuccessWithStatus(inView: self?.view, status: viewModel.msg)
                        
                        let vcs = DDGlobalNavController.sharedInstace(nil).viewControllers
                        if vcs[vcs.count - 2] is DDLoginViewController || vcs[vcs.count - 2] is DDRegisterViewController {
                            DDGlobalNavController.popToRootViewControllerAnimated(true)
                        }else {
                            DDGlobalNavController.popViewControllerAnimated(true)
                        }
                        
                    default:
                        SVProgressHUD.showErrorWithStatus(inView: self?.view, status: viewModel.msg)
                    }
                }else {
                    SVProgressHUD.dismiss(fromView: self?.view)
                }
            })
        }
    }
    
    @IBAction func dynamic(sender: UIButton) {
        if isDynamic {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        let dynamicVc = DDLoginViewController()
        dynamicVc.isDynamic = !isDynamic
        self.navigationController?.pushViewController(dynamicVc, animated: true)
    }
    
    @IBAction func forgetPassword(sender: UIButton) {
        print("forgetPassword")
    }
    
    override func doSomethingBeforeReturn(textField: UITextField) {
        if textField == passwordTextField {
            view.endEditing(true)
            if canUse {
                login(loginBtn)
            }
        }
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
            case passwordTextField:
                if !isDynamic {
                    if Regexte.isPasswordNumber(text) {
                        passwordTextField.flagTrue = true
                    }else {
                        passwordTextField.flagTrue = false
                        SVProgressHUD.showErrorWithStatus(inView: view, status: "密码不合法")
                    }
                }else {
                    if Regexte.isAuthCodeNumber(text) {
                        passwordTextField.flagTrue = true
                    }else {
                        passwordTextField.flagTrue = false
                        SVProgressHUD.showErrorWithStatus(inView: view, status: "密码不合法")
                    }
                }
            default:
                break
            }
        }
    }
}












