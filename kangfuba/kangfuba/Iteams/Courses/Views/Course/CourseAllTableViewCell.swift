//
//  CourseAllTableViewCell.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/24.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class CourseAllTableViewCell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func sutUpUI(dataModel : CourseListModel)  {
        bgImageView.setImageWith(URL.init(string: dataModel.pic.getImageStr())!, placeholderImage: UIImage.init(named: "home_commendcourse"))
        nameLabel.text = dataModel.typename
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
