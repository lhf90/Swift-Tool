//
//  UIWindow+Ex.swift
//  ChinaBidding
//
//  Created by 木子 on 2019/6/6.
//  Copyright © 2019 木子. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func jx_layoutInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            let safeAreaInsets: UIEdgeInsets = self.safeAreaInsets
            if safeAreaInsets.bottom > 0 {
                //参考文章：https://mp.weixin.qq.com/s/Ik2zBox3_w0jwfVuQUJAUw
                return safeAreaInsets
            }
            return UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func jx_navigationHeight() -> CGFloat {
        let statusBarHeight = jx_layoutInsets().top
        return statusBarHeight + 44
    }
}
