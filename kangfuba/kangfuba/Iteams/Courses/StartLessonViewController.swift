//
//  StartLessonViewController.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/5.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import Gifu
import AVFoundation

class StartLessonViewController: BaseViewController, AVAudioPlayerDelegate ,RestDelegate,StopDelegate,StopView_LANDelegate,RestView_LANDelegate{

    var avplayer: AVAudioPlayer? = nil //讲解音，倒计时，休息等
    var avplayerOver : Bool = false //是否播放讲解音倒计时，休息等
    var backGroundAvplayer: AVAudioPlayer? = nil//背景音乐
    var giudeAvplayer: AVAudioPlayer? = nil//指导音乐
    var numAvplayer: AVAudioPlayer? = nil//报数

    var time : Timer!//动作计时 时间计时器
    var time2 : Timer!//持续时间时 检测动作是否完成
    var time3 : Timer!//次数 检测动作是否完成
    var starDate : NSDate!//开始时间
    var laterTime : TimeInterval = TimeInterval(0)//延迟时间

    var starDate2 : NSDate!//time2
    var laterTime2 : TimeInterval = TimeInterval(0)//time2延迟时间

    var needStopGif_stopclick:Bool = false//当点击暂停时 需要暂停Gif  (坚持多久的时候 提示动作)
    var isLanUI : Bool = false//是否是横屏

    //竖屏UI
    var gifImageView: GIFImageView!//gif图
    var backBtn : UIButton!//暂停按钮
    var backBtnBIG : UIButton!//暂停按钮 放大区域
    var titleNameLabel: UILabel!//名称
    var tipLabel : UILabel!//提醒
    var tipBackImageView : UIImageView!
    var currectTimeLabel: UILabel!//当前秒数
    var tolaTimeLaebl: UILabel!//总秒数
    var proTolaTimeLabel: UILabel!//进度条时间
    var progressView: UIProgressView!//进度条
    var progressTinView: UIView!//进度条
    //var progressTinView_land: UIView!//进度条
    var nestAcitonLabel: UILabel!//下一个动作
    var musicBtn : UIButton!//音乐按钮
    var stopBtn : UIButton!//暂停按钮
    var verBtn : UIButton = { () -> UIButton in
        let btn : UIButton = UIButton(frame: CGRect(x: KSCREEN_WIDTH - 40, y: 20, width:25, height: 25))
        btn.setBackgroundImage(#imageLiteral(resourceName: "course_tover"), for: .normal)
        return btn
    }()//竖屏按钮
    //横屏UI
    var lanBtn : UIButton!//横屏按钮
    lazy var currectTimeLabel_lan : UILabel = { () -> UILabel in
        var label = UILabel(frame: CGRect(x: 30, y: KSCREEN_WIDTH - 130, width: 150, height: 30))
        label.textColor = GRAY999999_COLOUR
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30)
        //label.text = "1/12"
        return label
    }()//当前动作次数/总次数

    lazy var titleNameLabel_lan : UILabel = { () -> UILabel in
        var label = UILabel(frame: CGRect(x: 30, y: KSCREEN_WIDTH-80, width: 300, height: 15))
        label.textColor = GRAY999999_COLOUR
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        //label.text = "1/5踢腿踢腿"
        return label
    }()//当前动作序列/总序列  当前名称

    var countdownTimeBtn_lan : UIButton = { () -> UIButton in
        let btn : UIButton = UIButton(frame: CGRect(x: (KSCREEN_HEIGHT - 58)/2, y: (KSCREEN_WIDTH - 58)/2, width: 58, height: 58))
        btn.backgroundColor = GREEN_COLOUR
        btn.setTitle("3", for: .normal)
        btn.kfb_makeRound()
        return btn
    }()//倒计时 显示横屏

