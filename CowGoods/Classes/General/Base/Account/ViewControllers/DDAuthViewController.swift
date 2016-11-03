//
//  DDAuthViewController.swift
//  CowGoods
//
//  Created by ddn on 16/6/20.
//  Copyright © 2016年 ddn. All rights reserved.
//

import UIKit
import SVProgressHUD

class DDAuthViewController: UIViewController {
    
    var front: Bool = false
    
    var viewModel = DDAuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        let rightItem1 = UIBarButtonItem(title: "认证", style: .Done, target: self, action: #selector(clickOnRightItem1(_:)))
        
        let rightItem2 = UIBarButtonItem(title: "正面", style: .Done, target: self, action: #selector(clickOnRightItem2(_:)))
        
        let rightItem3 = UIBarButtonItem(title: "反面", style: .Done, target: self, action: #selector(clickOnRightItem3(_:)))
        
        
        navigationItem.rightBarButtonItems = [rightItem1, rightItem2, rightItem3]
    }
    
    func clickOnRightItem1(item: UIBarButtonItem) {
        
        SVProgressHUD.show(inView: view)
        viewModel.makeAuth(name: "张三", National_ID: "546231547785325524") { [weak viewModel, weak self] () in
            if let viewModel = viewModel {
                switch viewModel.code {
                case .Success:
                    SVProgressHUD.showSuccessWithStatus(inView: self?.view, status: viewModel.msg)
                default:
                    SVProgressHUD.showErrorWithStatus(inView: self?.view, status: viewModel.msg)
                }
            }else {
                SVProgressHUD.dismiss(fromView: self?.view)
            }
        }
    }
    
    func clickOnRightItem2(item: UIBarButtonItem) {
        self.front = true
        choosePicker()
    }
    
    func clickOnRightItem3(item: UIBarButtonItem) {
        self.front = false
        choosePicker()
    }
    
    func choosePicker() {
        let alertSheet = UIAlertController(title: "请选择", message: "", preferredStyle: .ActionSheet)
        
        let camera = UIAlertAction(title: "相机", style: .Default) { (action) in
            let imageVc = UIImagePickerController()
            
            imageVc.sourceType = .Camera
            imageVc.delegate = self
            imageVc.allowsEditing = true
            self.presentViewController(imageVc, animated: true, completion: nil)
        }
        
        let photos = UIAlertAction(title: "相册", style: .Default) { (action) in
            let imageVc = UIImagePickerController()
            
            imageVc.sourceType = .SavedPhotosAlbum
            imageVc.delegate = self
            imageVc.allowsEditing = true
            self.presentViewController(imageVc, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "取消", style: .Destructive) { (_) in
            alertSheet.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertSheet.addAction(camera)
        alertSheet.addAction(photos)
        alertSheet.addAction(cancel)
        
        self.presentViewController(alertSheet, animated: true, completion: nil)
    }
}

extension DDAuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let scale = image.size.height / image.size.width
        
        if let image = image.imageByResizeToSize(CGSizeMake(230, 230 * scale)) {
        
            picker.dismissViewControllerAnimated(true) {
                
                SVProgressHUD.show(inView: self.view)
                
                self.viewModel.uploadCard(image, front: self.front, completion: { [weak self] () in
                    if let viewModel = self?.viewModel {
                        switch viewModel.code {
                        case .Success:
                            SVProgressHUD.showSuccessWithStatus(inView: self?.view, status: viewModel.msg)
                        default:
                            SVProgressHUD.showErrorWithStatus(inView: self?.view, status: viewModel.msg)
                        }
                    }else {
                        SVProgressHUD.dismiss(fromView: self?.view)
                    }
                })
            }
        }
    }
}
