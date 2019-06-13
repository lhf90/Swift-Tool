
//
//  File.swift
//  ChinaBidding
//
//  Created by 木子 on 2019/6/6.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation
import UIKit

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
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
    }
}

extension UINavigationController : NavSwizzleMethod{
    
    static func navAwake() {
        swizzleMethod
    }
    private static let swizzleMethod : Void = {
        
        let originSelector = #selector(pushViewController(_:animated:))
        let swizzleSeletor = #selector(sw_pushViewController(_:animated:))
        swizzlingForClass(UINavigationController.self, originSelector: originSelector, swizzledSelector: swizzleSeletor)
        
    }()
    
    @objc func sw_pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        sw_pushViewController(viewController, animated: animated)
    }
}

//==============================Swizzle Method==============================
protocol SwizzleMethod {
    
    static func awake()
    static func swizzlingForClass(_ forClass : AnyClass, originSelector : Selector, swizzledSelector : Selector)
}

protocol NavSwizzleMethod {
    static func navAwake()
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

class NothingToSeeHere {
    
    static func harmlessFunctio() {
        
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SwizzleMethod.Type)?.awake()
            (types[index] as? NavSwizzleMethod.Type)?.navAwake()
        }
        types.deallocate()
    }
}

extension UIApplication {
    
    private static let runOnce : Void = {
        NothingToSeeHere.harmlessFunctio()
    }()
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}

extension DispatchQueue {
    private static var onceTracker = [String]()
    public class func once(token: String, block: () -> Void) {
        // 保证被 objc_sync_enter 和 objc_sync_exit 包裹的代码可以有序同步地执行
        objc_sync_enter(self)
        defer {// 作用域结束后执行defer中的代码
            objc_sync_exit(self)
        }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}
