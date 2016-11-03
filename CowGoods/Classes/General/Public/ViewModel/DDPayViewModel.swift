//
//  DDPayViewModel.swift
//  CowGoods
//
//  Created by ddn on 16/7/11.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import Alamofire

class DDPayViewModel: DDBaseViewModel {
    
    var order: DDOrderModel?
    
    private var wxpayCompletion: (Void->Void)?
    
    var sectionCount: Int {
        return 2
    }
    
    override init() {
        super.init()
        
        NSDC.addObserver(self, selector: #selector(weixinPayResult(_:)), name: WXPayNotification, object: nil)
    }
    
    deinit {
        NSDC.removeObserver(self)
    }
    
    func rowCount(section section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 3
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1)
        lineView.frame = CGRect(x: 0, y: 0, width: tableView.width, height: 0.3)
        view.addSubview(lineView)
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return cellForSectionOne(tableView, cellForRow: indexPath.row)
        default:
            return cellForSectionTwo(tableView, cellForRow: indexPath.row)
        }
    }
    
    private func cellForSectionOne(tableView: UITableView, cellForRow row: Int) ->UITableViewCell {
        var cell: UITableViewCell? = nil
        cell = tableView.dequeueReusableCellWithIdentifier("section_one")
        if cell == nil {
            if row == 0 {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "section_one_one")
            }else {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: "section_one_other")
            }
            cell?.textLabel?.font = 24.fitFont()
            cell?.detailTextLabel?.font = 20.fitFont()
        }
        switch row {
        case 0:
            cell?.textLabel?.text = "采购订单已生成!"
            cell?.textLabel?.textAlignment = .Center
            cell?.userInteractionEnabled = false
        case 1:
            cell?.textLabel?.text = "订单金额"
            cell?.detailTextLabel?.text = "¥ " + order!.price
            cell?.detailTextLabel?.textColor = UIColor.redColor()
            cell?.textLabel?.textAlignment = .Natural
            cell?.userInteractionEnabled = false
        case 2:
            cell?.textLabel?.text = "订单编号：" + order!.id
            cell?.textLabel?.textAlignment = .Natural
            cell?.detailTextLabel?.text = nil
            cell?.userInteractionEnabled = false
        default:
            break
        }
        return cell!
    }
    
    private func cellForSectionTwo(tableView: UITableView, cellForRow row: Int) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        cell = tableView.dequeueReusableCellWithIdentifier("section_two")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "section_two")
            cell?.textLabel?.font = 24.fitFont()
            cell?.detailTextLabel?.font = 20.fitFont()
            cell?.detailTextLabel?.textColor = UIColor.grayColor()
        }
        switch row {
        case 0:
            cell?.accessoryType = .None
            cell?.textLabel?.text = "请选择支付方式："
            cell?.userInteractionEnabled = false
            cell?.accessoryType = .None
            cell?.detailTextLabel?.text = nil
        case 1:
            cell?.accessoryType = .DisclosureIndicator
            cell?.userInteractionEnabled = true
            cell?.textLabel?.text = "微信支付"
            cell?.detailTextLabel?.text = "微信安全支付"
        case 2:
            cell?.accessoryType = .DisclosureIndicator
            cell?.userInteractionEnabled = true
            cell?.textLabel?.text = "支付宝支付"
            cell?.detailTextLabel?.text = "支付宝安全支付"
        default:
            break
        }
        return cell!
    }
    
    func payForAli(completion: ()->Void) {
        
        if order == nil {
            code = .OrderError
            msg = "订单有误"
            completion()
            return
        }
        
        let aliOrder = Order()
        
        aliOrder.service = "mobile.securitypay.pay"
        aliOrder.paymentType = "1"
        aliOrder.inputCharset = "utf-8"
        aliOrder.itBPay = "30m"
        aliOrder.showURL = "m.alipay.com"
        aliOrder.appID = nil
        
        aliOrder.subject = order?.title
        aliOrder.body = order?.content
        aliOrder.outTradeNO = order?.id
        aliOrder.notifyURL = order?.url
        aliOrder.showURL = ""
        
        
        let orderSpec = aliOrder.description
        
        let signer = RSADataSigner(privateKey: AlipayPrivateKey)
        let signedString = signer.signString(orderSpec)
        
        let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\""
        
        print(orderString)
        
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: AppScheme) { [weak self] (result) in
            if let ws = self {
                print(result)
                
                if let resultStatus = result["resultStatus"] as? String {
                    if resultStatus == "9000" {
                        ws.code = .Success
                        ws.msg = "支付成功"
                    }
                }
                ws.code = .UnknownError
                ws.msg = "支付失败"
                completion()
            }else {
                completion()
            }
        }
    }
    
    func parForWx(completion: ()->Void) {
        //获取pre订单
        
        //失败
        code = .OrderError
        msg = "订单有误"
        completion()
        
        //成功
        
        let prepay = DDWXPrePayModel()
        
        let req = PayReq()
        req.openID = prepay.appID
        req.partnerId = prepay.partnerID
        req.prepayId = prepay.prepayID
        req.nonceStr = prepay.noncestr
        req.timeStamp = UInt32(prepay.timestamp)!
        req.package = prepay.package
        req.sign = prepay.sign
        
        WXApi.sendReq(req)
        
        wxpayCompletion = completion
        
        print("appid=\(req.openID)\npartid=\(req.partnerId)\nprepayid=\(req.prepayId)\nnoncestr=\(req.nonceStr)\ntimestamp=\(req.timeStamp)\npackage=\(req.package)\nsign=\(req.sign)")
    }
    
    func weixinPayResult(notify: NSNotification) {
        
        print(notify)
        
        if let completion = wxpayCompletion {
            completion()
        }
    }
}








