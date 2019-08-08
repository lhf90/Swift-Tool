//
//  MBPrgogressHUD+Ex.swift
//  ChinaBidding
//
//  Created by 木子 on 2019/6/6.
//  Copyright © 2019 木子. All rights reserved.
//

import UIKit

extension MBProgressHUD {
    
    static func showAdded(to view: UIView, title: String?) -> MBProgressHUD {
        
        let hud = MBProgressHUD.setupHUD(to: view)
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        return hud
    }
    
    static func showTextMode(to view: UIView, title: String?) {
        let hud = MBProgressHUD.setupHUD(to: view)
        hud.mode = .text
        hud.label.text = title
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 2)
    }
    
    private static func setupHUD(to view: UIView) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        hud.contentColor = UIColor.white
        return hud
    }
    
    private static func topView() -> UIView {
        
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            
            let windows = UIApplication.shared.windows
            for temp in windows {
                if temp.windowLevel == UIWindow.Level.normal {
                    window = temp
                    break
                }
            }
        }
        return window!
    }
}
