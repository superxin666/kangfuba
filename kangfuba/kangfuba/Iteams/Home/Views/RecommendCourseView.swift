//
//  RecommendCourseView.swift
//  kangfuba
//
//  Created by lvxin on 16/10/21.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  康复课程课程headview

import UIKit

class RecommendCourseView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setUpUI(style : Int)  {
        if style == 1 {
            titleLabel.text = "推荐强化课程"
        } else {
            titleLabel.text = "本周课程详情"
        }
    }

}
