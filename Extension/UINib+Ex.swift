//
//  UINib+Ex.swift
//  BiddingTool
//
//  Created by 木子 on 2019/2/20.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation

protocol NibLoadable {
    
}

extension NibLoadable where Self: UIView {
    
    static func loadNibView(_ nibName: String? = nil) -> Self {
        return Bundle.main.loadNibNamed(nibName ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}
