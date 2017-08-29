//
//  MyPlanViewController.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/23.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
let MYPLANHEADHEIGHT : CGFloat = 135//首页头部
let WEEKPLANHEADHEIGHT : CGFloat = 93//康复头部
class MyPlanViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let mainTableView:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width:KSCREEN_WIDTH, height:KSCREEN_HEIGHT-64))
    let request = HomeDataManger.sharedInstance
    var homeDataModel : MyPlanHomeModel = MyPlanHomeModel()
    var currectWeekModel :latest7DaysTrainingsModel = latest7DaysTrainingsModel()//当前数据模型
    var isRelod : Bool = false//是否刷新
    var currectSection : Int = 0//当前点击的组
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar_leftBtn()
        self.naviagtionTitle(titleName: "康复详细计划")
        // Do any additional setup after loading the view.
        self.creat_tableView()
        self.getData()
    }

    // MARK: 获取数据
    func getData()  {
        weak var weakSelf = self
        request.getMyPlanViewData(complate: { (data) in

            weakSelf?.homeDataModel = data as! MyPlanHomeModel
            weakSelf?.currectSection = (weakSelf?.homeDataModel.weekOrder)!
            weakSelf?.currectWeekModel = (weakSelf?.homeDataModel.latest7DaysTrainings)!
            weakSelf?.mainTableView.reloadData()
        }, faile: {(erro) in
            if erro  == "403" {
                KFBLog(message: "账号异地登录请重新登录")
                self.KfbShowWithInfo(titleString: "账号异地登录请重新登录")
            } else {
                self.KfbShowWithInfo(titleString: erro)
            }
        })
    }
    
    override func navigationLeftBtnClick() {
        _=self.navigationController?.popViewController(animated: true)
    }
    func creat_tableView() {
        mainTableView.backgroundColor = UIColor.clear
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.tableFooterView = UIView()
        mainTableView.separatorStyle = .none
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        let weekNib = UINib(nibName: "PlanTableViewCell", bundle: nil) //每周训练cell
        mainTableView.register(weekNib, forCellReuseIdentifier: TRAINCELLID)
        let courseNib = UINib(nibName: "CourseTableViewCell", bundle: nil) //课程cell
        mainTableView.register(courseNib, forCellReuseIdentifier: COURSECELLID)
        self.view.addSubview(mainTableView)

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return currectWeekModel.recommendCourses.count
        default:
            return 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            return UITableViewCell()
        case 1:
            let cell : PlanTableViewCell  = tableView.dequeueReusableCell(withIdentifier: TRAINCELLID, for: indexPath) as! PlanTableViewCell
            var model :MyPlancourseModel = MyPlancourseModel()
            if indexPath.row < currectWeekModel.recommendCourses.count {
                model = currectWeekModel.recommendCourses[indexPath.row]
            }
            cell.setMyPlanUpUI(model: model)
            return cell
        default:
            return UITableViewCell()
            
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        switch section {
        case 0:
            let view : MyPlanHeadView = Bundle.main.loadNibNamed("MyPlanHeadView", owner: nil, options: nil)?.first as! MyPlanHeadView
            view.setUpView(model : homeDataModel)
            return view;
        case 1:
            let cell : PlanHeadView = Bundle.main.loadNibNamed("PlanHeadView", owner: nil, options: nil)?.first as! PlanHeadView
            cell.setUpUI(model: homeDataModel, isRload: isRelod)
            weak var weakSelf = self
            cell.weekBtnBlock = {(model : latest7DaysTrainingsModel,index : Int) in
                weakSelf?.currectSection = index + 1
                weakSelf?.isRelod = true
                weakSelf?.currectWeekModel = model
                weakSelf?.mainTableView.reloadData()
            }
            return cell

        default:
            return UIView()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.section {
        case 0:
            return 0
        case 1:
            return TRAINRECUREEHEIGHT
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return MYPLANHEADHEIGHT
        case 1:
            return WEEKPLANHEADHEIGHT
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row < currectWeekModel.recommendCourses.count {
            let model : MyPlancourseModel = currectWeekModel.recommendCourses[indexPath.row]
            //继续按钮文案
            if model.traintype == 0 || model.traintype == 1{
                KFBLog(message: "type1")
                //0力量训练，1稳定性训练
                //完成情况
                var isShow :Int = 0
                KFBLog(message: "当前周\(homeDataModel.weekOrder)当前选中\(currectSection)")
                if currectSection <= homeDataModel.weekOrder {
                    //之前的 可点击
                    isShow = 1
                    KFBLog(message:  "可以下载")

                } else {
                    //之后的 可点击 不显示按钮
                     isShow = 0
                     KFBLog(message:  "不可以下载")

                }
                //进入课程详情
                KFBLog(message: "进入课程详情")
                let vc = CoutrseDetialViewController()
                vc.courseID = model.courseid
                vc.courseName = model.coursename
                vc.isShowDownBtn = isShow
                self.navigationController?.pushViewController(vc, animated: true)
            } else if model.traintype == 2{
                //2治疗（一个MP4视频，只播放） getImageStr()
                let str :String = model.videourl.getImageStr()
                let videoURL = NSURL(string: str)
                let player = AVPlayer(url: videoURL! as URL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    //playerViewController.player!.play()
                }

            } else if model.traintype == 3 {
                //3建议（只展示文案，例如：冰敷）没有点击
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
