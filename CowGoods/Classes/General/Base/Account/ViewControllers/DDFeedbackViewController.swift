//
//  DDFeedbackViewController.swift
//  CowGoods
//
//  Created by ddn on 16/7/21.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import YYText
import Alamofire
import SVProgressHUD
import SwiftyJSON

class DDFeedbackViewController: UIViewController {

    @IBOutlet weak var textView: YYTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        
    }

    private func setupTextView() {
        textView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func back(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func send(sender: UIBarButtonItem) {
        
        print(textView.text)
        
        guard let user = DDUserModel.loadAccount() where !textView.text.isEmpty else {
            SVProgressHUD.showInfoWithStatus(inView: view, status: !textView.text.isEmpty ? "请先登录" : "内容不能为空")
            return
        }
        
        SVProgressHUD.show()
        Alamofire.request(Router.Feedback(token: user.token!, content: textView.text)).responseJSON {[weak self] (response) in
            
            var code: StatusCode = .LinkError
            var msg: String = ""
            
            if response.result.isSuccess {
                let value = JSON(response.result.value!)
                if let status = value["status"].int {
                    code = StatusCode(rawValue: status) ?? .UnknownError
                    msg = value["msgs"].stringValue
                }
            }else {
                code = .LinkError
                msg = "网络连接失败"
            }
            
            SVProgressHUD.showInfoWithStatus(msg)
            switch code {
            case .Success:
                self?.dismissViewControllerAnimated(true, completion: nil)
            default:
                break
            }
            
        }
    }
}

extension DDFeedbackViewController: YYTextViewDelegate {
    
}
