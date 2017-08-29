//
//  MyPlanHeadView.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/23.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  我的康复详细计划headView

import UIKit

class MyPlanHeadView: UIView {

    @IBOutlet weak var numLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setUpView(model : MyPlanHomeModel) {
        let str : String  = "\(model.dayNumRemaining)"
        let attributeStr = NSMutableAttributedString(string: str)
        let str2 : String  = "天"
        let attributeStr2 = NSMutableAttributedString(string: str2, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)])
        let range2 : NSRange = NSRange.init(location: 0, length: str2.characters.count)
        attributeStr2.addAttribute(NSForegroundColorAttributeName, value: GRAY656A72_COLOUR, range: range2)
        attributeStr.append(attributeStr2)
        self.numLabel.attributedText = attributeStr
//        self.numLabel.text = "\(model.dayNumRemaining)"
    }
}
