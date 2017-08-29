//
//  UIView+clipping.swift
//  kangfuba
//
//  Created by lvxin on 16/10/14.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  UIView 以及子类的圆角剪切等

import UIKit

extension UIView {

    /// 给视图添加边框
    ///
    /// - parameter width: 宽度
    /// - parameter color: 颜色
    func kfb_makeBorderWithBorderWidth(width:CGFloat , color:UIColor ){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    /// 给视图添加边框和圆角
    ///
    /// - parameter width:  宽度
    /// - parameter color:  颜色
    /// - parameter radius: 圆角角度
    func kfb_makeBorderAndRadius(width:CGFloat , color:UIColor ,radius:CGFloat){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
 
    }

    /// 添加圆角
    ///
    /// - parameter radius: 角度
    func kfb_makeRadius(radius:CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }


    /// 圆
    func kfb_makeRound() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }

}
