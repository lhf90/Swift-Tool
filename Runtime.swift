//
//  RunTime.swift
//  CaiYunPlatform
//
//  Created by 木子 on 2019/2/19.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation
import UIKit

protocol SwizzleMethod {
    
    static func awake()
    static func swizzlingForClass(_ forClass : AnyClass, originSelector : Selector, swizzledSelector : Selector)
}

extension SwizzleMethod {
    
    static func swizzlingForClass(_ forClass : AnyClass, originSelector : Selector, swizzledSelector : Selector) {
        
        let originMethod = class_getInstanceMethod(forClass, originSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        guard (originMethod != nil && swizzledMethod != nil)  else {
            return
        }
        if class_addMethod(forClass, originSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originMethod!), method_getTypeEncoding(originMethod!))
        } else {
            method_exchangeImplementations(originMethod!, swizzledMethod!)
        }
    }
}

class NotihingToSeeHere {
    
    static func harmlessFunctio() {
        
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SwizzleMethod.Type)?.awake()
        }
        types.deallocate()
    }
}

extension UIApplication {
    
    private static let runOnce : Void = {
        NotihingToSeeHere.harmlessFunctio()
    }()
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}

//MARK: - viewDidLoad 隐藏返回文字
extension UIViewController : SwizzleMethod {
    
    static func awake() {
        swizzleMethod
    }
    private static let swizzleMethod : Void = {
     
        let originSelector = #selector(viewDidLoad)
        let swizzleSeletor = #selector(sw_viewDidLoad)
        swizzlingForClass(UIViewController.self, originSelector: originSelector, swizzledSelector: swizzleSeletor)
        
    }()
    
    @objc func sw_viewDidLoad() {
        sw_viewDidLoad()
        self.view.backgroundColor = UIColor.backColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
    }
}
