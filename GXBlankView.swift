//
//  GXBlankView.swift
//  BiddingTool
//
//  Created by 木子 on 2019/5/14.
//  Copyright © 2019 木子. All rights reserved.
//

import UIKit

class GXBlankView: UIView {

    typealias Completion = () -> ()
    var completion: Completion?
    
    static func show(on superView: UIView, with text:String?, completion: Completion?) {
        
        let blank = GXBlankView.init(frame: superView.bounds,text: text, completion: completion)
        superView.addSubview(blank)
    }
    
    init(frame: CGRect, text: String?, completion: Completion?) {
        super.init(frame: frame)
        self.completion = completion
        setupUI(text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(text: String?) {
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(singleTapAction)))
        
        self.backgroundColor = UIColor.backColor
        let imageView = UIImageView.init(image: UIImage.gif(name: "empty_image_gif"))
        imageView.frame = CGRect(x: 0, y: 0, width: 180, height: 130)
        imageView.center  = self.center
        self.addSubview(imageView)
        
        let label = UILabel.init(frame: CGRect(x: 20, y: imageView.frame.maxY + 20, width: self.width - 40, height: 20))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor  = UIColor.darkGray
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    @objc func singleTapAction() {
        
        if completion == nil {
            return
        }
        completion!()
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (handler) in
            self.removeFromSuperview()
        }
    }
    
}
