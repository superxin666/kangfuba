//
//  SportsDetailCollectionViewCell.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/12/30.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class SportsDetailCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSportsUI(model : SportsDetailModel)  {
    
        self.backgroundColor = UIColor.white
        //背景
        let backView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: ip6(65), height: ip6(65)))
        backView.kfb_makeRadius(radius: 5)
        backView.backgroundColor = KFBColorFromRGB(rgbValue: 0xF0F0F0)
        self.contentView.addSubview(backView)
        
        //图片
        let imageView = UIImageView(frame: CGRect(x: ip6(15), y: ip6(15), width: ip6(35), height: ip6(35)))
        if model.selected == 0 {
            imageView.setImageWith(URL.init(string: model.iconPic.getImageStr())!, placeholderImage: UIImage(named: "course_placeholder"))
        }else{
            imageView.setImageWith(URL.init(string: model.iconPicSelected.getImageStr())!, placeholderImage: UIImage(named: "course_placeholder"))
        }

        self.contentView.addSubview(imageView)
        
        //名字
        let nameLabel : UILabel = UILabel(frame: CGRect(x: 0, y: ip6(70), width: ip6(65), height: ip6(20)))
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = GRAY656A72_COLOUR
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = model.menuName
        self.contentView.addSubview(nameLabel)
        
    }

}
