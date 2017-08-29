//
//  DiagnoseViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/11/5.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AVFoundation

class DiagnoseViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var doctorPlayer:AVPlayer? = nil
    var doctorVideoUrlString : String! = "x"//解说视频连接
    var isPlay:Int = 0
    var isDoctorPlaying:Bool = false
    var isTestPlaying:Bool = false

    
    let playButton :UIButton = UIButton(type: UIButtonType.custom)//播放开始按钮
    var videoControlView:UIView!
    var videoBackView:UIView!
    
    var videoUrlString : String! = "x"//视频连接

    var avPlayer:AVPlayer? = nil

    var deliverParentPositionId:Int = 0//伤病位置的父级菜单id
    var deliverPositionId:Int = 0//伤病位置的二级菜单id

//    var deliverModel : DetailInguryPositionModel!
    var positionId:Int = 0
    var AMenuId:Int = 0
    var selectedId:Int = 0

    var _mainTableView:UITableView!
    var headBgView:UIView!

     var nextButton : UIButton = UIButton(type: UIButtonType.custom)
    
    let request = InguryDataManger.sharedInstance

    var dataModel : FirstInguryModel = FirstInguryModel()
    var detailInguryTempModel: ThirdInguryModel!//选择的cell的model

    var createProgramModel : CreateProgramModel = CreateProgramModel()
    var postDic:Dictionary<String,Int> = ["初始化":0]//最后上传的字典

    var helpDetailView:UIView!
    var tempHelpModel: SecondInguryModel!//问号点击弹出框的model
    
    
    // MARK: helpView懒加载
    lazy var helpView : UIView = { () -> UIView in
        
        let helpView:UIView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT))
        helpView.backgroundColor = UIColor.black
        helpView.alpha = 0.7
        return helpView
    }()
    
    // MARK: helpDetailView
    
    func setHelpDetailView(helpModel:SecondInguryModel) -> UIView {
        
        let helpDetailView:UIView = UIView(frame:CGRect(x:ip6(40),y:100,width:KSCREEN_WIDTH-ip6(80),height:200))
        helpDetailView.backgroundColor = UIColor.white
        helpDetailView.alpha = 1
        
        let helpLabelHeight:CGFloat = helpModel.helpWords.getLabHeight(labelStr: helpModel.helpWords, font: UIFont.systemFont(ofSize: 15), LabelWidth: helpDetailView.frame.size.width-ip6(40))
        
        if(helpModel.helpPic==""){
            helpDetailView.frame.size.height = ip6(100)+helpLabelHeight+ip6(20)
        }else{
            helpDetailView.frame.size.height = ip6(100)+helpLabelHeight+ip6(20)+ip6(135)
        }
        helpDetailView.center = (self.view.window?.center)!
        
        
        let titleLabel = UILabel(frame:CGRect(x:0,y:ip6(10),width:helpDetailView.frame.size.width,height:ip6(25)))
        titleLabel.text = "说明"
        titleLabel.textColor = GRAY656A72_COLOUR
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = NSTextAlignment.center
        helpDetailView.addSubview(titleLabel)
        
        
        let helpLineView:UIView = UIView(frame:CGRect(x:0,y:ip6(44),width:helpDetailView.frame.size.width,height:1))
        helpLineView.backgroundColor = LINE_COLOUR
        helpDetailView.addSubview(helpLineView)
        
        
        let helpDetailLabel = UILabel(frame:CGRect(x:ip6(20),y:ip6(55),width:helpDetailView.frame.size.width-ip6(40),height:helpLabelHeight))
        helpDetailLabel.text = helpModel.helpWords
        helpDetailLabel.textColor = GRAY999999_COLOUR
        helpDetailLabel.font = UIFont.systemFont(ofSize: 15)
        helpDetailLabel.textAlignment = NSTextAlignment.left
        helpDetailLabel.numberOfLines = 0
        helpDetailView.addSubview(helpDetailLabel)
        
        
        if(helpModel.helpPic==""){
        }else{
            let helpImageView = UIImageView(frame:CGRect(x:ip6(20),y:ip6(75)+helpLabelHeight,width:helpDetailView.frame.size.width-ip6(40),height:ip6(115)))
            helpImageView.setImageWith(URL.init(string: helpModel.helpPic.getImageStr())!, placeholderImage: UIImage.init(named: "course_placeholder_big"))
            helpDetailView.addSubview(helpImageView)
        }
        
        let helpButton : UIButton = UIButton(type: UIButtonType.custom)
        helpButton.frame = CGRect(x:0,y:helpDetailView.frame.size.height - ip6(45),width:helpDetailView.frame.size.width,height:ip6(45))
        helpButton.setTitle("我知道了", for: .normal)
        helpButton.setTitleColor(UIColor.white, for: .normal)
        helpButton.backgroundColor = GREEN_COLOUR
        helpButton.addTarget(self, action:#selector(self.helpClick) , for: UIControlEvents.touchUpInside)
        helpDetailView.addSubview(helpButton)
        return helpDetailView
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
        if (self.avPlayer != nil) {
            
            self.avPlayer?.pause()
            isTestPlaying = false
        }
        
        if (self.doctorPlayer != nil) {
            if isDoctorPlaying {
                self.doctorPlayer?.pause()
            }
            isDoctorPlaying = false
        }
        
        if (videoBackView != nil && videoControlView != nil) {
            videoBackView.addSubview(videoControlView)
        }

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        naviagtionTitle(titleName: "伤病详情")
        navigationBar_leftBtn()

        createTableView()
        
        setBottomView()

        getData()

        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidEnterPlayGround), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        
        // Do any additional setup after loading the view.
    }

    
    func appDidEnterBackground() {
        
        KFBLog(message: "进入后台")
        if isDoctorPlaying {
            self.doctorPlayer?.pause()
        }
        self.avPlayer?.pause()

    }
    
    func appDidEnterPlayGround() {
        
        KFBLog(message: "进入前台")
        if isTestPlaying {
            videoBackView.addSubview(videoControlView)
//            self.avPlayer?.play()
        }
        if isDoctorPlaying {
            self.doctorPlayer?.play()
        }


    }
    
    func getData(){
        
        let idStr:String = String(positionId)
        weak var weakSelf = self

        
        if AMenuId == 0 {
            KFBLog(message: "第一页")
            
            request.getInjuryMenu1Data(positionId: idStr, complate: { (data) in
                weakSelf?.dataModel = data as! FirstInguryModel
                weakSelf?._mainTableView .reloadData()
                weakSelf?.isDoctorPlaying = true

            }, faile: { (error) in
                self.KfbShowWithInfo(titleString: error)

            })
            
            

        }else{
            KFBLog(message: "第二页")
            let AMenuIdStr:String = String(AMenuId)
            request.getInjuryMenu2Data(positionId: idStr, AMenuId: AMenuIdStr, complate: { (data) in
                weakSelf?.dataModel = data as! FirstInguryModel
                weakSelf?._mainTableView .reloadData()
                weakSelf?.isDoctorPlaying = true
            }, faile: { (error) in
                self.KfbShowWithInfo(titleString: error)

            })
            
        }
        
    }

    func createTableView() {
        
        _mainTableView = UITableView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT - ip6(80)-64),style:UITableViewStyle.plain)
        _mainTableView.backgroundColor = UIColor.white
        _mainTableView.dataSource = self
        _mainTableView.delegate = self
        _mainTableView.showsVerticalScrollIndicator = false
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.view.addSubview(_mainTableView)
        
    }

    func setBottomView() {
        
        KFBLog(message: self.view.frame.size.height)

        
        let bottomView  = UIView(frame:CGRect(x:0,y:KSCREEN_HEIGHT - ip6(80)-64,width:KSCREEN_WIDTH,height:ip6(80)))
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        nextButton.setTitle("未选择", for: UIControlState.normal)
        nextButton.layer.cornerRadius = 2
        nextButton.layer.masksToBounds = true
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        nextButton.frame = CGRect(x: KSCREEN_WIDTH-ip6(125), y:ip6(24), width:ip6(75), height: ip6(32))
        nextButton.setTitleColor( UIColor.white , for: UIControlState.normal)
        nextButton.backgroundColor = GRAY999999_COLOUR
        nextButton.addTarget(self, action:#selector(self.nextClick) , for: UIControlEvents.touchUpInside)
        bottomView.addSubview(nextButton)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section==0 {
            return ip6(365)
        }else{
            return 60
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section==0 {
            return 0
        }else{
            
            if self.dataModel.datas.count>0 {
                let model = self.dataModel.datas[0]
                return model.Bmenu.count

            }else{
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section==0 {
            return createHeadView()
        }else{
            return createSectionHeadView(sectionIndex: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    //顶部view
    func createHeadView() -> UIView {
        
        let headView:UIView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:ip6(365)))
        headView.backgroundColor = UIColor.white
        
        let titleLabel = UILabel(frame:CGRect(x:0,y:ip6(15),width:KSCREEN_WIDTH,height:ip6(20)))
        titleLabel.text = "请跟随视频动作检查您的伤病"
        titleLabel.textColor = DARK_COLOUR_SELECTED
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = NSTextAlignment.center
        headView.addSubview(titleLabel)
        
        if self.dataModel.datas.count>0{

            let tempModel = self.dataModel.datas[0]
            KFBLog(message: tempModel.guidevideo)

            if (tempModel.guidevideo != nil) {
                doctorVideoUrlString = tempModel.guidevideo
                KFBLog(message: doctorVideoUrlString)
                
            }
        }
        
        let URLString = URL.init(string: doctorVideoUrlString.getImageStr())
        
        let doctorVideoItem = AVPlayerItem(url:URLString!)
        doctorPlayer = AVPlayer(playerItem:doctorVideoItem)
        let playerLayer = AVPlayerLayer.init(player: self.doctorPlayer)
        playerLayer.frame = CGRect(x:KSCREEN_WIDTH/2-ip6(37),y:ip6(50),width:ip6(74),height:ip6(74))
        playerLayer.cornerRadius = ip6(37)
        playerLayer.masksToBounds = true
        headView.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.doctorVideoPlayerEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: doctorVideoItem)
        
        if isPlay < 2 {
            self.doctorPlayer?.play()
            isPlay += 1
        }

        videoBackView = UIView(frame:CGRect(x:ip6(30),y:ip6(155),width:KSCREEN_WIDTH-ip6(60),height:ip6(170)))
        videoBackView.backgroundColor = UIColor.white
        headView.addSubview(videoBackView)
        

        let videoTitleLabel = UILabel(frame:CGRect(x:0,y:ip6(190),width:videoBackView.frame.size.width,height:ip6(20)))
        
        if self.dataModel.datas.count>0 {
           let tempModel = self.dataModel.datas[0]
            videoTitleLabel.text = tempModel.menuname
            
            
            if (tempModel.testvideourl != nil) {
                videoUrlString = tempModel.testvideourl
                
                KFBLog(message: "-------")
                KFBLog(message: videoUrlString)
            }
            //MARK:测试视频
            
            let URLString = URL.init(string: videoUrlString.getImageStr())
            
            
            let videoItem = AVPlayerItem(url:URLString!)
            avPlayer = AVPlayer(playerItem:videoItem)
            let playerLayer = AVPlayerLayer.init(player: self.avPlayer)
            playerLayer.frame = CGRect(x:0,y:0,width:videoBackView.frame.size.width,height:videoBackView.frame.size.height)
            videoBackView.layer.addSublayer(playerLayer)
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill

            
            NotificationCenter.default.addObserver(self, selector: #selector(self.videoPlayerEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoItem)
            
            self.avPlayer?.seek(to: kCMTimeZero)

            
            videoControlView = UIView(frame:CGRect(x:0,y:0,width:videoBackView.frame.size.width,height:videoBackView.frame.size.height))
            videoControlView.backgroundColor = UIColor.black
            videoControlView.alpha = 0.6
            videoBackView.addSubview(videoControlView)
            
            playButton.frame = CGRect(x:videoBackView.frame.size.width/2-ip6(25),y:videoBackView.frame.size.height/2-ip6(25),width:ip6(50),height:ip6(50))
            
            playButton.setImage(UIImage(named:"course_reststar"), for: UIControlState.normal)
            playButton.addTarget(self, action:#selector(self.playerClick) , for: UIControlEvents.touchUpInside)

            videoControlView.addSubview(playButton)
            
            
        }
        videoTitleLabel.textColor = DARK_COLOUR_SELECTED
        videoTitleLabel.font = UIFont.systemFont(ofSize: 15)
        videoTitleLabel.textAlignment = NSTextAlignment.center
        videoBackView.addSubview(videoTitleLabel)

        
        
        return headView
    }
    
    func playerClick() {
        
        
        if self.doctorPlayer != nil {
            if isDoctorPlaying == true {
                self.doctorPlayer?.pause()
                isDoctorPlaying = false
            }
        }
        
        self.videoControlView.removeFromSuperview()
        self.avPlayer?.play()
        isTestPlaying = true

    }
    
    func videoPlayerEnd() {
        KFBLog(message: "播放结束")
        self.avPlayer?.seek(to: kCMTimeZero)
        videoBackView.addSubview(videoControlView)
    }
    
    func doctorVideoPlayerEnd() {
        KFBLog(message: "医生播放结束")
        self.doctorPlayer?.seek(to: kCMTimeZero)
        isDoctorPlaying = false
    }

    func createSectionHeadView(sectionIndex:Int) -> UIView {
        
        headBgView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:60))
        headBgView.backgroundColor = UIColor.white
        
        let painSectionTitleLabel = UILabel(frame:CGRect(x:50,y:8,width:KSCREEN_WIDTH - 100,height:44))
        
        if self.dataModel.datas.count > 0 {
            let tempModel = self.dataModel.datas[sectionIndex]
            painSectionTitleLabel.text = tempModel.menuname
            painSectionTitleLabel.frame.size.width = tempModel.menuname.getLabWidth(labelStr: tempModel.menuname, font: UIFont.systemFont(ofSize: 15), LabelHeight: 44)

            //问号?
            let questionImageView = UIImageView(frame:CGRect(x:50 + painSectionTitleLabel.frame.size.width,y:1,width:36,height:58))
            questionImageView.image = #imageLiteral(resourceName: "questionMark")
            questionImageView.isUserInteractionEnabled = true
            let helpTap = UITapGestureRecognizer(target:self,action:(#selector(self.helpTapClick(tapGesture:))))
            
            questionImageView.addGestureRecognizer(helpTap)
            
            if tempModel.help == 1 {
                headBgView.addSubview(questionImageView)
            }

        }
        painSectionTitleLabel.textColor = GRAY656A72_COLOUR
        painSectionTitleLabel.backgroundColor = UIColor.white
        painSectionTitleLabel.font = UIFont.systemFont(ofSize: 15)
        painSectionTitleLabel.textAlignment = NSTextAlignment.left
        headBgView.addSubview(painSectionTitleLabel)
        
        let bottomLineView = UIView(frame:CGRect(x:50,y:59,width:KSCREEN_WIDTH-100,height:1))
        bottomLineView.backgroundColor = LINE_COLOUR
        headBgView.addSubview(bottomLineView)
        
        
        return headBgView
        
    }
    
    func helpTapClick(tapGesture:UITapGestureRecognizer) {
        
        self.tempHelpModel = self.dataModel.datas[0]
        
        helpDetailView = self.setHelpDetailView(helpModel: self.tempHelpModel)
        
        self.view.window?.addSubview(helpView)
        
        self.view.window?.addSubview(helpDetailView)
        
    }
    
    
    func helpClick() {
        
        helpDetailView.removeFromSuperview()
        helpDetailView = nil
        helpView.removeFromSuperview()
        
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "reuseIdentifier\(indexPath.section)\(indexPath.row)"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        var painSelectedImageView:UIImageView!
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:identifier)
            
            //读取数据源
            if (indexPath.section > 0) {
                
                let tempModel = self.dataModel.datas[indexPath.section-1]
                let detailTempModel = tempModel.Bmenu[indexPath.row]
                
                let painTitleLabel = UILabel(frame:CGRect(x:70,y:5,width:KSCREEN_WIDTH-150,height:30))
                painTitleLabel.text = detailTempModel.menuname
                painTitleLabel.textColor = GRAY999999_COLOUR
                painTitleLabel.font = UIFont.systemFont(ofSize: 13)
                painTitleLabel.textAlignment = NSTextAlignment.left
                cell?.contentView.addSubview(painTitleLabel)
                
                painSelectedImageView = UIImageView(frame:CGRect(x:KSCREEN_WIDTH-76,y:15,width:10,height:10))
                painSelectedImageView.layer.cornerRadius = 5
                painSelectedImageView.layer.masksToBounds = true
                painSelectedImageView.tag = 100
                
                cell?.contentView.addSubview(painSelectedImageView)
            }
        }
        
        if (indexPath.section > 0) {
            
            let tempModel = self.dataModel.datas[indexPath.section-1]
            
            let detailTempModel = tempModel.Bmenu[indexPath.row]
            
            if (detailTempModel.isSelect == 1) {
                
                (cell!.contentView.viewWithTag(100) as! UIImageView).image = UIImage(named:"circle_icon_selected")
            }else{
                
                (cell!.contentView.viewWithTag(100) as! UIImageView).image = UIImage(named:"circle_icon_noSelected")
            }
            
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section > 0 {
            
            let tempModel = self.dataModel.datas[indexPath.section-1]
            
            detailInguryTempModel = tempModel.Bmenu[indexPath.row]
            
            if (detailInguryTempModel.isSelect == 1) {
                
                detailInguryTempModel.isSelect = 0
                selectedId = 0
                nextButton.setTitle("未选择", for: UIControlState.normal)
                nextButton.backgroundColor = GRAY999999_COLOUR

                
            }else{
                
                for model1 in tempModel.Bmenu {
                    
                    model1.isSelect = 0
                }
                
                self.dataModel.datas[indexPath.section-1].Bmenu[indexPath.row].isSelect = 1
                selectedId = self.dataModel.datas[indexPath.section-1].Bmenu[indexPath.row].injuryinfomenuid
                
                if self.dataModel.datas[indexPath.section-1].Bmenu[indexPath.row].istestpage >= 0 {
                    
                    nextButton.setTitle("下一步", for: UIControlState.normal)
                }else{
                    
                    if AMenuId == 0{
                        nextButton.setTitle("下一步", for: UIControlState.normal)

                    }else{
                        nextButton.setTitle("完成", for: UIControlState.normal)

                    }

                }
                
                nextButton.backgroundColor = GREEN_COLOUR
                
            }
            
            let indexSet:NSIndexSet = NSIndexSet(index:1)
            _mainTableView.reloadSections(indexSet as IndexSet, with: UITableViewRowAnimation.fade)
            
        }
    }
    
    func nextClick() {
        
        //整理数据发给后台
        for tempModel in self.dataModel.datas {
            
            for model in tempModel.Bmenu {
                
                if model.isSelect == 1 {
                    
                    let strVar : String = String(model.parentmenuid)
                    
                    postDic[strVar] = model.injuryinfomenuid
                    
                }
            }
        }
        
        postDic.removeValue(forKey: "初始化")

        
        if nextButton.titleLabel?.text == "未选择" {
            KfbShowWithInfo(titleString: "请选择是否疼痛")
        }else if nextButton.titleLabel?.text == "完成"{
            //这里都是肌肉测试完成的
            
            KFBLog(message: self.deliverPositionId)
            KFBLog(message: self.deliverParentPositionId)
            KFBLog(message: postDic)

            //MARK:上传数据
            weak var weakSelf = self
            self.SVshow(infoStr: "正在生成康复方案")

            request.createProgram(parentPositionId: self.deliverParentPositionId, positionId: self.deliverPositionId, createDict: postDic, complate: { (data) in
                weakSelf?.createProgramModel = data as! CreateProgramModel
                weakSelf?.SVdismiss()
                if  (weakSelf?.createProgramModel.status)! > 0{
                    KFBLog(message: weakSelf?.createProgramModel.msg)
                    //                    weakSelf?.KfbShowWithInfo(titleString: (weakSelf?.createProgramModel.msg)!)
                    let vc:MyRecurePlanViewController = MyRecurePlanViewController()
                    vc.hidesBottomBarWhenPushed = true
                    vc.newProgram = 1
                    weakSelf?.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    KFBLog(message: weakSelf?.createProgramModel.msg)
                    weakSelf?.KfbShowWithInfo(titleString: (weakSelf?.createProgramModel.msg)!)
                    
                }

            }, failure: { (error) in
                weakSelf?.SVdismiss()
                
                weakSelf?.KfbShowWithInfo(titleString: "康复方案生成失败，请重试")
            })
            

        }else{
            
            if AMenuId == 0 {
                
                //膝盖开始
                    if detailInguryTempModel.istestpage > 0 {
                        KFBLog(message: "继续检测")
                        
                        let vc:NextDiagnoseViewController = NextDiagnoseViewController()
                        vc.hidesBottomBarWhenPushed = true
                        vc.indexTest = 1
                        vc.fromId = 1
                        vc.postDic = postDic
                        vc.deliverPositionId = self.deliverPositionId
                        vc.deliverParentPositionId = self.deliverParentPositionId
                        vc.dataModel = self.dataModel
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        KFBLog(message: "详情")
                        let vc:DetailOfPainViewController = DetailOfPainViewController()
                        vc.hidesBottomBarWhenPushed = true
                        vc.AMenuId = detailInguryTempModel.injuryinfomenuid
                        vc.positionId = detailInguryTempModel.positionid
                        vc.fromId = 1
                        vc.postDic = postDic
                        vc.deliverPositionId = self.deliverPositionId
                        vc.deliverParentPositionId = self.deliverParentPositionId
                        self.navigationController?.pushViewController(vc, animated: true)

                    }
                
            }else{
                
                if self.dataModel.datas.count > 1 {
                    
                    let vc:NextDiagnoseViewController = NextDiagnoseViewController()
                    vc.hidesBottomBarWhenPushed = true
                    vc.indexTest = 1
                    vc.fromId = 0
                    vc.postDic = postDic
                    vc.deliverPositionId = self.deliverPositionId
                    vc.deliverParentPositionId = self.deliverParentPositionId
                    vc.dataModel = self.dataModel
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }

        }
        
        
        
    }

    deinit {
        //记得移除通知监听
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func navigationLeftBtnClick() {
        _=self.navigationController?.popViewController(animated: true)
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
