//
//  UIViewController+Nib.swift
//  kangfuba
//
//  Created by lvxin on 16/10/17.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

/*
 直接加载 xib，创建 ViewController

 - returns: UIViewController
 */
extension UIViewController{
    class func initFromNib() -> UIViewController {

        let hasNib: Bool = Bundle.main.path(forResource:String(describing: type(of:self)), ofType: "xib") != nil
        print(String(describing: type(of:self)))
        guard hasNib else {
            assert(!hasNib, "Invalid parameter") // here
            return UIViewController()
        }
        return self.init(nibName: String(describing: type(of:self)), bundle: Bundle.main)
    }
}
