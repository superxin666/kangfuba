//
//  OptionsTableViewCell.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/24.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程详情注意事项

import UIKit

class OptionsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpUI(arr : [String],type : Int)  {
        //标题
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 15, width: 80, height: 15))
        if type == 0 {
            titleLabel.text = "课程说明"
        } else {
            titleLabel.text = "注意事项"
        }

        titleLabel.textColor = GRAY656A72_COLOUR
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(titleLabel)
        if arr.count > 0 {
            //选项
            for index in 0...arr.count - 1 {
                let backView = UIView(frame: CGRect(x: 30, y: (titleLabel.frame.maxY + 15) + (CGFloat)(index * 30), width: KSCREEN_WIDTH - 60, height: 30))
                backView.backgroundColor = .clear
                //绿色点
                let view = UIView(frame: CGRect(x: 0, y: 4.5, width: 6, height: 6))
                view.kfb_makeRound()
                view.backgroundColor = green_COLOUR
                backView.addSubview(view)
                //文字
                let str = arr[index]
                let height : CGFloat = str.heightWithConstrainedWidth(width: KSCREEN_WIDTH - 60, font: UIFont.systemFont(ofSize: 12))
                let nameLabel = UILabel(frame: CGRect(x: view.frame.maxX + 5, y: 0, width: KSCREEN_WIDTH - 60, height: height))
                nameLabel.text = str
                nameLabel.numberOfLines = -1
                nameLabel.textColor = GRAY656A72_COLOUR
                nameLabel.font = UIFont.systemFont(ofSize: 12)
                nameLabel.textAlignment  = .left
                //nameLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH - 60, height: 30), limitedToNumberOfLines: -1)
                nameLabel.backgroundColor = .clear
                backView.addSubview(nameLabel)
                self.addSubview(backView)
                
            }
        }
    }

}