    var backView_lan : UIView = { () -> UIView in
        let view :  UIView = UIView()
        view.frame = CGRect(x: 15, y: KSCREEN_WIDTH - 45, width: KSCREEN_HEIGHT, height: 45)
        view.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()//横屏底部控制条背景


    var stopBtn_lan : UIButton = { () -> UIButton in
        let btn : UIButton = UIButton(frame: CGRect(x: 30, y: KSCREEN_WIDTH-35, width: 23, height: 23))
        //btn.backgroundColor = GREEN_COLOUR
        btn.tag = 101
        btn.setBackgroundImage(#imageLiteral(resourceName: "course_stop_lan"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "course_begin_lan"), for: .selected)
        return btn
    }()//暂停按钮

    lazy var currectProTimeLabel_lan : UILabel = { () -> UILabel in
        var label = UILabel(frame: CGRect(x: 63, y: KSCREEN_WIDTH-30, width: 50, height: 15))
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
//        label.text = "00:12"
        //label.backgroundColor = .black
        return label
    }()//当前运动时间
    lazy var totlaProTimeLabel_lan : UILabel = { () -> UILabel in
        var label = UILabel(frame: CGRect(x: KSCREEN_HEIGHT - 80, y: KSCREEN_WIDTH-30, width: 50, height: 15))
        label.textColor = GRAY999999_COLOUR
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        //label.backgroundColor = .black
        return label
    }()//总时间



    lazy var pro_lan : UIProgressView = { () -> UIProgressView in
        let progress = UIProgressView(frame: CGRect(x: 53, y: KSCREEN_WIDTH-23, width: KSCREEN_HEIGHT  - 160, height: 20))
        progress.backgroundColor =  GRAYD8D8D8_COLOUR
        progress.tintColor = GREEN_COLOUR
        progress.progressTintColor = GREEN_COLOUR
        return progress
    }()//进度条
    lazy var progressTinView_land : UIView = { () -> UIView in
        let  progressTinView_land : UIView = UIView(frame: CGRect(x: 0, y: -3, width: 8, height: 8))
        progressTinView_land.backgroundColor = green_COLOUR
        progressTinView_land.kfb_makeRound()
        return progressTinView_land
    }()//进度条

    //数据
    let request : CourseDataManger = CourseDataManger.sharedInstance//数据请求vc
    var dataModel : CourseDetialModel = CourseDetialModel()//课程数据
    var backGroundMusicUrl : String!//背景音乐地址
    var currectModelNum : Int = 0//当前动作模型
    var currectModel : ActionGifModel = ActionGifModel()//当前动作模型
    var guideVideosArr : Array<Int> = Array()//指导音数组
    //按次数
    var currectActionTime  : CGFloat = 0.0//当前动作时间 gif时间
    var currectTimes : Int = 1//当前动作次数
    var currectionRep : Int = 0//当前动作总从夫次数
    var currectProScale : CGFloat = 0.0//当前进度比例
    var totlaPro : Float = 0.0//当前动作组总进度
    var currectRestTime : Int = 0//当前休息的时间
    var currectTotlaExpTime : Double = 0.0//当前讲解音总时间
    var gifView : GIFView = GIFView()
    var lastTimeGifView : UIImageView = UIImageView()
    var countdownTime : Int = 4//倒计时3s
    var countdownTimeBtn : UIButton = { () -> UIButton in
        let btn : UIButton = UIButton(frame: CGRect(x: (KSCREEN_WIDTH - 58)/2, y: (211 - 58)/2, width: 58, height: 58))
        btn.backgroundColor = GREEN_COLOUR
        btn.kfb_makeRound()
        return btn
    }()//倒计时 显示竖屏
    //按时间
    var actionLastTime : Int = 1//当前动作坚持时间
    // MARK: 休息view
    lazy var restView : RestView = { () -> RestView in
        let breakView  = Bundle.main.loadNibNamed("RestViewX", owner: nil, options: nil)?.first as! RestView
        breakView.delegate = self
        return breakView

    }()

    lazy var restView_lan : RestView_LAN = { () -> RestView_LAN in
        let breakView  = RestView_LAN.init(frame:  CGRect(x: 0, y: 0, width:KSCREEN_WIDTH , height: KSCREEN_HEIGHT))
        breakView.delegate = self
        return breakView

    }()
    func jumpRestDelegate_lan() {
        MobClick.event("022")
        KFBLog(message: "跳出休息")
        currectRestTime = 1
        self.restTime()

    }

    // MARK: 暂停view
    lazy var stopView : StopView = { () -> StopView in
        let view : StopView = Bundle.main.loadNibNamed("StopView", owner: nil, options: nil)?.first as! StopView
        view.delegate = self
        return view
    }()
    func jumpStopDelegate() {
        stopView.removeFromSuperview()
        self.startTime()
    }
    lazy var stopView_lan : StopView_LAN = { () -> StopView_LAN in
        let breakView  = StopView_LAN.init(frame:  CGRect(x: 0, y: 0, width:KSCREEN_WIDTH , height: KSCREEN_HEIGHT))
        breakView.delegate = self
        return breakView
    }()

    func jumpStopDelegate_LAN() {
        stopView_lan.removeFromSuperview()
        self.startTime()
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }

    // MARK: 竖屏点击 去横屏
    func verBtnClick(_ sender: AnyObject) {
        //竖屏
        MobClick.event("021")
        isLanUI = true
        KFBLog(message: "去横屏")
        //self.prefersStatusBarHidden = true
        self.view.bringSubview(toFront: gifImageView)
        gifImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        gifImageView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT)
        gifImageView.isUserInteractionEnabled = true
        backBtn.removeFromSuperview()
        backBtnBIG.removeFromSuperview()
        lanBtn.removeFromSuperview()

        self.view.addSubview(verBtn)
        stopBtn_lan.addTarget(self, action: #selector(StartLessonViewController.stopBtnClick), for: .touchUpInside)

        //gifImageView.insertSubview(backView_lan, belowSubview: pro_lan)
//        gifImageView.addSubview(backView_lan)
        gifImageView.addSubview(currectTimeLabel_lan)
        gifImageView.addSubview(titleNameLabel_lan)
        gifImageView.addSubview(stopBtn_lan)

        gifImageView.addSubview(currectProTimeLabel_lan)
        gifImageView.addSubview(totlaProTimeLabel_lan)
        gifImageView.addSubview(pro_lan)
        pro_lan.addSubview(progressTinView_land)

    }
    // MARK: 横屏点击 去竖屏
    func lanBtnClick()  {
        isLanUI = false
        KFBLog(message: "去竖屏")
        //self.prefersStatusBarHidden = false
        backView_lan.removeFromSuperview()
        countdownTimeBtn_lan.removeFromSuperview()
        stopBtn_lan.removeFromSuperview()
        currectTimeLabel_lan.removeFromSuperview()
        titleNameLabel_lan.removeFromSuperview()
        currectProTimeLabel_lan.removeFromSuperview()
        totlaProTimeLabel_lan.removeFromSuperview()
        pro_lan.removeFromSuperview()
        gifImageView.transform = CGAffineTransform(rotationAngle: 0)
        gifImageView.frame = CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip6(221))
        verBtn.removeFromSuperview()
        self.view.addSubview(lanBtn)
        self.view.addSubview(backBtn)
        self.view.addSubview(backBtnBIG)
    }

    // MARK: 关闭音乐
    func musicBtnClick(_ sender: AnyObject) {
        let btn  = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            backGroundAvplayer?.volume = 0
        } else {
            backGroundAvplayer?.volume = 0.4
        }
    }



    // MARK: 播放暂停gif
    func stopBtnClick(_ sender: AnyObject) {
        MobClick.event("020")
        let btn  = sender as! UIButton
        if btn.tag == 100 {
            //竖屏暂停
            self.stopTime()
        } else {
            //横屏暂停
            self.stopTime()
        }
        
    }

    func stopTime() {
         KFBLog(message: "暂停")
        if currectModel.lastseconds == 0 {
            gifImageView.stopAnimatingGIF()
        }
        if needStopGif_stopclick == true {
            self.gifImageView.stopAnimatingGIF()
        }
        if isLanUI {
            stopView_lan.setUpUI(name: currectModel.nextActName)
            self.view.window?.addSubview(stopView_lan)
        } else {
            stopView.setUpUI(name: currectModel.nextActName, warnStr : currectModel.wisdom)
            self.view.window?.addSubview(stopView)
        }

        //time暂  
        if let _  = starDate {

            let date : NSDate = NSDate()
            let date2 : TimeInterval =  date.timeIntervalSince(starDate as Date)
            laterTime = TimeInterval(currectActionTime) - date2
            KFBLog(message: "暂停时间\(date)--时间差\(laterTime)")
        }

        if let _ = starDate2 {
            let date : NSDate = NSDate()
            let date2 : TimeInterval =  date.timeIntervalSince(starDate2 as Date)
            laterTime2 = TimeInterval(currectActionTime) - date2
            KFBLog(message: "暂停时间\(date)--时间差\(laterTime2)")
        }


        if time != nil {
            if time.isValid {
                time.fireDate = NSDate.distantFuture
            }
        }
        if time2 != nil {
            if time2.isValid {
                time2.fireDate = NSDate.distantFuture
            }
        }
        if time3 != nil {
            if time3.isValid {
                time3.fireDate = NSDate.distantFuture
            }
        }
        //背景音暂停
        if backGroundAvplayer != nil{
            if (backGroundAvplayer?.isPlaying)! {
                backGroundAvplayer?.pause()
            }
        }

        //讲解音，倒计时，休息
        if avplayer != nil{
            if (avplayer?.isPlaying)! {
                avplayer?.pause()
            }
        }
        //指导音乐
        if giudeAvplayer != nil{
            if (giudeAvplayer?.isPlaying)! {
                giudeAvplayer?.pause()
            }
        }
        //报数 ---time 管理
        if numAvplayer != nil{
            if (numAvplayer?.isPlaying)! {
                numAvplayer?.pause()
            }
        }
    }

