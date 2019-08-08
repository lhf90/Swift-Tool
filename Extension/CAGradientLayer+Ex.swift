//
//  CAGradientLayer+Ex.swift
//  BiddingTool
//
//  Created by 木子 on 2019/2/28.
//  Copyright © 2019 木子. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    static func gradientColor(startColor: UIColor, endColor: UIColor, frame: CGRect) -> CAGradientLayer{
        
        let gradientColors = [startColor.cgColor, endColor.cgColor]
        let layer = CAGradientLayer.init()
        layer.colors = gradientColors
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }
    
    //获取彩虹渐变层
    static func rainbowLayer() -> CAGradientLayer {
        //定义渐变的颜色（7种彩虹色）
        let gradientColors = [UIColor.red.cgColor,
                              UIColor.orange.cgColor,
                              UIColor.yellow.cgColor,
                              UIColor.green.cgColor,
                              UIColor.cyan.cgColor,
                              UIColor.blue.cgColor,
                              UIColor.purple.cgColor]
        let layer = CAGradientLayer.init()
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 0.17, 0.33, 0.5, 0.67, 0.83, 1.0]
        //创建CAGradientLayer对象并设置参数
        layer.colors = gradientColors
        layer.locations = gradientLocations
        //设置渲染的起始结束位置（横向渐变）
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }
}
