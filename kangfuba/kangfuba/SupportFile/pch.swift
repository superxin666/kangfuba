//
//  pch.swift
//  kangfuba
//
//  Created by lvxin on 16/10/12.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
//MARK:屏幕尺寸
let KSCREEN_WIDTH = UIScreen.main.bounds.size.width
let KSCREEN_HEIGHT = UIScreen.main.bounds.size.height
let LNAVIGATION_HEIGHT = 44+20

var ip6 = { (num : Int) ->  CGFloat in
    return CGFloat(num)/375 * CGFloat(KSCREEN_WIDTH)
}

var kfbFont = { (num : Int) ->  UIFont in
    return  UIFont.init(name: "GIORGIO SANS", size: CGFloat(num))!
}

//MARK:判断ios系统
let IS_IOS7 = (UIDevice.current.systemVersion as NSString).doubleValue >= 7.0
let IS_IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
let IS_IOS9 = (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0
let IS_IOS10 = (UIDevice.current.systemVersion as NSString).doubleValue >= 10.0

let IS_IPHONE6P = UIScreen.main.bounds.size.height > 568
//MARK:颜色
//页面背景
let BACKVIEW_COLOUR = UIColor.white
let GREEN_COLOUR = KFBColorFromRGB(rgbValue: 0x41ceae)//绿色
let LINE_COLOUR =  KFBColorFromRGB(rgbValue: 0xeeeeee)//分割线颜色
let GRAY999999_COLOUR =  KFBColorFromRGB(rgbValue: 0x999999)//小标题
let GRAY656A72_COLOUR =  KFBColorFromRGB(rgbValue: 0x656A72)//大标题
let GRAY8E8E8E_COLOUR =  KFBColorFromRGB(rgbValue: 0x8e8e8e)//
let GRAYD8D8D8_COLOUR =  KFBColorFromRGB(rgbValue: 0xD8D8D8)//
let GRAYDDDDDD_COLOUR =  KFBColorFromRGB(rgbValue: 0xDDDDDD)//

let MAIN_GREEN_COLOUR = KFBColor(red: 144, green: 153, blue: 167, alpha: 1)
let green_COLOUR = KFBColor(red: 65, green: 206, blue: 174, alpha: 1)

let DARK_COLOUR_SELECTED = KFBColor(red: 101, green: 106, blue: 114, alpha: 1)
/// 输入三色值返回颜色
///
/// - parameter red:   红的
/// - parameter green: 绿
/// - parameter blue:  蓝
/// - parameter alpha: 透明度
///
/// - returns: UIColor
func KFBColor(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: 174/255.0, alpha: alpha)
}

/// 输入16进制返回颜色
///
/// - parameter rgbValue: 16进制颜色
///
/// - returns: UIColor
func KFBColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//自定义调试信息打印
func KFBLog<T>(message : T, file : String = #file, lineNumber : Int = #line) {
    
    //#if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]- \(message)")
        
    //#endif
}
