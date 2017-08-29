//
//  TrainDetialTextTableViewCell.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/24.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程详情训练详情文字说明

import UIKit

class TrainDetialTextTableViewCell: UITableViewCell {

    @IBOutlet weak var detialLabel: UILabel!//详情

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpUI(text : String) {
        detialLabel.text = text
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
