//
//  PlanTableViewCell.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/15.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//   康复日程---每周康复计划cell

import UIKit
typealias PlanCellBlock = (_ model : recommendCourses)->()
class PlanTableViewCell: UITableViewCell {

    @IBOutlet weak var leaveImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    var currectModel : recommendCourses!
    var goGoBlock : PlanCellBlock!
    var lookVideoBlock:PlanCellBlock!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //我的计划
    func setMyPlanUpUI(model : MyPlancourseModel){
        backImageView.image = #imageLiteral(resourceName: "home_plancell")
        titleLabel.text = model.coursename
        leaveImageView.setImageWith(URL.init(string: model.iconpic.getImageStr())!, placeholderImage: UIImage.init(named: "home_lever1"))

    }

    
    //首页
    func setUpUI(model : recommendCourses ,index:Int) {
        backImageView.image = #imageLiteral(resourceName: "home_plancell")
        titleLabel.isHidden = false
        leaveImageView.isHidden = false
        goBtn.isHidden = false

        currectModel  = model
        //名字
        titleLabel.text = model.coursename
        leaveImageView.setImageWith(URL.init(string: model.iconpic.getImageStr())!, placeholderImage: UIImage.init(named: "home_lever1"))
        //继续按钮文案
        KFBLog(message: "")
        if model.traintype == 0 || model.traintype == 1{
             KFBLog(message: "type1")
            //0力量训练，1稳定性训练
            //完成情况
            if model.completeNumToday > 0{
                //完成
                 KFBLog(message: "已完成")
                goBtn.setTitle("DONE", for: .normal)
                goBtn.setTitleColor( .white, for: .normal)
                goBtn.isEnabled = false
                goBtn.setBackgroundImage(#imageLiteral(resourceName: "home_plan_compate"), for: .normal)
            } else{
                //没有完成
                KFBLog(message: "开始训练")
                goBtn.setTitle("START", for: .normal)
                goBtn.setTitleColor(green_COLOUR, for: .normal)
                goBtn.setBackgroundImage(#imageLiteral(resourceName: "home_currectweekbtn_normal"), for: .normal)
                goBtn.isEnabled = true
                goBtn.isHidden = false
                goBtn.addTarget(self, action: #selector(PlanTableViewCell.goClick), for: .touchUpInside)

            }
        } else if model.traintype == 2{
            //2治疗（一个MP4视频，只播放）
            KFBLog(message: "type2")
            goBtn.isEnabled = true
            goBtn.isHidden = false
             KFBLog(message: "查看演示")
            goBtn.setTitle("查看演示", for: .normal)
            goBtn.setTitleColor(GRAY999999_COLOUR, for: .normal)
            goBtn.setBackgroundImage(#imageLiteral(resourceName: "home_plan_go"), for: .normal)
            goBtn.addTarget(self, action: #selector(PlanTableViewCell.goClick), for: .touchUpInside)
        } else if model.traintype == 3 {
            //3建议（只展示文案，例如：冰敷）
             KFBLog(message: "type3")
            KFBLog(message: "没有")
            goBtn.isHidden = true
        }
    }

    func setNoPlanView()  {
        goBtn.isHidden = true
        titleLabel.isHidden = true
        leaveImageView.isHidden = true
        backImageView.image = #imageLiteral(resourceName: "home_noPlans")
    }

    func goClick() {
        MobClick.event("015")
        if let _ = goGoBlock {
            KFBLog(message: "1111")
            goGoBlock(currectModel)
        }
    }

}