    func startTime() {
          KFBLog(message: "开始")


        if isLanUI {
            stopView_lan.removeFromSuperview()
        } else {
            stopView.removeFromSuperview()
        }

        if currectModel.lastseconds == 0 {
            gifImageView.startAnimatingGIF()
        }
        KFBLog(message: "开始是否需要开始gif\(needStopGif_stopclick)")
        if needStopGif_stopclick == true {
            KFBLog(message: "开始")
            self.gifImageView.startAnimatingGIF()
        }

        //背景音乐开始
        if backGroundAvplayer != nil{
            if !(backGroundAvplayer?.isPlaying)! {
                backGroundAvplayer?.play()
            }
        }

        //讲解音，倒计时，休息
        if avplayer != nil{
            if !(avplayer?.isPlaying)! {
                avplayer?.play()
            }
        }
        //指导音乐
        if giudeAvplayer != nil{
            if !(giudeAvplayer?.isPlaying)! {
                giudeAvplayer?.play()
            }
        }
        //报数 ---time 管理
        if numAvplayer != nil{
            if !(numAvplayer?.isPlaying)! {
                numAvplayer?.play()
            }
        }
        //time开始

        if time != nil {
            if time.isValid {
                if laterTime > 0 {
                    //暂停后的补时
                    DispatchQueue.global().async {
                        Thread.sleep(forTimeInterval: TimeInterval(self.laterTime))
                        DispatchQueue.main.async {
                            self.time.fireDate = NSDate.distantPast
                        }
                    }
                } else {
                     time.fireDate = NSDate.distantPast
                }

            }
        }
        if time2 != nil {
            if time2.isValid {
                if laterTime2 > 0 {
                    //暂停后的补时
                    DispatchQueue.global().async {
                        Thread.sleep(forTimeInterval: TimeInterval(self.laterTime2))
                        DispatchQueue.main.async {
                            self.time2.fireDate = NSDate.distantPast
                        }
                    }
                } else {
                    time2.fireDate = NSDate.distantPast
                }
            }
        }
        if time3 != nil {
            if time3.isValid {
                time3.fireDate = NSDate.distantPast
            }
        }

    }


