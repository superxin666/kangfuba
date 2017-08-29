//
//  RecureTableViewCell.swift
//  kangfuba
//
//  Created by lvxin on 16/10/19.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  首页第一个headview

import UIKit

class RecureTableViewCell: UITableViewCell {

    @IBOutlet weak var totlaTimeLabel: UILabel!//已经训练的总时间
    @IBOutlet weak var stableLabel: UILabel!//稳定性
    @IBOutlet weak var powerLabel: UILabel!//力量
    @IBOutlet weak var proGressView: UIView!//进度条
    @IBOutlet weak var proBackView: UIView!//进度条背景
    @IBOutlet weak var allTimeLabel: UILabel!//总训练时间
    @IBOutlet weak var allLabelpre: UILabel!//完成的百分比
    @IBOutlet weak var pronumLabel: UILabel!

    @IBOutlet weak var progressWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.proGressView.kfb_makeRadius(radius: 4)
        self.proBackView.kfb_makeRadius(radius: 4)

    }

    func setUpUIData(dataModel : HomeViewModel) {

        let str : String  = "\(dataModel.trainingTimeLen)"
//        let attributeStr = NSMutableAttributedString(string: str)
//        let str2 : String  = "min"
//        let attributeStr2 = NSMutableAttributedString(string: str2, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)])
//        let range2 : NSRange = NSRange.init(location: 0, length: str2.characters.count)
//        attributeStr2.addAttribute(NSForegroundColorAttributeName, value: GRAY999999_COLOUR, range: range2)
//        attributeStr.append(attributeStr2)
//        self.totlaTimeLabel.attributedText = attributeStr

        let width : CGFloat = str.widthWithConstrainedWidth(height: 36, font: kfbFont(36))
        let nameLabel : UILabel = UILabel(frame: CGRect(x: (KSCREEN_WIDTH - width)/2, y: 34, width: width, height: 36))
        nameLabel.textColor = green_COLOUR
        nameLabel.textAlignment = .center
        nameLabel.font = kfbFont(36)
        nameLabel.text = str
        nameLabel.backgroundColor = .clear
        self.addSubview(nameLabel)


        let minLabel : UILabel = UILabel(frame: CGRect(x: nameLabel.frame.maxX, y: 56, width: 40, height: 12))
        minLabel.textColor = GRAY999999_COLOUR
        minLabel.textAlignment = .left
        minLabel.font = UIFont.systemFont(ofSize: 12)
        minLabel.text = "min"
        self.addSubview(minLabel)

        //总训练时间
        //self.totlaTimeLabel.text = "\(dataModel.trainingTimeLen)"
        //
        self.stableLabel.text = "\(dataModel.stabilityTrainingTimes)"
        //
        self.powerLabel.text =  "\(dataModel.strengthTrainingTimes)"
        //
        //进度条
        var pro : CGFloat = 0.0
        if dataModel.trainingProgress == 0 {
            pro = 0.0
        } else {
            pro  = CGFloat(dataModel.trainingProgress)/100.0
        }

        UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.progressWidthConstraint.constant = (KSCREEN_WIDTH - 30) * pro
        }) { (ture) in

        }
        //
        self.pronumLabel.text = "\(dataModel.trainingProgress)%"
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
