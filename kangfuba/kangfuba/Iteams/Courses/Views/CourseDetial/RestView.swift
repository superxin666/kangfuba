//
//  RestView.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/10.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
protocol RestDelegate {
    func jumpRestDelegate()
}

class RestView: UIView {

    var delegate : RestDelegate?
    @IBOutlet weak var timeLabelBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nestActionLabel: UILabel!
    @IBOutlet weak var jumpBtn: UIButton!
    @IBOutlet weak var restTimeLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT)
        self.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.8)
        self.jumpBtn.kfb_makeRadius(radius: 5)
        self.timeLabelBtn.titleLabel?.textAlignment = .center

    }
    @IBOutlet weak var second: UILabel!
    @IBAction func jumpClick(_ sender: Any) {
        KFBLog(message: "跳过休息点击")
        self.delegate?.jumpRestDelegate()
    }
    @IBAction func secondGesClick(_ sender: Any) {
        KFBLog(message: "跳过休息点击")
        self.delegate?.jumpRestDelegate()
    }



    @IBAction func nestActionClick(_ sender: Any) {
        KFBLog(message: "跳过休息点击")
        self.delegate?.jumpRestDelegate()
    }

    @IBAction func jumpRestClick(_ sender: Any) {
        KFBLog(message: "跳过休息点击")
        self.delegate?.jumpRestDelegate()
    }
    func setUpUI(title : String, actionName : String)  {
        self.titleLabel.text = title
        self.nestActionLabel.text = actionName
    }
    func setSecond(num : Int)  {
        //self.timeLabelBtn.setTitle("\(num)", for: .normal)
        self.restTimeLabel.text = "\(num)"
    }

}
