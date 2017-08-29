//
//  KFBTextField.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/22.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class KFBTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: bounds.origin.x, y: bounds.origin.y + 3, width: bounds.size.width, height: bounds.size.height)
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
         return CGRect(x: bounds.origin.x, y: bounds.origin.y + 3, width: bounds.size.width, height: bounds.size.height)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
          return CGRect(x: bounds.origin.x, y: bounds.origin.y - 3, width: bounds.size.width, height: bounds.size.height)
    }
}


