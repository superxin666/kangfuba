//
//  HeadTableViewCell.swift
//  kangfuba
//
//  Created by lvxin on 16/10/22.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程详情头部cell

import UIKit

class HeadTableViewCell: UITableViewCell {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpUI(model : CourseDetialModel)  {
        //
        bgImageView.setImageWith(URL.init(string: model.toppic.getImageStr())!, placeholderImage: UIImage.init(named: "course_placeholder_big"))
        timesLabel.text = "\(model.completedTotleTrainCount)"
        if model.timelen > 0 {
            KFBLog(message: "时间\(String(format: "%.1f",model.timelen/60))")
           timeLabel.text = String(format: "%.0f",model.timelen/60)
        } else {
            timeLabel.text = "0"
        }

        actionLabel.text = "\(model.groupNum)"

    }
    
}
