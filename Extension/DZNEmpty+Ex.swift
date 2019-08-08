//
//  DZNEmpty+Ex.swift
//  BiddingTool
//
//  Created by 木子 on 2019/2/21.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation
import UIKit.UIViewController

extension UITableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.backColor
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
    }
    
    private struct AssociatedKey {
        static var key = "associatedKey"
    }
    
    var isLoading: Bool {
        get {
            if let isLoading = objc_getAssociatedObject(self, &AssociatedKey.key) as? Bool {
                return isLoading
            }
            return false
        }
        set {
            if isLoading == newValue {
                return
            } else {
                objc_setAssociatedObject(self, &AssociatedKey.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
                self.tableView.reloadEmptyDataSet()
            }
        }
    }
    
    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        if  self.isLoading{
            return UIImage.init(named: "empty_image_loading")
        } else {
            return UIImage.gif(name: "empty_image_gif")
        }
    }
    
    public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        if self.isLoading {
            return NSAttributedString.init(string: "加载中", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                                                             NSAttributedString.Key.foregroundColor : UIColor.black])
        } else {
            return NSAttributedString.init(string: "暂无数据", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                                                                             NSAttributedString.Key.foregroundColor : UIColor.black])
        }
    }
    
//    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
//        if self.isLoading {
//            return nil
//        } else {
//            return NSAttributedString.init(string: "点击重试", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
//                                                                             NSAttributedString.Key.foregroundColor : UIColor.white])
//        }
//    }
//
//    public func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
//        if self.isLoading {
//            return nil
//        } else {
//            return UIImage(named: "empty_button_background")?.resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), resizingMode: .stretch).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -110, bottom: 0, right: -110))
//        }
//    }
    
    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 18
    }

    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return self.isLoading
    }
    
    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(.pi / 2, 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.repeatCount = MAXFLOAT
        animation.isCumulative = true
        return animation
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        
    }
    
}
