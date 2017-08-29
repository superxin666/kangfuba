//
//  RestView_LAN.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/19.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
protocol RestView_LANDelegate {
    func jumpRestDelegate_lan()
}
class RestView_LAN: UIView {
    var timeBtn :UIButton!//倒计时按钮
    var restLabel : UILabel!//休息
    var nestActionLabel : UILabel!//下一个动作
    var jumpRestAction : UIButton!//跳过休息
    var delegate : RestView_LANDelegate?
    func jumpClick() {
        self.delegate?.jumpRestDelegate_lan()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.8)
        timeBtn = UIButton(frame: CGRect(x:(KSCREEN_WIDTH - 90)/2, y:  (KSCREEN_HEIGHT - 90)/2, width: 90, height: 90))
        timeBtn.backgroundColor = GREEN_COLOUR
        timeBtn.titleLabel?.font = kfbFont(64)
        timeBtn.kfb_makeRound()
        self.addSubview(timeBtn)

        jumpRestAction = UIButton(frame: CGRect(x:(KSCREEN_WIDTH - 60), y:  (KSCREEN_HEIGHT - 75), width: 60, height: 15))
        jumpRestAction.backgroundColor = .clear
        jumpRestAction.titleLabel?.textAlignment = .right
        jumpRestAction.addTarget(self, action: #selector(RestView_LAN.jumpClick), for: .touchUpInside)
        jumpRestAction.setTitle("跳过休息", for: .normal)
        jumpRestAction.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(jumpRestAction)

        restLabel = UILabel(frame: CGRect(x: (KSCREEN_WIDTH - 100)/2-70, y: (KSCREEN_HEIGHT - 100)/2+50, width: 100, height: 15))
        restLabel.textColor = .white
        restLabel.textAlignment = .center
        restLabel.font = UIFont.systemFont(ofSize: 15)
        restLabel.text = "休息一下吧..."
        self.addSubview(restLabel)
        nestActionLabel = UILabel(frame: CGRect(x: (KSCREEN_WIDTH - 200)/2-100, y: (KSCREEN_HEIGHT - 200)/2+100, width: 200, height: 15))
        nestActionLabel.textColor = .white
        nestActionLabel.textAlignment = .center
        nestActionLabel.font = UIFont.systemFont(ofSize: 15)
        //nestActionLabel.text = "下一个动作：做自作自"
        self.addSubview(nestActionLabel)

        timeBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        jumpRestAction.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        restLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        nestActionLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))

        
    }

    func setSecond(num : Int) {
        timeBtn.setTitle("\(num)", for: .normal)
    }
    func setTitle(name : String) {
        nestActionLabel.text = "\(name)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
