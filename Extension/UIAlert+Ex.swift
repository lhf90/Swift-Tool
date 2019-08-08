//
//  UIAlert+Ex.swift
//  ChinaBidding
//
//  Created by 木子 on 2019/6/10.
//  Copyright © 2019 木子. All rights reserved.
//

import UIKit.UIAlertController

extension UIAlertController {
    
    static func show(title: String?, message: String? = nil, presentVC: UIViewController) {
        
        UIAlertController.show(title: title, message: message, defaultTitle: nil, cancelTitle: "确定", presentVC: presentVC)
    }
    
    static func show(title: String?, message: String? = nil, defaultTitle: String? = "确定", defaultAction: ((UIAlertAction) -> Void)? = nil, cancelTitle: String? = "取消", cancelAction: ((UIAlertAction) -> Void)? = nil, presentVC: UIViewController) {
        
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if defaultTitle != nil {
            alertVC.addAction(UIAlertAction.init(title: defaultTitle, style: .default, handler: defaultAction))
        }
        alertVC.addAction(UIAlertAction.init(title: cancelTitle, style: .cancel, handler: cancelAction))
        presentVC.present(alertVC, animated: true, completion: nil)
    }
}
