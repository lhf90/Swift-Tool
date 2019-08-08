//
//  GXLoadAnimation.swift
//  BiddingTool
//
//  Created by 木子 on 2019/5/24.
//  Copyright © 2019 木子. All rights reserved.
//

import UIKit

class GXLoadAnimation: UIView {

    func hide() {
        self.removeFromSuperview()
    }
    
    class func loadingView(with frame: CGRect, on view: UIView) -> GXLoadAnimation {
        
        var bgView = view.viewWithTag(666) as? GXLoadAnimation
        if bgView == nil {
            
            bgView = GXLoadAnimation.init(frame: frame)
            bgView!.tag = 666
            
            let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 70, height: 108))
            imgView.contentMode = .scaleAspectFit
            bgView!.addSubview(imgView)
            imgView.center = bgView!.center
            
            var images = [UIImage]()
            for i in 0 ..< 8 {
                if let image = UIImage.init(named: "loading_\(i).png") {
                    images.append(image)
                }
            }
            imgView.animationImages = images
            imgView.animationDuration = 1
            imgView.animationRepeatCount = NSIntegerMax
            imgView.startAnimating()
            view.addSubview(bgView!)
        }
        return bgView!
    }

    class func hide(from view: UIView) -> Bool {
        
        for subV in view.subviews {
            if subV.isKind(of: GXLoadAnimation.self) {
                subV.removeFromSuperview()
                return true
            }
        }
        return false
    }
    
    class func loadingView(for view: UIView) -> GXLoadAnimation? {
        
        for subV in view.subviews {
            if subV.isKind(of: GXLoadAnimation.self) {
                return subV as? GXLoadAnimation
            }
        }
        return nil
    }
    
}
