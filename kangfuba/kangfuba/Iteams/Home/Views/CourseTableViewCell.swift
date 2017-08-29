//
//  CourseTableViewCell.swift
//  kangfuba
//
//  Created by lvxin on 16/10/21.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  康复课程cell

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var expView: UIView!
    @IBOutlet weak var nameLabel: UILabel!//名字

    @IBOutlet weak var timeLabel: UILabel!//时间

    @IBOutlet weak var complateTimeLabel: UILabel!//完成次数
    @IBOutlet weak var isDownLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    let fileManger : FileManger = FileManger.sharedInstance
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpUI(data : thisWeekCourses, index : Int)  {
        if index == 0 {
            self.backgroundColor = .white
        } else {
            self.backgroundColor = LINE_COLOUR
        }
        //名字
        nameLabel.text = data.coursename
        //
        let str : String  = "\(data.timelen/60)"
        let attributeStr = NSMutableAttributedString(string: str)
        let str2 : String  = "分钟"
        let attributeStr2 = NSMutableAttributedString(string: str2, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)])
        //let range2 : NSRange = NSRange.init(location: 0, length: str2.characters.count)
        //attributeStr2.addAttribute(NSForegroundColorAttributeName, value: GRAY999999_COLOUR, range: range2)
        attributeStr.append(attributeStr2)
        timeLabel.attributedText = attributeStr
        //
        complateTimeLabel.text = "已经完成\(data.completedTotleTrainCount)次"
        //
        KFBLog(message: "课程id\(data.courseid)")
        KFBLog(message: "照片\(data.pic)")
        let urlStr :String = data.pic.getImageStr()
        KFBLog(message: "外部\(urlStr)")
        let url : URL = URL.init(string: urlStr)!
        bgImageView.setImageWith(url, placeholderImage: #imageLiteral(resourceName: "course_placeholder_big"))
        //data.expertsInterpretUrl  = "adsfadsfas"
        if data.expertsInterpretUrl.characters.count > 0 {
            //显示专家讲解
            expView.isHidden = false
        } else {
            //显示是否下载
            let isok : Bool = fileManger.findValue(coursid: String(data.courseid))
            if isok {
                isDownLabel.isHidden = false
            } else {
                isDownLabel.isHidden = true
            }

        }

    }


    func setUpStrengtUI(data : recommendStrengthenCoursesModel,index : Int)  {
        if index == 0 {
            self.backgroundColor = .white
        } else {
            self.backgroundColor = LINE_COLOUR
        }
        //名字
        nameLabel.text = data.coursename
        //
        let str : String  = "\(data.timelen/60)"
        let attributeStr = NSMutableAttributedString(string: str)
        let str2 : String  = "分钟"
        let attributeStr2 = NSMutableAttributedString(string: str2, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)])
        //let range2 : NSRange = NSRange.init(location: 0, length: str2.characters.count)
        //attributeStr2.addAttribute(NSForegroundColorAttributeName, value: GRAY999999_COLOUR, range: range2)
        attributeStr.append(attributeStr2)
        timeLabel.attributedText = attributeStr
//        timeLabel.text = "\(data.timelen/60)"
        //
        complateTimeLabel.text = "已经完成\(data.completedTotleTrainCount)次"
        //
        KFBLog(message: "课程id\(data.courseid)")
        KFBLog(message: "照片\(data.pic)")
        let urlStr :String = data.pic.getImageStr()
        KFBLog(message: "外部\(urlStr)")
        let url : URL = URL.init(string: urlStr)!

        bgImageView.setImageWith(url, placeholderImage: #imageLiteral(resourceName: "course_placeholder_big"))
        let isok : Bool = fileManger.findValue(coursid: String(data.courseid))
        if isok {
            isDownLabel.isHidden = false
        } else {
            isDownLabel.isHidden = true
        }
    }
    
}
