//
//  HomeViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/13.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import MJRefresh
import AVKit
import AVFoundation
let SECTIONNUM_TABLEVIEW = 3
//高度
let RECUREHEIGHT : CGFloat = 160//首页头部
let WEEKRECUREHEIGHT : CGFloat = 111//周训练headview
let TRAINRECUREEHEIGHT : CGFloat = 78//本周训练情况
let RECOMENDHEIGHT : CGFloat = 42//推荐训练课程
let COURSEHEIGHT : CGFloat = 132//课程

let INJUREHEADHEIGHT : CGFloat = ip6(70) + 82//运动项目头部
//cell id
let TRAINCELLID = "PLANCELL_ID"//本周训练
let COURSECELLID = "RECOMMENCELL_ID"//课程


class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    //tableView
    let _mainTableView:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width:KSCREEN_WIDTH, height:KSCREEN_HEIGHT-64))
    let request = HomeDataManger.sharedInstance
    var homeDataModel : HomeViewModel = HomeViewModel()
    var tadayPlanModels : [recommendCourses]  = []//今天康复计划
    var instylenNum : Int = 100 //类型默认为0主要用于标示首页展示形式：0：用户有方案展示训练情况，1：用户没方案但是有最常参加的体育运动，-1：二无青年

    //var currectWeekModel :TrainsModel = TrainsModel()//当前数据模型
    var isReloadPlanHeadView : Bool = false//默认不是刷新
    override func viewWillAppear(_ animated: Bool) {
        header.beginRefreshing()
       // KFBLog(message: "viewWillAppear")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.naviagtionTitle(titleName: "Recova")
        self.navigationTitleImage(image: #imageLiteral(resourceName: "home_titileimage"))
        self.navigationBar_rightBtn_title(image: #imageLiteral(resourceName: "home_rightnaviga"))
        self.creat_tableView()
        KFBLog(message: "viewDidLoad")

       

    }
    override func navigationBar_rightBtn_title(image:UIImage){
        let btn:UIButton = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action:#selector(BaseViewController.navigationRightBtnClick), for: .touchUpInside)
        let item:UIBarButtonItem = UIBarButtonItem(customView:btn)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,action: nil)
        spacer.width = -15;
        self.navigationItem.rightBarButtonItems = [spacer,item]
    }
    func creat_tableView() {
        _mainTableView.backgroundColor = UIColor.clear
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = UIView()
        _mainTableView.separatorStyle = .none
        _mainTableView.showsVerticalScrollIndicator = false
        _mainTableView.showsHorizontalScrollIndicator = false
        _mainTableView.mj_header = header
        header.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.headerRefresh))
        let weekNib = UINib(nibName: "PlanTableViewCell", bundle: nil) //每周训练cell
        _mainTableView.register(weekNib, forCellReuseIdentifier: TRAINCELLID)
        let courseNib = UINib(nibName: "CourseTableViewCell", bundle: nil) //课程cell
        _mainTableView.register(courseNib, forCellReuseIdentifier: COURSECELLID)
        self.view.addSubview(_mainTableView)

    }
     // MARK: 获取数据
    func getData()  {
        weak var weakSelf = self
        request.getHomeViewData(complate: { (data) in
            weakSelf?.homeDataModel = data as! HomeViewModel
            //weakSelf?.instylenNum = (weakSelf?.homeDataModel.indexStyle)!
            if weakSelf?.homeDataModel.indexStyle == -1 {
                // MARK: 对接提示诊断
                weakSelf?._mainTableView.mj_header.endRefreshing()

                let alertController = UIAlertController(title: "您还没有康复方案呢", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "马上进行伤病检测", style: .default, handler: {
                    (action: UIAlertAction) -> Void in
                    
                    let vc:InguryGuideViewController = InguryGuideViewController()
                    vc.hidesBottomBarWhenPushed = true
                    vc.FromId = 0
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)


            } else if weakSelf?.homeDataModel.indexStyle == 0{
                //有方案的
                let tadayNum : Int = Int(String.getDayIndex())
                let model : thisWeekPlansModel =  (weakSelf?.homeDataModel.thisWeekPlans[tadayNum])!
                model.state = true
                weakSelf?.tadayPlanModels = model.recommendCourses
                weakSelf?._mainTableView.reloadData()
                weakSelf?._mainTableView.mj_header.endRefreshing()
            } else {
                //常用运动的

                weakSelf?._mainTableView.reloadData()
                weakSelf?._mainTableView.mj_header.endRefreshing()
            }


        }, faile: {(erro) in
             weakSelf?._mainTableView.mj_header.endRefreshing()
            if erro  == "403" {
                KFBLog(message: "账号异地登录请重新登录")
                self.KfbShowWithInfo(titleString: "账号异地登录请重新登录")
            } else {
                self.KfbShowWithInfo(titleString: erro)
            }

        })
    }
     // MARK: 刷新
    func headerRefresh() {
        KFBLog(message: "上啦刷新")
        isReloadPlanHeadView = false
        self.getData()
    }

    // MARK: tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return SECTIONNUM_TABLEVIEW;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            if homeDataModel.indexStyle == 1 {
                return 0
            } else {
                let num = tadayPlanModels.count
                return num>0 ? tadayPlanModels.count : 1
            }

        case 2:
            if homeDataModel.indexStyle == 1 {
                return homeDataModel.recommendStrengthenCourses.count
            } else {
                return homeDataModel.thisWeekCourses.count
            }

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
            //let cell : PlanTableViewCell = Bundle.main.loadNibNamed("PlanTableViewCell", owner: nil, options: nil)?.first as! PlanTableViewCell
            if indexPath.row < tadayPlanModels.count {
                weak var weakself = self
                cell.setUpUI(model: tadayPlanModels[indexPath.row], index:indexPath.row)
                cell.goGoBlock = {(model) in
                    if model.traintype == 0 || model.traintype == 1 {
                        //进入课程详情
                        KFBLog(message: "进入课程详情")
                        let vc = CoutrseDetialViewController()
                        vc.isShowDownBtn = 1
                        vc.courseID = model.courseid
                        vc.courseName = model.coursename
                        vc.hidesBottomBarWhenPushed = true

                        weakself?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        KFBLog(message: "看视频")
//                        let vc = VideoViewController()
//                        vc.hidesBottomBarWhenPushed = true
//                        weakself?.navigationController?.pushViewController(vc, animated: true)
                        if model.videourl.characters.count > 0 {
                            let str :String = model.videourl.getImageStr()
                            let videoURL = NSURL(string: str)
                            let player = AVPlayer(url: videoURL! as URL)
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = player
                            self.present(playerViewController, animated: true) {
                                //playerViewController.player!.play()
                            }
                        } else {
                            weakself?.KfbShowWithInfo(titleString: "视频正在制作中，敬请期待")
                        }

                    }
                }
            } else {
                cell.setNoPlanView()

            }
            return cell
        case 2:
            let cell : CourseTableViewCell  = tableView.dequeueReusableCell(withIdentifier: COURSECELLID, for: indexPath) as! CourseTableViewCell
            if homeDataModel.indexStyle == 1 {
                if indexPath.row < homeDataModel.recommendStrengthenCourses.count{
                    cell.setUpStrengtUI(data: homeDataModel.recommendStrengthenCourses[indexPath.row],index:Int(indexPath.row))
                }
                return cell
            } else {
                if indexPath.row < homeDataModel.thisWeekCourses.count{
                    cell.setUpUI(data: homeDataModel.thisWeekCourses[indexPath.row],index:Int(indexPath.row))
                }
                return cell
            }



        default:
            return UITableViewCell()

        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        switch section {
        case 0:
            let cell : RecureTableViewCell = Bundle.main.loadNibNamed("RecureTableViewCell", owner: nil, options: nil)?.first as! RecureTableViewCell
            cell.setUpUIData(dataModel: homeDataModel)
            return cell;
        case 1:
            if homeDataModel.indexStyle == 1 {
                let view : InjureHeadView = Bundle.main.loadNibNamed("InjureHeadView", owner: nil, options: nil)?.first as! InjureHeadView
                view.setUpUI(model: homeDataModel)
                view.InjuryHeadBlock = {(model : commonInjuriesModel) in
                    MobClick.event("031")
                    KFBLog(message: "id\(model.commonInjuryId)")
                    let vc : InjureDetialViewController = InjureDetialViewController()
                    vc.openUrl = model.contentUrl
                    vc.titleString = model.name
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return view
            } else {
                let cell : HomePlanHeadView = Bundle.main.loadNibNamed("HomePlanHeadView", owner: nil, options: nil)?.first as! HomePlanHeadView
                let weakSelf = self
                cell.setday(model: homeDataModel)
                cell.weekBtnBlock = {(model : thisWeekPlansModel)in
                    weakSelf.tadayPlanModels = model.recommendCourses
                    let indexSet:NSIndexSet = NSIndexSet(index:1)
                    weakSelf._mainTableView.reloadSections(indexSet as IndexSet, with: UITableViewRowAnimation.fade)
                }
                cell.myPlanBlock = {()in
                    let vc : MyPlanViewController = MyPlanViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)

                }
                return cell
            }

        case 2:
            let cell : RecommendCourseView = Bundle.main.loadNibNamed("RecommendCourseView", owner: nil, options: nil)?.first as! RecommendCourseView
            cell.setUpUI(style:homeDataModel.indexStyle)
            return cell;
        default:
            return UIView()
        }


    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MobClick.event("016")
        if indexPath.section == 2 {
            KFBLog(message: "didSelectRowAt")
            let vc = CoutrseDetialViewController()

            if homeDataModel.indexStyle == 1 {
                var model : recommendStrengthenCoursesModel = recommendStrengthenCoursesModel()
                if indexPath.row < homeDataModel.recommendStrengthenCourses.count {
                    model = homeDataModel.recommendStrengthenCourses[indexPath.row]
                    vc.hidesBottomBarWhenPushed = true
                    vc.isShowDownBtn = 1
                    vc.courseID = model.courseid
                    vc.courseName = model.coursename
                    self.navigationController?.pushViewController(vc, animated: true)
                }


            } else {

                var model : thisWeekCourses = thisWeekCourses()
                if indexPath.row < homeDataModel.thisWeekCourses.count {
                    model = homeDataModel.thisWeekCourses[indexPath.row]
                    if model.expertsInterpretUrl.characters.count > 0 {
                        let str :String = model.expertsInterpretUrl.getImageStr()
                        let videoURL = NSURL(string: str)
                        let player = AVPlayer(url: videoURL! as URL)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self.present(playerViewController, animated: true) {
                            //playerViewController.player!.play()
                        }

                    } else {
                        vc.hidesBottomBarWhenPushed = true
                        vc.isShowDownBtn = 1
                        vc.courseID = model.courseid
                        vc.courseName = model.coursename
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }

            }
            
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.section {
        case 0:
            return 0
        case 1:

            if indexPath.row == tadayPlanModels.count - 1 || (indexPath.row == 0 && tadayPlanModels.count==0){
                return  TRAINRECUREEHEIGHT + 12
            } else {
                return TRAINRECUREEHEIGHT
            }

        case 2:
            return COURSEHEIGHT
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return RECUREHEIGHT
        case 1:
            if homeDataModel.indexStyle == 1 {
                return INJUREHEADHEIGHT
            } else {
                return WEEKRECUREHEIGHT
            }

        case 2:
            return RECOMENDHEIGHT
        default:
            return 0
        }
    }
    
    override func navigationRightBtnClick(){
        MobClick.event("013")
        if self.homeDataModel.indexStyle == 0 {
            let vc:MyRecurePlanViewController = MyRecurePlanViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.newProgram = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(self.homeDataModel.indexStyle == 1){
            let vc:NoRecurePlanViewController = NoRecurePlanViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            KfbShowWithInfo(titleString: "还没有您的康复方案")
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
