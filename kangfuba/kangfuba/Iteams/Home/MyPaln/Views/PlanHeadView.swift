//
//  PlanHeadView.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/14.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  我的康复日程---每周康复计划headcell

import UIKit
import Spring
typealias PlanHeadBlock = (_ model : latest7DaysTrainingsModel,_ index : Int) -> ()
class PlanHeadView: UIView,UIScrollViewDelegate {
    var weekBtnBlock : PlanHeadBlock!
    var dataModel : MyPlanHomeModel!
    var currectSigalview : UIImageView = UIImageView()
//
//
    static var selectedBtn : Int = 100//记录选择的状态

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weekScrollView: UIScrollView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    var timeLabel :UILabel!//时间
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        //名字
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        titleLabel.text = "康复计划";
//        titleLabel.textColor = GRAY656A72_COLOUR
//        titleLabel.font = UIFont.systemFont(ofSize: 15)
//        self.addSubview(titleLabel)
//        //时间
//        let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        timeLabel.text = "康复计划";
//        timeLabel.textColor = GRAY656A72_COLOUR
//        timeLabel.font = UIFont.systemFont(ofSize: 15)
//        self.addSubview(timeLabel)
//
//
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    func setUpUI(model : MyPlanHomeModel, isRload : Bool) {
        dataModel = model
        //初始化时间是当前周的时间
        if isRload {
            //更新时间title
            let model = model.other7DaysTraings[PlanHeadView.selectedBtn]
            let  rect : CGPoint = timeLabel.frame.origin
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 50, initialSpringVelocity: 2, options: .allowAnimatedContent, animations: {
                self.timeLabel.frame = CGRect(origin: rect, size: CGSize(width: 0, height: 0))
                //箭头位置
                KFBLog(message: "第几个\(PlanHeadView.selectedBtn)")
                let btnX : Int = PlanHeadView.selectedBtn * 65 + 20
                self.currectSigalview.frame = CGRect(x: btnX, y: 23, width: 10, height: 5)
                self.weekScrollView.contentOffset = CGPoint(x: PlanHeadView.selectedBtn * 65, y: 0)
                self.weekScrollView.addSubview(self.currectSigalview)
            }, completion: {(bool) in
                self.timeLabel.text = model.title
                self.timeLabel.frame = CGRect(origin: rect, size: CGSize(width: 100, height: 18))
                
            })
        } else {
            //第一次进入
            PlanHeadView.selectedBtn = 100
            //当前周
            weekScrollView.contentOffset = CGPoint(x: 65 * (model.weekOrder-1), y: 0)
            weekScrollView.delegate = self
            //时间
            timeLabel.text = model.latest7DaysTrainings.title
        }

        //排列按钮
        weekScrollView.contentSize = CGSize(width: 65 * model.other7DaysTraings.count, height: 20)
        weekScrollView.isPagingEnabled = true
        let appedn = 15
        let btnWidth = 50
        let btnHeight = 20
        for i in 0..<model.other7DaysTraings.count {
            let btn: UIButton = UIButton(type: .custom)
            btn.tag = i
            btn.frame = CGRect(x: i * (appedn + btnWidth) , y: 0, width: btnWidth, height: btnHeight)
            btn.setTitle("Week \(i+1)", for: .normal)
            btn.backgroundColor = .white
            //箭头
            let arrowBtn: UIButton = UIButton(type: .custom)
            arrowBtn.tag = i

            arrowBtn.frame = CGRect(x: (i * (appedn + btnWidth))+20 , y: Int(btn.frame.maxY+4), width: 10, height: 5)
            arrowBtn.setBackgroundImage(#imageLiteral(resourceName: "head_planHead_upar"), for: .normal)
            //arrowBtn.backgroundColor = .red
            if i ==  model.weekOrder-1{
                btn .setTitleColor(green_COLOUR, for: .normal)
                btn .setBackgroundImage(#imageLiteral(resourceName: "home_currectweekbtn_normal"), for: .normal)
                btn.setBackgroundImage(#imageLiteral(resourceName: "home_weekBtn_selected"), for: .selected)
                arrowBtn.isHidden = false
                if PlanHeadView.selectedBtn < 100 {
                    arrowBtn.isHidden = true
                } 

            } else {
                btn .setTitleColor(GRAY999999_COLOUR, for: .normal)
                btn.setBackgroundImage(#imageLiteral(resourceName: "home_weekbtn_normal"), for: .normal)
                btn.setBackgroundImage(#imageLiteral(resourceName: "home_weekBtn_selected"), for: .selected)
                arrowBtn.isHidden = true
            }
            if  PlanHeadView.selectedBtn == i{
                btn.isSelected = true
                arrowBtn.isHidden = false
            }
            btn .setTitleColor(.white, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.titleLabel?.textAlignment = .left
            btn.addTarget(self, action: #selector(PlanHeadView.weekBtnClick), for: .touchUpInside)


            weekScrollView.addSubview(arrowBtn)
            weekScrollView.addSubview(btn)
        }


    }
//
    func weekBtnClick(sender : UIButton) {
        if sender.isSelected {
            return
        }
        //更新当前按钮状态
        sender.isSelected = !sender.isSelected
        //闭包更新对应的模型
        let currectTag = sender.tag
        PlanHeadView.selectedBtn = currectTag
        let model = dataModel.other7DaysTraings[currectTag]
        if let _ = weekBtnBlock {
            weekBtnBlock(model,sender.tag)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }

}
