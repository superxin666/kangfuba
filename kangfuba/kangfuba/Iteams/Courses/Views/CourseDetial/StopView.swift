//
//  StopView.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/11.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
protocol StopDelegate {
    func jumpStopDelegate()
}
class StopView: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegate : StopDelegate?
    @IBAction func goClick(_ sender: AnyObject) {
        self.delegate?.jumpStopDelegate()
    }
    @IBOutlet weak var actionNameLabel: UILabel!
    @IBOutlet weak var wisdomLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT)
        self.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.8)
    }

    func setUpUI(name : String , warnStr : String) {
        actionNameLabel.text = name
        wisdomLabel.text = warnStr
    }
}
