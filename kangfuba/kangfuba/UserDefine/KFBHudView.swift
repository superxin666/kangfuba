//
//  KFBHudView.swift
//  kangfuba
//
//  Created by lvxin on 16/10/21.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class KFBHudView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var titleLabel = UILabel()//标题
    func showTopHudView(title:String) {
        self.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: 34.5)
        self.backgroundColor = MAIN_GREEN_COLOUR
        
    }

}
