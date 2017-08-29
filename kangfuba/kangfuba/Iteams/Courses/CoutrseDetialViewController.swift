//
//  CoutrseDetialViewController.swift
//  kangfuba
//
//  Created by lvxin on 2016/10/22.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  课程详情页

import UIKit
import AFNetworking
import Spring
let HEADCELLHEIGHT :CGFloat = KSCREEN_WIDTH/5*2 + 74 //头部cell
let ACTIONCELLHEIGHT :CGFloat =  ip6(103) + 10 //动作cell
var DETIALCELLHEIGHT :Int = 30 //详情说明
var OPTIONCELLHEIGHT :Int = 30 //详情说明

class CoutrseDetialViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {
    let _mainTableView:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width:KSCREEN_WIDTH, height:KSCREEN_HEIGHT - ip6(110)))
    var isShowDownBtn : Int!//是否显示下载按钮
    let request = CourseDataManger.sharedInstance
    var dataModel = CourseDetialWapModel()
    var alertController : UIAlertController!
    var optionArr :[String] = []//注意事项
    var desArr :[String] = []//详情
    var courseID : Int!//课程id
    var courseName : String!//课程id
    var textStr :String = ""//训练详情
    var joinBtn : UIButton!
    let fileManger : FileManger = FileManger.sharedInstance//文件管理
    var isDownload : Bool = false//是否下载了gif
    var isWanw :Bool = false//是否为手机流量
    var isWanwNum :Int = 0//网络状态
    var proLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: 50))//进度显示
    var isDownIng :Bool = false//判断是不是在当前页面下载

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.creat_tableView()//tableview

        self.navigationBar_leftBtn()//左边返回键
        self.naviagtionTitle(titleName: courseName)
        isDownload = fileManger.findValue(coursid: String(courseID))
        KFBLog(message: "是否下载了\(isDownload)")
        self.joinBtnUI()
        weak var weakSelf = self
        //检测网络状态给提示 是否下载
        request.startMonitoring { (data) in
            let num : Int = data as! Int
            KFBLog(message: "网络状况\(num)")
            weakSelf?.isWanwNum = num
        }
        request.getCourseDetialData(courseId: courseID, complate: {(data) in
            weakSelf?.dataModel = data as! CourseDetialWapModel
            //底部参加按钮
            if weakSelf?.dataModel.data.isSelected == -1{
                //本身是推荐课程 没有参加和退出 直接进入课程
                weakSelf?.joinBtn.addTarget(self, action: #selector(CoutrseDetialViewController.checkWIFI), for: .touchUpInside)
            } else if weakSelf?.dataModel.data.isSelected == 0 {
                //该课程不是推荐课程 资源参加 但是没有参加（需要参加提示）
                weakSelf?.joinBtn.addTarget(self, action: #selector(CoutrseDetialViewController.joinCourseNotcce), for: .touchUpInside)
            } else if  weakSelf?.dataModel.data.isSelected == 1{
                //该课程不是推荐课程 资源参加 但是参加了（需要参加提示）
                self.navigationBar_rightBtn_title(name: "退出", textColour: GREEN_COLOUR)
                weakSelf?.joinBtn.addTarget(self, action: #selector(CoutrseDetialViewController.joinCourseNotcce), for: .touchUpInside)
            } else {
                //强化课程直接训练
                 weakSelf?.joinBtn.addTarget(self, action: #selector(CoutrseDetialViewController.checkWIFI), for: .touchUpInside)

            }
            //详情
//            weakSelf?.textStr = (weakSelf?.dataModel.data.des)!
//            DETIALCELLHEIGHT = 60 + (weakSelf?.textStr.heightWithConstrainedWidth(width: KSCREEN_WIDTH - 60, font: UIFont.systemFont(ofSize: 12)))!
            KFBLog(message: "注意\(weakSelf?.dataModel.data.des)")
            weakSelf?.desArr = (weakSelf?.dataModel.data.des.components(separatedBy:"***"))!
            DETIALCELLHEIGHT = 30 + ((weakSelf?.desArr.count)! * 30)

            //注意事项
            KFBLog(message: "注意\(weakSelf?.dataModel.data.attentions)")
            weakSelf?.optionArr = (weakSelf?.dataModel.data.attentions.components(separatedBy:"***"))!
            OPTIONCELLHEIGHT = 30 + ((weakSelf?.optionArr.count)! * 30)
            weakSelf?._mainTableView.reloadData()

        }, faile: {(erro) in

            weakSelf?.KfbShowWithInfo(titleString: erro)
            
        })
    }
    override func navigationLeftBtnClick() {
        self.isDownIng = false
        self.joinBtn.isEnabled = true
        _=self.navigationController?.popViewController(animated: true)
    }

    override func navigationRightBtnClick() {
        weak var weakSelf = self
        //退出视频
        alertController = UIAlertController(title: "", message: "退出后，首页将不会显示此课程，之前的训练记录仍会被记住", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            //取消
            self.alertController.dismiss(animated: true, completion: {

            })
        }
        let sureAction = UIAlertAction(title: "退出课程", style: .default) { (action) in
            //退出视频
            weakSelf?.request.cancleCourse(courseId: (weakSelf?.courseID)!, complate: {(data) in
                let  model : LoginModel = data as! LoginModel
                if model.status > 0 {
                    KFBLog(message: "退出成功")
                    _=weakSelf?.navigationController?.popViewController(animated: true)
                }
            }, faile: {(erro) in
                weakSelf?.KfbShowWithInfo(titleString: erro )

            })

        }
        alertController.addAction(cancleAction)
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func joinCourseNotcce()  {
        alertController = UIAlertController(title: "", message: "该课程不在康复方案内，盲目练习存在风险，建议您按计划训练", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            //取消
            self.alertController.dismiss(animated: true, completion: {

            })
        }
        let sureAction = UIAlertAction(title: "继续参加", style: .default) { (action) in
            //继续参加
            self.joinClick()
        }
        alertController.addAction(cancleAction)
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)

    }

    // MARK: UI
    func creat_tableView() {
        _mainTableView.backgroundColor = UIColor.clear
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = UIView()
        _mainTableView.separatorStyle = .none
        _mainTableView.showsVerticalScrollIndicator = false
        _mainTableView.showsHorizontalScrollIndicator = false
        self.view.addSubview(_mainTableView)
    }
    // MARK: 参加课程点击按钮
    func joinBtnUI() {
        joinBtn = UIButton(type: .custom)
        joinBtn.isUserInteractionEnabled = true

        joinBtn.frame = CGRect(x: 0, y: KSCREEN_HEIGHT-45-64, width: KSCREEN_WIDTH, height: 45)
        joinBtn.backgroundColor = GREEN_COLOUR
        if isDownload {
            joinBtn.setTitle("开始训练", for: .normal)
        } else {
            joinBtn.setTitle("参加该训练课程", for: .normal)
        }
        KFBLog(message: "课程详情页面\(isShowDownBtn)")
        self.view.addSubview(joinBtn)
        if  isShowDownBtn > 0 {
            joinBtn.isUserInteractionEnabled = true
        } else {
            joinBtn.isUserInteractionEnabled = false
            joinBtn.setTitle("暂无法开始该课程", for: .normal)
        }

    }

    // MARK: 参加课程点击
    func joinClick()  {
        weak var weakSelf = self

        if dataModel.data.isSelected == 0 {

            //没有参加 先参加在下载
            weakSelf?.request.joinCourse(courseId: courseID, complate: {(data) in
                let model :LoginModel = data as! LoginModel
                 MobClick.event("019")
                if model.status == 1{
                    KFBLog(message: "参加成功")
                    //参加成功后 下载
                    weakSelf?.checkWIFI()
                } else {
                    KFBLog(message: model.msg)
                }
            }, faile: {(erro) in
                weakSelf?.KfbShowWithInfo(titleString: erro)
            })


        } else {
            //参加了 直接下载
            weakSelf?.downGif()
        }
    }

    //  MARK: 下载GiF 网络监测
    func checkWIFI()  {
        KFBLog(message: "按钮点击")
        MobClick.event("019")
//        joinBtn.setTitle("正在下载...", for: .normal)
        //if isDownload {
        //    self.downGif()
        //} else {
            weak var weakSelf = self
            if isWanwNum == 1 {
                alertController = UIAlertController(title: "", message: "当前你正在使用移动网络，继续下载将消耗流量", preferredStyle: .alert)
                let cancleAction = UIAlertAction(title: "停止下载", style: .cancel) { (action) in
                    //取消
                    self.alertController.dismiss(animated: true, completion: {
                        weakSelf?.joinBtn.setTitle("参加该训练课程", for: .normal)
                    })
                }
                let sureAction = UIAlertAction(title: "继续下载", style: .default) { (action) in
                    //取消下载
                    weakSelf?.downGif()
                }
                alertController.addAction(cancleAction)
                alertController.addAction(sureAction)
                self.present(alertController, animated: true, completion: nil)
            } else if isWanwNum == 0{
                KfbShowWithInfo(titleString: "失去网络")
                alertController = UIAlertController(title: "", message: "网络中断，请检查您的网络", preferredStyle: .alert)
                let cancleAction = UIAlertAction(title: "确定", style: .cancel) { (action) in
                    //取消
                      self.joinBtn.setTitle("参加该训练课程", for: .normal)
                    self.alertController.dismiss(animated: true, completion: {

                    })
                }
                alertController.addAction(cancleAction)
                self.present(alertController, animated: true, completion: nil)

            } else {
                 weakSelf?.downGif()
            }
        //}


    }

    // MARK: 下载Gif
    func downGif()  {
        MobClick.event("030")
        isDownIng = true
        //下载GIF

        self.joinBtn.isEnabled = false
        weak var weakSelf = self
        var num :Int = 0

        //先下载背景音乐
        if !((weakSelf?.dataModel.data.courseActGifs.count)! > 0) {
            KfbShowWithInfo(titleString: "当前课程还有具体动作，敬请期待~")
            return
        }
        self.joinBtn.setTitle("正在下载...", for: .normal)
        //self.joinBtn.backgroundColor = .red
        DispatchQueue.global().async {


            for model in  (weakSelf?.dataModel.data.courseActGifs)!{
               weakSelf?.request.downLoadGif(model: model, complate: { (data) in
                    KFBLog(message: "下载完毕\(data)")
                })
                num += 1
                KFBLog(message: "下载完毕~~\(num)")
                DispatchQueue.main.sync {
                    let pro : Float = Float(num) / Float((weakSelf?.dataModel.data.courseActGifs.count)!)
                    let proFloatStr = String(format: "%.2f", pro*100)
                    if (weakSelf?.isDownload)! {
                        self.joinBtn.setTitle("正在加载本地数据\(proFloatStr)%", for: .normal)
                    } else {
                        self.joinBtn.setTitle("正在下载\(proFloatStr)%", for: .normal)
                    }

                    if num == weakSelf?.dataModel.data.courseActGifs.count {
                        //将该课程标记为下载完毕
                        let courseModel :CourseDetialModel = (weakSelf?.dataModel.data)!
                            weakSelf?.request.downBackGroundMusic(model: courseModel, complate: {(data) in
                            KFBLog(message: "下载背景音乐完毕")
                            let url = data as! String
                            courseModel.gifbackgroundmusicurlLocal = url
                        })
                        //DispatchQueue.main.async(execute: {
                        self.joinBtn.isEnabled = true
                        self.joinBtn.setTitle("开始训练", for: .normal)
                        //标记课程 并进入课程
                        weakSelf?.markCourse()
                        //})

                    }
                }

//                DispatchQueue.main.async(execute: {
//
//                    let pro : Float = Float(num) / Float((weakSelf?.dataModel.data.courseActGifs.count)!)
//                    let proFloatStr = String(format: "%.2f", pro*100)
//                    if (weakSelf?.isDownload)! {
//                        self.joinBtn.setTitle("正在加载本地数据\(proFloatStr)%", for: .normal)
//                    } else {
//                        self.joinBtn.setTitle("正在下载\(proFloatStr)%", for: .normal)
//                    }
//
//                    if num == weakSelf?.dataModel.data.courseActGifs.count {
//                        //将该课程标记为下载完毕
//                        //DispatchQueue.main.async(execute: {
//                            self.joinBtn.isEnabled = true
//                            self.joinBtn.setTitle("开始训练", for: .normal)
//                            //标记课程 并进入课程
//                            weakSelf?.markCourse()
//                        //})
//
//                    }
//                })

            }

        }

    }

    func markCourse() {

        if self.isWanwNum == 0 {
            self.KfbShowWithInfo(titleString: "失去网络，请重新下载数据")
            let alertController = UIAlertController(title: "", message: "失去网络，请重新下载数据", preferredStyle: .alert)
            let cancleAction = UIAlertAction(title: "确定", style: .cancel) { (action) in
                //取消
                alertController.dismiss(animated: true, completion: {
                    self.navigationLeftBtnClick()
                })

            }
            alertController.addAction(cancleAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            fileManger.setCourseInfotoPlist(courseid: String(self.dataModel.data.courseid), exist: true, complate: { (data) in
                let ok : Bool = data as! Bool
                if ok{
                    //下载完毕进入课程
                    if self.isDownIng {
                        let vc = StartLessonViewController()
                        vc.dataModel = (self.dataModel.data)
                        vc.backGroundMusicUrl = self.dataModel.data.gifbackgroundmusicurlLocal
                        self.present(vc, animated: true, completion: {

                        })
                    } else {
                        KFBLog(message:  "下载完成但不是下载页面所以无需跳转")

                    }
                } else {
                    
                }
            })
        }

    }


    // MARK: tableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = Bundle.main.loadNibNamed("HeadTableViewCell", owner: nil, options: nil)?.first as! HeadTableViewCell
            cell.setUpUI(model: dataModel.data)
            return cell
        case 1:
            let cell = ActionsTableViewCell(style: .default, reuseIdentifier: "123")
            cell.setUpUI(model: dataModel.data)
            return cell
        case 2:
//            let trainDetialcell : TrainDetialTextTableViewCell = Bundle.main.loadNibNamed("TrainDetialTextTableViewCell", owner: nil, options: nil)?.first as! TrainDetialTextTableViewCell
//            trainDetialcell.setUpUI(text: textStr)
//            trainDetialcell.selectionStyle = .none
//            trainDetialcell.setNeedsLayout()
//            trainDetialcell.setNeedsUpdateConstraints()
//            return trainDetialcell
            let oprionCell : OptionsTableViewCell = OptionsTableViewCell(style: .default, reuseIdentifier: "456")
            oprionCell.selectionStyle = .none
            oprionCell.setUpUI(arr: desArr, type : 0)
            return oprionCell
        case 3:
            let oprionCell : OptionsTableViewCell = OptionsTableViewCell(style: .default, reuseIdentifier: "456")
            oprionCell.selectionStyle = .none
            oprionCell.setUpUI(arr: optionArr, type: 1)
            return oprionCell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return HEADCELLHEIGHT
        case 1:
            return ACTIONCELLHEIGHT
        case 2:
            return CGFloat(DETIALCELLHEIGHT + 10)
        case 3:
            return CGFloat(OPTIONCELLHEIGHT + 10)
        default:
            return 0
        }
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
