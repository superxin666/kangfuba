//
//  ActionCollectionViewCell.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/24.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程详情动作图片 UICollectionViewCell 

import UIKit

class ActionCollectionViewCell: UICollectionViewCell {
    var imageView :UIImageView!
    var label : UILabel!


    override init(frame: CGRect) {
        super.init(frame: frame)
        //图片
        imageView = UIImageView(frame: CGRect(x: 0, y: 15, width: ip6(90), height: ip6(50)))
        self.contentView.addSubview(imageView)
        //名字
        label = UILabel(frame: CGRect(x: 0, y: imageView.frame.maxY + 3, width: self.frame.size.width, height: ip6(25)))
        label.font = UIFont.systemFont(ofSize: ip6(10))
        label.numberOfLines = -1
        label.textAlignment = .center
        label.textColor = GRAY999999_COLOUR
        self.contentView.addSubview(label)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUI(nameStr : String, picStr : String)  {
         imageView.setImageWith(URL.init(string: picStr.getImageStr())!, placeholderImage: UIImage.init(named: "course_placeholder_mid"))
         label.text = nameStr
    }
}
