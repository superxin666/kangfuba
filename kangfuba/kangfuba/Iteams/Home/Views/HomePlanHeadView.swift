//
//  HomePlanHeadView.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/22.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  康复计划头部

import UIKit
typealias HomePlanHeadViewBlock = (_ model : thisWeekPlansModel) -> ()
typealias HomePlanMyPlanViewBlock = () -> ()
class HomePlanHeadView: UIView {
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var btnsBackView: UIView!

    var homeModel : HomeViewModel = HomeViewModel()
    var weekBtnBlock : HomePlanHeadViewBlock!
    var myPlanBlock : HomePlanMyPlanViewBlock!
    var dayIndex : Int!//周几
    var btnArr : [UIButton] = []//数组
    var arrowArr : [UIButton] = []//数组
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
//        KFBLog(message: "当前时间\(String.getDayStr())周几\(String.getDayIndex())")
        dayIndex = String.getDayIndex()
        //添加按钮
        let  subviewWidth : CGFloat = 30
        let  subviewHeight : CGFloat = 60
        let  append : CGFloat = (KSCREEN_WIDTH - 30-210)/8
        if  btnArr.count>0{
            btnArr.removeAll()
        }
        if  arrowArr.count>0{
            arrowArr.removeAll()
        }
        for i in 0...6 {
            let subView : UIView = UIView(frame: CGRect(x: append + CGFloat(i)*(subviewWidth+append), y: 0, width: subviewWidth, height: subviewHeight))
            subView.backgroundColor = .clear
//            subView.isUserInteractionEnabled = true
//            subView.tag = i
//            let gap : UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(self.viewClcik(ges:)))
//            subView.addGestureRecognizer(gap)
            //周几
            let weekLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 8, width: subviewWidth, height: 12))
            weekLabel.font = UIFont.systemFont(ofSize: 12)
            weekLabel.textAlignment = .center

            //日子
            let dayBtn : UIButton = UIButton(type: .custom)
            dayBtn.tag = i
            dayBtn.frame = CGRect(x: 0, y: weekLabel.frame.maxY , width: 30, height: 30)
            dayBtn.kfb_makeRound()
//            dayBtn.setTitle("30", for: .normal)
            dayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            dayBtn.titleLabel?.textAlignment = .center
            dayBtn.addTarget(self, action: #selector(self.dayClcik(sender:)), for: .touchUpInside)
            btnArr.append(dayBtn)
            //箭头
            //箭头
            let arrowBtn: UIButton = UIButton(type: .custom)
            arrowBtn.tag = i
            arrowBtn.frame = CGRect(x: 10 , y: 55.5, width: 10, height: 5)
            arrowBtn.setBackgroundImage(#imageLiteral(resourceName: "head_planHead_upar"), for: .normal)
            arrowBtn.isHidden = true
            arrowArr.append(arrowBtn)
            if dayIndex == i {
                weekLabel.text = "今"
                weekLabel.textColor = green_COLOUR
                dayBtn.setBackgroundImage(#imageLiteral(resourceName: "home_circle"), for: .selected)
                dayBtn.setBackgroundImage(#imageLiteral(resourceName: "home_circle"), for: .normal)
                dayBtn.setTitleColor(.white, for: .selected)
                dayBtn.setTitleColor(.white, for: .normal)

            } else {
                weekLabel.text = dayStr(num: i)
                weekLabel.textColor = GRAY999999_COLOUR
                dayBtn.setBackgroundImage(#imageLiteral(resourceName: "home_circlegray"), for: .selected)
                dayBtn.setBackgroundImage(#imageLiteral(resourceName: "home_circle_white"), for: .normal)
                dayBtn.setTitleColor(GRAY999999_COLOUR, for: .normal)
                dayBtn.setTitleColor(GRAY999999_COLOUR, for: .selected)
            }

            subView.addSubview(weekLabel)
            subView.addSubview(arrowBtn)
            subView.addSubview(dayBtn)
            btnsBackView.addSubview(subView)
        }
    }

    func setday(model : HomeViewModel)  {
        homeModel = model
        var dayNum : String = "";
        if model.thisWeekPlans.count>0 {
            for i in 0...6 {
                let btn : UIButton = btnArr[i]
                let arrowbtn : UIButton = arrowArr[i]
                let model : thisWeekPlansModel = model.thisWeekPlans[i]
                if model.state {
                    btn.isSelected = true
                    arrowbtn.isHidden = false
                    dayNum = model.dateStr
                } else {
                    btn.isSelected = false
                    arrowbtn.isHidden = true
                }
                btn.setTitle(String.getDayStr(day: model.dateStr), for: .normal)
            }
            timeTitleLabel.text = dayNum

        }
    }

    func viewClcik(ges : UIGestureRecognizer)  {

    }


    func dayClcik(sender: UIButton)  {
        if sender.isSelected {
            return
        }
        sender.isSelected = !sender.isSelected
        var selectedModel : thisWeekPlansModel = thisWeekPlansModel()
        for i in 0..<homeModel.thisWeekPlans.count {
            let model : thisWeekPlansModel = homeModel.thisWeekPlans[i]
            if i == sender.tag {
                model.state = true
                selectedModel = model
            } else {
                model.state = false
            }
        }
        if let _ = weekBtnBlock  {
            weekBtnBlock(selectedModel)
        }

    }
    func dayStr(num : Int) -> String {
        switch num {
        case 0:
            return "一"
        case 1:
            return "二"
        case 2:
            return "三"
        case 3:
            return "四"

        case 4:
            return "五"

        case 5:
            return "六"

        case 6:
            return "日"
        default:
            return ""
        }
    }

    @IBAction func MyPlanBtnClick(_ sender: Any) {
        MobClick.event("014")
        if let _ = myPlanBlock  {
            myPlanBlock()
        }
    }
}