    // MARK: 音频播放器播放结束
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //当按次数计算时才需要此处判断
         if currectModel.lastseconds == 0 {
            if currectTotlaExpTime > Double(currectActionTime) {

                let url = NSURL(fileURLWithPath: currectModel.explainLocalUrl)
                if (player.url!  == url as URL) {
                    //当第一个讲解音播放完毕  播放321
                    KFBLog(message: "按次数讲解音时间长进入音频播放完毕代理")

                    time = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(StartLessonViewController.thirdSeconds), userInfo: nil, repeats: true)
                    time.tolerance = 0.01
                    let backUrlStr = Bundle.main.path(forResource: "daojishi", ofType: "mp3")
                    let backUrl  = URL(fileURLWithPath: backUrlStr!)
                    do {
                        avplayer = try AVAudioPlayer(contentsOf: backUrl)
                        avplayer?.volume = 1
                        avplayer?.delegate = self
                    } catch _{
                        avplayer = nil
                    }
                    avplayer?.play()
                    //倒计时开始
                    if isLanUI {
                        countdownTimeBtn_lan.setTitle("3", for: .normal)
                        gifImageView.addSubview(countdownTimeBtn_lan)
                    } else {
                        countdownTimeBtn.setTitle("3", for: .normal)
                        self.view.addSubview(countdownTimeBtn)
                    }
                }

            } else {


            }


        }

        //按秒的时候是这个逻辑
        if currectModel.repeattimes == 0 {
            let url = NSURL(fileURLWithPath: currectModel.explainLocalUrl)
            KFBLog(message:  "asdfasdfa---\(player.url?.absoluteString)")
            if (player.url!  == url as URL){
                //当第一个讲解音播放完毕 播放倒计时
                KFBLog(message: "讲解音播放完毕")
                let backUrlStr = Bundle.main.path(forResource: "daojishi", ofType: "mp3")
                let backUrl  = URL(fileURLWithPath: backUrlStr!)
                do {
                    avplayer = try AVAudioPlayer(contentsOf: backUrl)
                    avplayer?.volume = 1
                    avplayer?.delegate = self
                } catch _{
                    avplayer = nil
                }
                avplayer?.play()
                //倒计时开始
                countdownTimeBtn.setTitle("3", for: .normal)
                countdownTimeBtn_lan.setTitle("3", for: .normal)
                if isLanUI {
                    gifImageView.addSubview(countdownTimeBtn_lan)
                } else {
                    self.view.addSubview(countdownTimeBtn)
                }
                time = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(StartLessonViewController.thirdSeconds_last), userInfo: nil, repeats: true)
                time.tolerance = 0.001

            } else{

                 KFBLog(message: "讲解音没播放完毕")
            }
        }

    }

     // MARK: 倒计时3s  时间
    func thirdSeconds_last(){
        countdownTime -= 1
        if countdownTime == 0 {
            time.invalidate()
            time = nil
            lanBtn.isEnabled = true
            verBtn.isEnabled = true
            countdownTime = 4
            //播放gif最后一秒
            if avplayer != nil {
                avplayer = nil
            }
            KFBLog(message: "倒计时播放完毕")
            self.playTimeVideo_didi()//滴滴
            time = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(StartLessonViewController.actionLastTimeTimer), userInfo: nil, repeats: true)
             starDate = NSDate()

        } else {
            if countdownTime == 1 {
                //已经到是最后一秒无需显示时间 还有1s给播放开始两个字
                countdownTimeBtn.removeFromSuperview()
                countdownTimeBtn_lan.removeFromSuperview()
            } else {
                lanBtn.isEnabled = false
                verBtn.isEnabled = false
                countdownTimeBtn.setTitle("\(countdownTime-1)", for: .normal)
                countdownTimeBtn_lan.setTitle("\(countdownTime-1)", for: .normal)
            }

        }
    }

    // MARK: 倒计时3s  次数
    func thirdSeconds()  {
        countdownTime -= 1
        if countdownTime == 0 {
            time.invalidate()
            time = nil
            lanBtn.isEnabled = true
            verBtn.isEnabled = true
            countdownTime = 4

            //从新播放gif 正式开始训练
            self.playTimeVideo(currectTime: 1)//语音播放 1第一次播放
            gifImageView.animate(withGIFNamed: currectModel.actpic)
            gifImageView.startAnimatingGIF()
            KFBLog(message: "倒计时播放完毕")
            if avplayer != nil {
                avplayer = nil
            }
            time = Timer.scheduledTimer(timeInterval: TimeInterval(currectActionTime), target: self, selector: #selector(StartLessonViewController.complateOneTime), userInfo: nil, repeats: true)
            starDate = NSDate()
            time.tolerance = 0.01


        } else {
            if countdownTime == 1 {
                //已经到是最后一秒无需显示时间 还有1s给播放开始两个字
                countdownTimeBtn.removeFromSuperview()
                countdownTimeBtn_lan.removeFromSuperview()
            } else {
                lanBtn.isEnabled = false
                verBtn.isEnabled = false
                countdownTimeBtn.setTitle("\(countdownTime-1)", for: .normal)
                countdownTimeBtn_lan.setTitle("\(countdownTime-1)", for: .normal)
            }
        }
    }



    // MARK: 生命周期
    override func viewWillDisappear(_ animated: Bool) {
        //super.viewWillDisappear(animated)
        KFBLog(message: "viewWillDisappear")
        //self.removePlayers()
        self.beginAppearanceTransition(false, animated: animated)
        self.removePlayers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        //super.viewDidDisappear(animated)
        self.beginAppearanceTransition(false, animated: animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        KFBLog(message: "viewWillAppear")
        self.beginAppearanceTransition(true, animated: animated)
    }

    func appDidEnterBackground() {
        //
        KFBLog(message: "进入后台")
        if currectModel.lastseconds == 0 {
            //暂停  次数暂停
            //添加休息
            self.stopTime()
            gifImageView.stopAnimatingGIF()
        } else {
            //时间暂停
            //                self.view.window?.addSubview(stopView)
            self.stopTime()
        }
    }

    func appDidEnterPlayGround() {
        //
        KFBLog(message: "进入前台")
        if currectModel.lastseconds == 0 {
            self.startTime()
            gifImageView.startAnimatingGIF()
        } else {
            //               stopView.removeFromSuperview()
            self.startTime()
        }

    }

    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {

    }
    deinit {
        //记得移除通知监听
//        KFBLog(message: "delloc")
        NotificationCenter.default.removeObserver(self)
        self.removePlayers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar_leftBtn()
        self.endAppearanceTransition()
        NotificationCenter.default.addObserver(self, selector: #selector(DiagnoseViewController.appDidEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(DiagnoseViewController.appDidEnterPlayGround), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        // Do any additional setup after loading the view.
//        self.makeData()
        self.creatVerUI()
//        //返回按钮

        let model : ActionGifModel  = dataModel.courseActGifs.first!
        if model.repeattimes == 0 {
            //按时间
            self.setUpDataSecond()
        }

        if model.lastseconds == 0 {
            //按次数
            self.setUpData()
        }

        //播放背景音乐

        if backGroundMusicUrl.characters.count > 0  {
            let url = NSURL(fileURLWithPath: backGroundMusicUrl)
            KFBLog(message: "背景音频本地路径url\(url)")
            do {
                backGroundAvplayer = try AVAudioPlayer(contentsOf: url as URL)
                backGroundAvplayer?.delegate = self
                backGroundAvplayer?.numberOfLoops = -1
                backGroundAvplayer?.volume = 0.4
                backGroundAvplayer?.play()
            } catch let error as NSError{
                KFBLog(message: "背景音乐播放错误"+error.debugDescription)
                backGroundAvplayer = nil
            }

        } else {
            KFBLog(message: "没有背景音乐");
        }

    }

    // MARK: 竖屏UI
    func creatVerUI() {
        //上部分
        //gif图片
        gifImageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: ip6(221)))
        self.view.addSubview(gifImageView)
        //横屏按钮
        lanBtn = UIButton(type: .custom)
        lanBtn.frame = CGRect(x: KSCREEN_WIDTH - 35, y: gifImageView.frame.maxY - 35, width: 25, height: 25)
        lanBtn.setImage(#imageLiteral(resourceName: "course_tolan"), for: .normal)
        lanBtn.addTarget(self, action: #selector(StartLessonViewController.verBtnClick), for: .touchUpInside)
        self.view.addSubview(lanBtn)

        //竖屏按钮
        verBtn.addTarget(self, action: #selector(StartLessonViewController.lanBtnClick), for: .touchUpInside)

        //名字
        titleNameLabel = UILabel(frame: CGRect(x: (KSCREEN_WIDTH - ip6(200))/2, y: gifImageView.frame.maxY + ip6(18), width: ip6(200), height: 15))
        titleNameLabel.textColor = GRAY656A72_COLOUR
        titleNameLabel.textAlignment = .center
        titleNameLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(titleNameLabel)
        //静音
        musicBtn = UIButton(type: .custom)
        musicBtn.frame = CGRect(x: KSCREEN_WIDTH - 50, y: gifImageView.frame.maxY + ip6(15), width: 20, height: 20)
        musicBtn.setImage(#imageLiteral(resourceName: "course_music"), for: .normal)
        musicBtn.setImage(#imageLiteral(resourceName: "course_closemusic"), for: .selected)
        musicBtn.addTarget(self, action: #selector(StartLessonViewController.musicBtnClick), for: .touchUpInside)
        self.view.addSubview(musicBtn)

        //提示
        tipBackImageView = UIImageView(frame: CGRect(x: (KSCREEN_WIDTH - ip6(280))/2, y: titleNameLabel.frame.maxY + ip6(15), width: ip6(280), height: ip6(26) ))
        tipBackImageView.image = #imageLiteral(resourceName: "course_tip")
        tipBackImageView.isHidden = true
        self.view.addSubview(tipBackImageView)

        tipLabel = UILabel(frame: CGRect(x: ip6(10), y: 0, width: ip6(280), height: ip6(26)))
        tipLabel.backgroundColor = .clear
        tipLabel.textColor = GRAY656A72_COLOUR
        tipLabel.textAlignment = .center
        tipLabel.numberOfLines = 1
        tipLabel.font = UIFont.systemFont(ofSize: 15)
        //tipLabel.isHidden = true
        tipBackImageView.addSubview(tipLabel)

        //中间数字部分
        currectTimeLabel = UILabel(frame: CGRect(x: (KSCREEN_WIDTH - ip6(200))/2, y: titleNameLabel.frame.maxY + ip6(90), width: ip6(100), height: ip6(72)))
        currectTimeLabel.textAlignment = .right
        currectTimeLabel.textColor = GREEN_COLOUR
        currectTimeLabel.font = kfbFont(72)
        currectTimeLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(currectTimeLabel)

        tolaTimeLaebl = UILabel(frame: CGRect(x: currectTimeLabel.frame.maxX, y: titleNameLabel.frame.maxY + ip6(127), width: ip6(100), height: ip6(30)))
        tolaTimeLaebl.textAlignment = .left
        tolaTimeLaebl.textColor = GRAY656A72_COLOUR
        tolaTimeLaebl.font = kfbFont(30)
        tolaTimeLaebl.adjustsFontSizeToFitWidth = true
        self.view.addSubview(tolaTimeLaebl)

        //下半部分
        let backView = UIView(frame: CGRect(x: 0, y: KSCREEN_HEIGHT - ip6(170), width: KSCREEN_WIDTH, height: ip6(170)))
        KFBLog(message: "下半部分高度\(ip6(170))")
        backView.backgroundColor = .clear
        self.view.addSubview(backView)

        //进度条部分
        let proName : UILabel = UILabel(frame: CGRect(x: 15, y: 0, width: 40, height: 10))
        proName.textColor = GRAY8E8E8E_COLOUR
        proName.font = UIFont.systemFont(ofSize: 10)
        proName.text = "总进度"
        proName.textAlignment = .center
        backView.addSubview(proName)

        proTolaTimeLabel  = UILabel(frame: CGRect(x: KSCREEN_WIDTH - ip6(45) - 15, y: 0, width: ip6(45), height: 10))
        proTolaTimeLabel.textColor = GRAY8E8E8E_COLOUR
        proTolaTimeLabel.font = UIFont.systemFont(ofSize: 10)
        proTolaTimeLabel.textAlignment = .right
        // + String(format: "%.1d",Int(dataModel.timelen/60)%60)
        let minStr :String = String(format: "%02.0f :",dataModel.timelen/60)
        let minStr2 :String = String(format: "%.1f",dataModel.timelen/60)
        let secondStr :String = String(format: " %02.0f",Float(Int(dataModel.timelen) - Int(dataModel.timelen/60)*60))

        KFBLog(message: minStr2)
        KFBLog(message: "分钟\(Int(dataModel.timelen/60))余数\(secondStr)")
        proTolaTimeLabel.text = minStr + secondStr
        totlaProTimeLabel_lan.text = minStr + secondStr
        backView.addSubview(proTolaTimeLabel)

        progressView = UIProgressView(frame: CGRect(x: proName.frame.maxX + 10, y: 5, width: KSCREEN_WIDTH - ip6(45) - 90, height: 0))
        progressView.backgroundColor =  GRAYD8D8D8_COLOUR
        progressView.tintColor = GREEN_COLOUR
        progressView.progress  = 0.0
        backView.addSubview(progressView)

        progressTinView = UIView(frame: CGRect(x: 0, y: -3, width: 8, height: 8))
        progressTinView.backgroundColor = green_COLOUR
        progressTinView.kfb_makeRound()
        progressView.addSubview(progressTinView)

        //下一个动作
        nestAcitonLabel = UILabel(frame: CGRect(x: (KSCREEN_WIDTH - ip6(200))/2 , y: progressView.frame.maxY + 15, width: ip6(200), height: 10))
        nestAcitonLabel.textColor = GRAY656A72_COLOUR
        nestAcitonLabel.font = UIFont.systemFont(ofSize: 10)
        nestAcitonLabel.textAlignment = .center
        backView.addSubview(nestAcitonLabel)

        //暂停按钮
        stopBtn = UIButton(type: .custom)
        stopBtn.frame = CGRect(x: (KSCREEN_WIDTH - ip6(58))/2, y: nestAcitonLabel.frame.maxY + ip6(38), width: ip6(58), height: ip6(58))
        stopBtn.setImage(#imageLiteral(resourceName: "course_musicstop"), for: .normal)
        stopBtn.setImage(#imageLiteral(resourceName: "course_reststar"), for: .selected)
        stopBtn.addTarget(self, action: #selector(StartLessonViewController.stopBtnClick), for: .touchUpInside)
        stopBtn.tag = 100
        backView.addSubview(stopBtn)


        backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 15, y: 30, width: 12, height: 20)
        backBtn.setImage(#imageLiteral(resourceName: "navigation_left_arrow"), for: .normal)
        backBtn.addTarget(self, action: #selector(StartLessonViewController.backClick), for: .touchUpInside)
        self.view.addSubview(backBtn)

        backBtnBIG = UIButton(type: .custom)
        backBtnBIG.frame = CGRect(x: 15, y: 30, width: 30, height: 30)
        //backBtnBIG.backgroundColor = .red
        backBtnBIG.addTarget(self, action: #selector(StartLessonViewController.backClick), for: .touchUpInside)
        self.view.addSubview(backBtnBIG)


    }

    //假数据
    func makeData()   {
//        dataModel.timelen = 60
        for model in dataModel.courseActGifs {
//            model.repeattimes = 3
//            model.lastseconds = 5
//            model.actname = "踢腿动作"
//            model.actpic = "00209"
//            model.actpic = "5678"
//            model.explainmusicurl = "zhunbei"
            model.resttimelen = 10
//            dataModel.courseActGifs.append(model)

        }
    }
    // MARK: 上传数据
    func uploadData()  {
        weak var weakself = self
        request.upLoadTrainingRecord(courseId:  dataModel.courseid, trainType: dataModel.traintype, complate: {(data) in
            let backModel : LoginModel = data as! LoginModel
            if backModel.status > 0{
                KFBLog(message: "上传成功")
                MobClick.event("025")
                let urlStr = Bundle.main.path(forResource: "complete", ofType: "mp3")
                let url  = URL(fileURLWithPath: urlStr!)
                do {
                    weakself?.avplayer = try AVAudioPlayer(contentsOf: url)
                } catch _{
                    weakself?.avplayer = nil
                }
                weakself?.avplayer?.play()
                weakself?.backGroundAvplayer?.stop()
                //退出
                let alertController = UIAlertController(title: "", message: "恭喜你！完成"+(weakself?.dataModel.coursename)!+"☺离健康又进一步~", preferredStyle: .alert)

                let cancleAction = UIAlertAction(title: "确定", style: .cancel) { (action) in

                    //确定

                    //alertController.dismiss(animated: true, completion: {
                        self.removePlayers()
                        self.dismiss(animated: true, completion: {

                        })
                   // })

                }
                alertController.addAction(cancleAction)
                weakself?.present(alertController, animated: true, completion: nil)

            } else {
                KFBLog(message: "上传失败")
            }
        }, faile: {(erro) in

            weakself?.KfbShowWithInfo(titleString: erro )
        })


    }

    // MARK: UI数据填充 秒
    func setUpDataSecond()  {
        KFBLog(message: "时间循环")
        //第一组动作
        if !(dataModel.courseActGifs.count > 0 && currectModelNum < dataModel.courseActGifs.count) {
            //
            KFBLog(message: "该动作以完成")
            return 
        }
        currectModel = dataModel.courseActGifs[currectModelNum]
        currectModelNum += 1
        //指导音数组
        if guideVideosArr.count>0{
            guideVideosArr.removeAll()
        }
        for model in currectModel.insertAudios {
            guideVideosArr.append(model.secondNum)
        }
        KFBLog(message: "讲解音数组\(guideVideosArr)")
        //持续秒数
//        let urlStr = Bundle.main.path(forResource: currectModel.explainmusicurl, ofType: "mp3")
//        let url  = URL(fileURLWithPath: urlStr!)
        KFBLog(message: "音频本地路径\(currectModel.explainLocalUrl)")
        let url = NSURL(fileURLWithPath: currectModel.explainLocalUrl)
        KFBLog(message: "音频本地路径url\(url)")
        do {
            avplayer = try AVAudioPlayer(contentsOf: url as URL)
            avplayer?.volume = 1
            avplayer?.delegate = self
            KFBLog(message: "讲解音总时间\(avplayer?.duration)")
        } catch _{
            avplayer = nil
        }
        avplayer?.play()
        //按秒来 gif播放完毕一直静止对应的时间
        let gifData = NSData(contentsOfFile: currectModel.gifLocalUrl)
        KFBLog(message: "gifdata\(gifData?.length)")
        gifImageView.animate(withGIFData: gifData as! Data)
        gifImageView.startAnimatingGIF()

//        gifView.showGifWitUrl(url: currectModel.gifLocalUrl)
        currectActionTime = CGFloat(currectModel.timelen)
        time2 = Timer.scheduledTimer(timeInterval: TimeInterval(currectModel.timelen), target: self, selector: #selector(StartLessonViewController.actionLastactTime), userInfo: nil, repeats: false)
        starDate2 = NSDate()
        needStopGif_stopclick = true
        //第一组标题
//        titleNameLabel.text = "\(currectModelNum)/\(dataModel.courseActGifs.count)\(currectModel.actname)"
//        titleNameLabel_lan.text = "\(currectModelNum)/\(dataModel.courseActGifs.count)\(currectModel.actname)"
        titleNameLabel.text = currectModel.videoTitle
        titleNameLabel_lan.text = currectModel.videoTitle

        if currectModel.tips.characters.count > 0 {
            tipBackImageView.isHidden = false
            tipLabel.text = currectModel.tips
        } else {
            tipBackImageView.isHidden = true
        }
        //中间时间
        currectTimeLabel.text = "\(actionLastTime)"
        tolaTimeLaebl.text = "/"+"\(currectModel.lastseconds)秒"
        currectTimeLabel_lan.text = "\(actionLastTime)"+"/"+"\(currectModel.lastseconds)"
        //进度条
        //时间比例 坚持是按1s算
        currectProScale = 1 / CGFloat(dataModel.timelen)
//        proTolaTimeLabel.text = "\(dataModel.timelen/60):" + String(format: "%.1f",Int(dataModel.timelen)%60)
//        totlaProTimeLabel_lan.text = "\(dataModel.timelen/60):" + String(format: "%.1f",Int(dataModel.timelen)%60)
        progressView.progress = totlaPro
        //休息时间
        currectRestTime = currectModel.resttimelen
        //下一个动作
        if currectModelNum == dataModel.courseActGifs.count {
            nestAcitonLabel.isHidden = true
        } else {
            nestAcitonLabel.isHidden = false
//            let nextModel : ActionGifModel = dataModel.courseActGifs[currectModelNum]
//            nestAcitonLabel.text = "下一个动作：\(nextModel.actname)"
            nestAcitonLabel.text = currectModel.nextActName
        }
    }


    // MARK: UI数据填充 次
    func setUpData()  {
        //刚进来
        //gif图片
        if !(dataModel.courseActGifs.count > 0 && currectModelNum < dataModel.courseActGifs.count) {
            //
            KFBLog(message: "该动作以完成")
            return
        }
        currectModel = dataModel.courseActGifs[currectModelNum]
        currectModelNum += 1
        //指导音数组
        if guideVideosArr.count>0{
            guideVideosArr.removeAll()
        }
        for model in currectModel.insertAudios {
            let num = Float(model.secondNum)/currectModel.timelen
            guideVideosArr.append(Int(num)+1)
        }
        KFBLog(message: "按次数讲解音数组\(guideVideosArr)")
        //先播放讲解音  动作也播放
        //动作播放
        //gifImageView.animate(withGIFNamed: currectModel.actpic)
        KFBLog(message: "视频本地路径\(currectModel.gifLocalUrl)")
        let gifData = NSData(contentsOfFile: currectModel.gifLocalUrl)
        if let _ =  gifData{
            gifImageView.animate(withGIFData: gifData as! Data)
            gifImageView.startAnimatingGIF()
        } else {
            KfbShowWithInfo(titleString: "动作加载失败，请重新下载~")
        }

        //讲解音播放
        //let urlStr = Bundle.main.path(forResource: currectModel.explainmusicurl, ofType: "mp3")
        KFBLog(message: "音频本地路径\(currectModel.explainLocalUrl)")
        let url = NSURL(fileURLWithPath: currectModel.explainLocalUrl)
//        KFBLog(message: "音频本地路径\(urlStr)")
//        let url  = URL(fileURLWithPath: urlStr!)
        KFBLog(message: "音频本地路径url\(url)")
        do {
            avplayer = try AVAudioPlayer(contentsOf: url as URL)
            avplayer?.volume = 1.0
            avplayer?.delegate = self
            KFBLog(message: "讲解音总时间\(avplayer?.duration)")
            currectTotlaExpTime = (avplayer?.duration)!
            avplayer?.play()
        } catch let error as NSError{
            KFBLog(message: "讲解音乐播放错误"+error.debugDescription)
            avplayer = nil
        }
        //当前gif的时间长度
        currectActionTime = CGFloat(currectModel.timelen)
        KFBLog(message: "----当前动作时间\(currectActionTime)")
        if currectTotlaExpTime > Double(currectActionTime) {

        } else {
            //动作时间比讲解音还要长
            KFBLog(message: "")
            time3 = Timer.scheduledTimer(timeInterval: TimeInterval(currectActionTime), target: self, selector: #selector(StartLessonViewController.actionComplateOneTimeWhenItLong), userInfo: nil, repeats: true)
            time3.tolerance = 0.01
        }

        //第一组动作
//        titleNameLabel.text = "\(currectModelNum)/\(dataModel.courseActGifs.count)\(currectModel.actname)"
//        titleNameLabel_lan.text = "\(currectModelNum)/\(dataModel.courseActGifs.count)\(currectModel.actname)"

        titleNameLabel.text = currectModel.videoTitle
        titleNameLabel_lan.text = currectModel.videoTitle
        if currectModel.tips.characters.count > 0 {

             tipBackImageView.isHidden = false
             tipLabel.text = currectModel.tips
        } else {
            tipBackImageView.isHidden = true

        }
        //总时间 进度条
//        proTolaTimeLabel.text = "\(dataModel.timelen/60):" + String(format: "%d",Int(dataModel.timelen)/60)
//        totlaProTimeLabel_lan.text = "\(dataModel.timelen/60):" + String(format: "%d",Int(dataModel.timelen)/60)
        progressView.progress = totlaPro
        //休息时间
        currectRestTime = currectModel.resttimelen

        //下一个动作
        if currectModelNum == dataModel.courseActGifs.count {
            nestAcitonLabel.isHidden = true
        } else {
            nestAcitonLabel.isHidden = false
//            let nextModel : ActionGifModel = dataModel.courseActGifs[currectModelNum]
//            nestAcitonLabel.text = "下一个动作：\(nextModel.actname)"
               nestAcitonLabel.text = currectModel.nextActName
        }


        //lastSeconds=0时repeattimes有效
        if currectModel.lastseconds == 0 {
            //按次数 播放完一次就算一次
            gifView = GIFView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            gifView.showGifWitUrl(url: currectModel.gifLocalUrl)
            //gifView.showGIFImageWithLocalName(name: currectModel.actpic)
//            KFBLog(message: "gif时间\(gifImageView.animator.debugDescription)-----\(gifView.totalTime)")
            //时间比例
            currectProScale = currectActionTime / CGFloat(dataModel.timelen)
            //当前gif需要重复的次数
            currectionRep = currectModel.repeattimes
            //初始化次数UI
            currectTimeLabel.text = "\(currectTimes)"
            tolaTimeLaebl.text = "/"+"\(currectModel.repeattimes)次"
            currectTimeLabel_lan.text = "\(currectTimes)"+"/"+"\(currectModel.repeattimes)"
        }

    }
    // MARK:GIF按次数播放的时候 gif时间小于讲解音的时间
    func actionComplateOneTimeWhenItLong()  {
        //gifImageView.stopAnimatingGIF()
        time3.invalidate()
        time3 = nil
        //动作完毕后播放 321
        time = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(StartLessonViewController.thirdSeconds), userInfo: nil, repeats: true)
        time.tolerance = 0.01
        let backUrlStr = Bundle.main.path(forResource: "daojishi", ofType: "mp3")
        let backUrl  = URL(fileURLWithPath: backUrlStr!)
        do {
            avplayer = try AVAudioPlayer(contentsOf: backUrl)
            avplayer?.delegate = self
            avplayer?.volume = 1.0
            avplayer?.play()
        }  catch let error as NSError{
            KFBLog(message: "讲解音乐播放错误"+error.debugDescription)
            avplayer = nil
        }

        //倒计时开始
        if isLanUI {
            countdownTimeBtn_lan.setTitle("3", for: .normal)
            gifImageView.addSubview(countdownTimeBtn_lan)
        } else {
            countdownTimeBtn.setTitle("3", for: .normal)
            self.view.addSubview(countdownTimeBtn)
        }

    }

    // MARK:GIF播放时间 之后
    func actionLastactTime() {
        time2.invalidate()
        time2 = nil
        gifImageView.stopAnimatingGIF()
        needStopGif_stopclick = false
    }

    // MARK:gif按次数
    func complateOneTime() {

        laterTime = 0
        currectionRep -= 1
        currectTimes = currectTimes+1
        starDate = NSDate()
        KFBLog(message: "开始时间\(starDate)")
        KFBLog(message: "动作次数\(currectTimes)"+"检测时间\(time.timeInterval))")
        if currectionRep == 0 {
            //当前gif播放完毕 下一个动作
            totlaPro = totlaPro + Float(currectProScale)
            progressView.progress = totlaPro
            progressTinView.frame.origin = CGPoint(x: CGFloat(totlaPro) * progressView.frame.width, y:progressTinView.frame.origin.y )
            progressTinView_land.frame.origin = CGPoint(x: CGFloat(totlaPro) * pro_lan.frame.width , y:-3)
            time.invalidate()
            time = nil

            gifImageView.stopAnimatingGIF()
            currectTimes = 1
            currectTimeLabel.text = "\(currectTimes)"
            currectTimeLabel_lan.text = "\(currectTimes)"+"/"+"\(currectModel.repeattimes)"
            //防止暂停 在开启之后播放这个播放器的音乐
            if numAvplayer != nil {
                numAvplayer = nil
            }
//            //出现休息页面
            if currectModel.resttimelen > 0 {
                //有休息时间
                //此处判断是不是最后一个数据 是就没有休息 直接结束页面
                if currectModelNum == dataModel.courseActGifs.count {
                    //结束页面
                    self.uploadData()
                } else {
                    //休息
                    self.haveBreak()
                }
            } else {
                if currectModelNum == dataModel.courseActGifs.count {
                    //结束页面
                    self.uploadData()
                } else {
                    //没有休息时间
                    self.setUpNextModel()
                }

            }
        } else {
            //进度条 * Float(currectTimes - 1) * Float(currectActionTime)
//            let pro : Float = Float(currectProScale) * Float(currectActionTime)
            //1 2 3 4时间报时
            self.playTimeVideo(currectTime: currectTimes)
            //讲解音
            //self.findGuideViedo(currectTime: currectTimes)
            //进度条
            totlaPro = totlaPro + Float(currectProScale)
            KFBLog(message: "当前总进度\(totlaPro)")
            progressView.setProgress(totlaPro, animated: true)
            pro_lan.setProgress(totlaPro, animated: true)
            progressTinView.frame.origin = CGPoint(x: CGFloat(totlaPro) * progressView.frame.width, y:progressTinView.frame.origin.y )
            progressTinView_land.frame.origin = CGPoint(x: CGFloat(totlaPro) * pro_lan.frame.width , y:-3)
            //次数显示
            currectTimeLabel.text = "\(currectTimes)"
            currectTimeLabel_lan.text = "\(currectTimes)"+"/"+"\(currectModel.repeattimes)"
        }
    }
    // MARK: 动作坚持时间计时
    func actionLastTimeTimer()  {
        KFBLog(message: "动作坚持计时")
        actionLastTime += 1
        KFBLog(message: "当前时间\(actionLastTime)总坚持时间\(currectModel.lastseconds)")
        starDate = NSDate()
        if actionLastTime == currectModel.lastseconds+1 {
            //该动作结束
            KFBLog(message: "动作坚持结束")
            time.invalidate()
            time = nil
            actionLastTime = 1
            totlaPro = totlaPro + Float(currectProScale)
            progressView.progress = totlaPro
            progressTinView.frame.origin = CGPoint(x: CGFloat(totlaPro) * progressView.frame.width, y:progressTinView.frame.origin.y )
            progressTinView_land.frame.origin = CGPoint(x: CGFloat(totlaPro) * pro_lan.frame.width , y:-3)
            currectTimeLabel.text = "\(actionLastTime)"
            currectTimeLabel_lan.text = "\(actionLastTime)"+"/"+"\(currectModel.lastseconds)"
            if numAvplayer != nil {
                numAvplayer = nil
            }
            //出现休息页面
            if currectModel.resttimelen > 0 {
                //有休息时间
                //此处判断是不是最后一个数据 是就没有休息 直接结束页面
                if currectModelNum == dataModel.courseActGifs.count {
                    //结束页面
                    self.uploadData()
                } else {
                    //休息
                    self.haveBreak()
                }
            } else {
                if currectModelNum == dataModel.courseActGifs.count {
                    //结束页面
                    self.uploadData()
                } else {
                    //没有休息时间
                    self.setUpNextModel()
                }
            }
        } else {
            //滴滴时间报时
            self.playTimeVideo_didi()
            //讲解音
           // self.findGuideViedo(currectTime: actionLastTime)

            //时间坚持
            KFBLog(message: "动作坚持\(actionLastTime)")
            currectTimeLabel.text = "\(actionLastTime)"
            currectTimeLabel_lan.text = "\(actionLastTime)"+"/"+"\(currectModel.lastseconds)"

            //进度条
//            let pro : Float = Float(currectProScale) *  Float(currectActionTime)
            totlaPro = totlaPro + Float(currectProScale)
            KFBLog(message: "当前总进度\(totlaPro)")
            progressView.setProgress(totlaPro, animated: true)
            pro_lan.setProgress(totlaPro, animated: true)
            progressTinView.frame.origin = CGPoint(x: CGFloat(totlaPro) * progressView.frame.width, y:progressTinView.frame.origin.y )
            progressTinView_land.frame.origin = CGPoint(x: CGFloat(totlaPro) * pro_lan.frame.width , y:-3)
        }
    }

    // MARK: 休息
    func haveBreak()  {
        //播放休息一下吧
        let backUrlStr = Bundle.main.path(forResource: "休息一下吧", ofType: "mp3")
        let backUrl  = URL(fileURLWithPath: backUrlStr!)
        do {
            avplayer = try AVAudioPlayer(contentsOf: backUrl)
            avplayer?.volume = 1.0
            avplayer?.delegate = self
        } catch _{
            avplayer = nil
        }
        avplayer?.play()
  
        //添加休息
        //let model : ActionGifModel = dataModel.courseActGifs[currectModelNum]
        if isLanUI {
            restView_lan.setTitle(name: currectModel.nextActName)
            restView_lan.setSecond(num: currectRestTime)
            self.view.window?.addSubview(restView_lan)
        } else {
            restView.setUpUI(title: currectModel.wisdom, actionName: currectModel.nextActName)
            restView.setSecond(num: currectRestTime)
            self.view.window?.addSubview(restView)
        }
        //暂停 计时
        time = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(StartLessonViewController.restTime), userInfo: nil, repeats: true)
    }

     // MARK: 跳出休息
    func jumpRestDelegate() {
        MobClick.event("022")
        KFBLog(message: "跳出休息")
        currectRestTime = 1
        self.restTime()
    }
    // MARK: 休息后下一个动作
    func restTime()  {
        //蒙版移除
        currectRestTime -= 1
        if currectRestTime ==  0{
            restView.setSecond(num: 0)
            restView_lan.setSecond(num: 0)
            currectRestTime = 0
            restView.removeFromSuperview()
            restView_lan.removeFromSuperview()
            time.invalidate()
            time = nil
            //下一个动作
            self.setUpNextModel()
        } else {
            restView.setSecond(num: currectRestTime)
            restView_lan.setSecond(num: currectRestTime)
        }

    }
    // MARK: 切换下一个动作
    func setUpNextModel()  {
        //填充下一次数据  这里需要判断下一个模型是按时计算还是按次数计时
        if (currectModelNum) >= dataModel.courseActGifs.count{

        } else {
            let nestModel : ActionGifModel = dataModel.courseActGifs[currectModelNum]
            KFBLog(message: "移除蒙版当前模型index\(currectModelNum)")
            if nestModel.repeattimes == 0 {
                //按时间
                self.setUpDataSecond()
            }
            if nestModel.lastseconds == 0 {
                //次数
                self.setUpData()
            }
        }

    }

    // MARK: 是否有指导音频  坚持时间的时候
    func findGuideViedo(currectTime : Int) {
        if !(guideVideosArr.count > 0) {
            KFBLog(message: "音频数组没有数据")
            return
        }

        if guideVideosArr.contains(currectTime) {
            KFBLog(message: "当前时间有指导音\(currectTime)")
            let urlStr = Bundle.main.path(forResource: "sound_\(currectTime)", ofType: "mp3")
            let url  = URL(fileURLWithPath: urlStr!)
            do {
                giudeAvplayer = try AVAudioPlayer(contentsOf: url)

                giudeAvplayer?.play()
            }  catch let error as NSError{
                KFBLog(message: "指导音音乐播放错误"+error.debugDescription)
                giudeAvplayer = nil
            }


        } else {
            KFBLog(message: "当前时间没有指导音")
        }
    }
    // MARK: 时间报时
    func playTimeVideo(currectTime : Int) {
        let urlStr = Bundle.main.path(forResource: "sound_\(currectTime)", ofType: "mp3")
        let url  = URL(fileURLWithPath: urlStr!)
        do {
            numAvplayer = try AVAudioPlayer(contentsOf: url)
            numAvplayer?.play()
        } catch let error as NSError{
            KFBLog(message: "时间播放错误"+error.debugDescription)
            numAvplayer = nil
        }


    }

    func playTimeVideo_didi(){
        let urlStr = Bundle.main.path(forResource: "timer", ofType: "mp3")
        let url  = URL(fileURLWithPath: urlStr!)
        do {
            numAvplayer = try AVAudioPlayer(contentsOf: url)
            numAvplayer?.play()
        } catch let error as NSError{
            KFBLog(message: "时间播放错误"+error.debugDescription)
            numAvplayer = nil
        }
    }

    func backClick()  {
        let alertController = UIAlertController(title: "", message: "训练中途退出，本次训练记录将不会被保存", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            //取消
            MobClick.event("023")
            alertController.dismiss(animated: true, completion: {

            })

        }
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            //确定
            MobClick.event("024")
            self.removePlayers()
            self.dismiss(animated: true, completion: {

            })
        }
        alertController.addAction(cancleAction)
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)



    }

    func removePlayers() {
        if time != nil {
            time.invalidate()
            time = nil
        }
        if time2 != nil {
            time2.invalidate()
            time2 = nil
        }
        if time3 != nil {
            time3.invalidate()
            time3 = nil
        }

        //背景音暂停
        if backGroundAvplayer != nil{
            if (backGroundAvplayer?.isPlaying)! {
                backGroundAvplayer?.stop()
            }
            backGroundAvplayer = nil
        }

        //讲解音，倒计时，休息
        if avplayer != nil{
            if (avplayer?.isPlaying)! {
                avplayer?.stop()
            }
            avplayer = nil
        }
        //指导音乐
        if giudeAvplayer != nil{
            if (giudeAvplayer?.isPlaying)! {
                giudeAvplayer?.stop()
            }
            giudeAvplayer = nil
        }
        //报数 ---time 管理
        if numAvplayer != nil{
            if (numAvplayer?.isPlaying)! {
                numAvplayer?.stop()
            }
            numAvplayer = nil
        }
    }

//    override func navigationLeftBtnClick() {
//        if time.isValid {
//            time.invalidate()
//            time = nil
//        }
//        if time2.isValid {
//            time2.invalidate()
//            time2 = nil
//        }
//        if time3.isValid {
//           time3.invalidate()
//           time3 = nil
//        }
//        //gifImageView = nil
//        if (avplayer?.isPlaying)! {
//            avplayer = nil
//        }
//        if (backGroundAvplayer?.isPlaying)! {
//            backGroundAvplayer = nil
//        }
//        if (giudeAvplayer?.isPlaying)! {
//            giudeAvplayer = nil
//        }
//        if (numAvplayer?.isPlaying)! {
//            numAvplayer = nil
//        }
//        _=self.dismiss(animated: true, completion: {
//
//        })
//    }

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
