//
//  SubCourseCollectionViewCell.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/24.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class SubCourseCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUI(model : SubCourseList)  {
        self.kfb_makeRadius(radius: 4)
        //背景图片
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: iteam, height: iteam))
        imageView.setImageWith(URL.init(string: model.smallpic.getImageStr())!, placeholderImage: UIImage(named: "course_placeholder"))
        imageView.kfb_makeRadius(radius: 4)
        self.contentView.addSubview(imageView)
        //背景
        let backView : UIView = UIView.init(frame: CGRect(x: 0, y: iteam/3*2, width: iteam, height: iteam/3))
        backView.backgroundColor = .black
        backView.alpha = 0.6
        self.contentView.addSubview(backView)
        //名字
        let nameLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 10, width: iteam, height: 12))
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.text = model.coursename
        backView.addSubview(nameLabel)


        let str : String  = "\(model.timelen)"
        let attributeStr = NSMutableAttributedString(string: str)
        let str2 : String  = "分钟"
        let attributeStr2 = NSMutableAttributedString(string: str2, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 10)])
        let range2 : NSRange = NSRange.init(location: 0, length: str2.characters.count)
        attributeStr2.addAttribute(NSForegroundColorAttributeName, value: KFBColorFromRGB(rgbValue: 0xffffff), range: range2)
        attributeStr.append(attributeStr2)


//        self.totlaTimeLabel.attributedText = attributeStr
        //时间
        let timeLabel : UILabel = UILabel(frame: CGRect(x: 0, y: nameLabel.frame.maxY + 9, width: iteam, height: 10))
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = GREEN_COLOUR
        timeLabel.textAlignment = .center
        //timeLabel.text = "\(model.timelen)"
        timeLabel.attributedText = attributeStr
        backView.addSubview(timeLabel)
//
//        let timeNameLabel : UILabel = UILabel(frame: CGRect(x: timeLabel.frame.maxX, y: nameLabel.frame.maxY + 9, width: 25, height: 10))
//        timeNameLabel.font = UIFont.systemFont(ofSize: 10)
//        timeNameLabel.textAlignment = .left
//        timeNameLabel.textColor = .white
//        timeNameLabel.text = "分钟"
//        backView.addSubview(timeNameLabel)
    }

}
