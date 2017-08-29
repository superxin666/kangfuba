//
//  StopView_LAN.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/3.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
protocol StopView_LANDelegate {
    func jumpStopDelegate_LAN()
}

class StopView_LAN: UIView {
    var timeBtn :UIButton!//倒计时按钮
    var restLabel : UILabel!//休息
    var actionLabel : UILabel!//当前动作
    var delegate:StopView_LANDelegate?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.8)
        timeBtn = UIButton(frame: CGRect(x:(KSCREEN_WIDTH - 90)/2, y:  (KSCREEN_HEIGHT - 90)/2, width: 90, height: 90))
        timeBtn.setImage(#imageLiteral(resourceName: "course_reststar"), for: .normal)
        timeBtn.addTarget(self, action: #selector(StopView_LAN.jumpGes), for: .touchUpInside)
        self.addSubview(timeBtn)

        restLabel = UILabel(frame: CGRect(x: (KSCREEN_WIDTH - 100)/2-70, y: (KSCREEN_HEIGHT - 100)/2+50, width: 100, height: 15))
        restLabel.textColor = .white
        restLabel.textAlignment = .center
        restLabel.font = UIFont.systemFont(ofSize: 15)
        restLabel.isUserInteractionEnabled = true
        restLabel.text = "暂停中..."
        self.addSubview(restLabel)

        actionLabel = UILabel(frame: CGRect(x: (KSCREEN_WIDTH - 200)/2-100, y: (KSCREEN_HEIGHT - 200)/2+100, width: 200, height: 15))
        actionLabel.textColor = .white
        actionLabel.textAlignment = .center
        actionLabel.font = UIFont.systemFont(ofSize: 15)
        //nestActionLabel.text = "下一个动作：做自作自"
        self.addSubview(actionLabel)

        timeBtn.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        restLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        actionLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))

        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StopView_LAN.jumpGes))
        restLabel.addGestureRecognizer(tap)

    }
    func jumpGes() {
        self.delegate?.jumpStopDelegate_LAN()
    }

    func setUpUI(name : String) {
        actionLabel.text = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
