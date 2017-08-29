//
//  DetailOfPainViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/21.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AVFoundation

class DetailOfPainViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{

    var doctorPlayer:AVPlayer? = nil
    var isPlaying:Bool = false

    
    var deliverParentPositionId:Int = 0//伤病位置的父级菜单id
    var deliverPositionId:Int = 0//伤病位置的二级菜单id
    var deliverModel : DetailInguryPositionModel!//上个页面传过来的model
    
    
    var fromId:Int = 0//0其他，1膝盖的
    var AMenuId:Int = 0//膝盖的
    var positionId:Int = 0//膝盖的
    
    var _mainTableView:UITableView!

    var headBgView:UIView!
    
    var painSectionSelectedLabel:UILabel!

    
    var nextButton : UIButton = UIButton(type: UIButtonType.custom)
    
    let request = InguryDataManger.sharedInstance

    var dataModel : FirstInguryModel = FirstInguryModel()//请求回来的大模型

    var detailInguryTempModel: ThirdInguryModel!//选择的cell的model

    var noSelectModel: SecondInguryModel!//信息不完整的model

    var createProgramModel : CreateProgramModel = CreateProgramModel()
    var postDic:Dictionary<String,Int> = ["初始化":0]//最后上传的字典
    
    var helpDetailView:UIView!
    var tempHelpModel: SecondInguryModel!//问号点击弹出框的model

    
    // MARK: 头部view懒加载
    lazy var headView : UIView = { () -> UIView in
        
        let headView:UIView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:ip6(165)))
        headView.backgroundColor = UIColor.white
        
        let titleLabel = UILabel(frame:CGRect(x:0,y:ip6(15),width:KSCREEN_WIDTH,height:ip6(20)))
        titleLabel.text = "请详细描述您的伤病情况"
        titleLabel.textColor = DARK_COLOUR_SELECTED
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = NSTextAlignment.center
        headView.addSubview(titleLabel)
        
        
        var videoUrlString:String = self.dataModel.guidevideo
        
        let URLString = URL.init(string: videoUrlString.getImageStr())
        
        let videoItem = AVPlayerItem(url:URLString!)
        self.doctorPlayer = AVPlayer(playerItem:videoItem)
        let playerLayer = AVPlayerLayer.init(player: self.doctorPlayer)
        playerLayer.frame = CGRect(x:KSCREEN_WIDTH/2-ip6(37),y:ip6(50),width:ip6(74),height:ip6(74))
        playerLayer.cornerRadius = ip6(37)
        playerLayer.masksToBounds = true
        headView.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(self.doctorVideoPlayerEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoItem)
        self.doctorPlayer?.play()

        return headView
        
    }()

    
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

        if (self.doctorPlayer != nil) {
            self.doctorPlayer?.pause()
            isPlaying = false
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        naviagtionTitle(titleName: "伤病情况")
        navigationBar_leftBtn()
        
        getData()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidEnterPlayGround), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        

        
        // Do any additional setup after loading the view.
    }

    func appDidEnterBackground() {
        
        KFBLog(message: "进入后台")
        self.doctorPlayer?.pause()
        
        
    }
    
    func appDidEnterPlayGround() {
        
        KFBLog(message: "进入前台")
        if isPlaying {
            self.doctorPlayer?.play()
        }
        
    }

    
    func getData(){
    
        weak var weakSelf = self
        if fromId == 0 {
            let idStr:String = String(deliverModel.positionid)
            
            request.getInjuryMenu1Data(positionId: idStr, complate: { (data) in
                weakSelf?.dataModel = data as! FirstInguryModel
                weakSelf?.createTableView()
                weakSelf?.setBottomView()
                weakSelf?.isPlaying = true
            }, faile: { (error) in
                self.KfbShowWithInfo(titleString: error)

            })
            
        }else{
            
            //膝盖的二级
            let AMenuIdStr:String = String(AMenuId)
            let idStr:String = String(positionId)
            
            request.getInjuryMenu2Data(positionId: idStr, AMenuId: AMenuIdStr, complate: { (data) in
                weakSelf?.dataModel = data as! FirstInguryModel
                weakSelf?.createTableView()
                weakSelf?.setBottomView()
            }, faile: { (error) in
                self.KfbShowWithInfo(titleString: error)

            })

        }
        
    }
    
    func createTableView() {
        
        _mainTableView = UITableView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT-64 - ip6(80)),style:UITableViewStyle.plain)
        _mainTableView.backgroundColor = UIColor.white
        _mainTableView.dataSource = self
        _mainTableView.delegate = self
        _mainTableView.showsVerticalScrollIndicator = false
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.view.addSubview(_mainTableView)
        
    }

    
    
    func setBottomView() {
        
        let bottomView  = UIView(frame:CGRect(x:0,y:KSCREEN_HEIGHT-64 - ip6(80),width:KSCREEN_WIDTH,height:ip6(80)))
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
        return (self.dataModel.datas.count + 1)
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section==0 {
            return ip6(165)
        }else{
            return 60
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section==0 {
            return 0
        }else{
            
            let model = self.dataModel.datas[section-1]
            
            if (model.isShow > 0){
                return model.Bmenu.count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section==0 {
            return createHeadView()
        }else{
            return createSectionHeadView(sectionIndex: section-1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
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

                let painTitleLabel = UILabel(frame:CGRect(x:70,y:10,width:KSCREEN_WIDTH-150,height:40))
                painTitleLabel.text = detailTempModel.menuname
                painTitleLabel.textColor = GRAY999999_COLOUR
                painTitleLabel.numberOfLines = 2
                painTitleLabel.adjustsFontSizeToFitWidth = true
                painTitleLabel.font = UIFont.systemFont(ofSize: 13)
                painTitleLabel.textAlignment = NSTextAlignment.left
                cell?.contentView.addSubview(painTitleLabel)
                
                painSelectedImageView = UIImageView(frame:CGRect(x:KSCREEN_WIDTH-76,y:25,width:10,height:10))
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
                
            }else{
                
                    for model1 in tempModel.Bmenu {
                        
                        model1.isSelect = 0
                    }
                
                self.dataModel.datas[indexPath.section-1].Bmenu[indexPath.row].isSelect = 1
                
                //自动收起
                tempModel.isShow = 0
                
            }

            var isAllSelect = 1

            for tempModel in self.dataModel.datas {
                
                var isSelect = 0

                for model in tempModel.Bmenu {
                    
                    if model.isSelect == 1 {
                        isSelect = 1
                        break
                    }
                    
                }
                
                if isSelect == 0 {
                    isAllSelect = 0
                    break
                }
            }
            
            if isAllSelect == 1 {
                
                var isNext = 0
                
                for tempModel in self.dataModel.datas {
                    
                    for model in tempModel.Bmenu {
                        
                        if model.isSelect == 1 {
                            
                            if model.istestpage  >= 0 {
                                nextButton.setTitle("下一步", for: UIControlState.normal)
                                nextButton.backgroundColor = GREEN_COLOUR
                                
                                isNext = 1
                                break
                            }else{
                                nextButton.setTitle("完成", for: UIControlState.normal)
                                nextButton.backgroundColor = GREEN_COLOUR
                            }
                        }
                    }
                    
                    if isNext == 1 {
                        break
                    }
                }
                
            }else{
                nextButton.setTitle("未选择", for: UIControlState.normal)
                nextButton.backgroundColor = GRAY999999_COLOUR
            }
            
            _mainTableView .reloadData()
//            let indexSet:NSIndexSet = NSIndexSet(index:indexPath.section)
//            _mainTableView.reloadSections(indexSet as IndexSet, with: UITableViewRowAnimation.fade)
            
        }
    }
    
    
    //顶部view
    func createHeadView() -> UIView {
        
        return headView
    }
    
    func doctorVideoPlayerEnd() {
        KFBLog(message: "播放结束")
        isPlaying = false
    }

    
    func createSectionHeadView(sectionIndex:Int) -> UIView {
        
        let tempModel = self.dataModel.datas[sectionIndex]

        headBgView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:60))
        headBgView.backgroundColor = UIColor.white
        headBgView.tag = sectionIndex
        
        
        let painSectionTitleLabel = UILabel(frame:CGRect(x:50,y:8,width:KSCREEN_WIDTH/2 - 50,height:44))
        
        painSectionTitleLabel.text = tempModel.menuname
        painSectionTitleLabel.textColor = GRAY656A72_COLOUR
        painSectionTitleLabel.backgroundColor = UIColor.white
        painSectionTitleLabel.font = UIFont.systemFont(ofSize: 15)
        painSectionTitleLabel.textAlignment = NSTextAlignment.left
        
        painSectionTitleLabel.frame.size.width = tempModel.menuname.getLabWidth(labelStr: tempModel.menuname, font: UIFont.systemFont(ofSize: 15), LabelHeight: 44)
        
        //问号?
        let questionImageView = UIImageView(frame:CGRect(x:50 + painSectionTitleLabel.frame.size.width,y:1,width:36,height:58))
        questionImageView.image = #imageLiteral(resourceName: "questionMark")
        questionImageView.isUserInteractionEnabled = true
        questionImageView.tag = 100 + sectionIndex
        let helpTap = UITapGestureRecognizer(target:self,action:(#selector(self.helpTapClick(tapGesture:))))
        
        questionImageView.addGestureRecognizer(helpTap)

        if tempModel.help == 1 {
            headBgView.addSubview(questionImageView)
        }
        
        headBgView.addSubview(painSectionTitleLabel)

   
        painSectionSelectedLabel = UILabel(frame:CGRect(x:questionImageView.frame.maxX + 10,y:8,width:KSCREEN_WIDTH-questionImageView.frame.maxX - 60,height:44))
        for model in tempModel.Bmenu {
            
            if model.isSelect == 1 {
                painSectionSelectedLabel.text = model.menuname
                break
            }
            painSectionSelectedLabel.text = "未选择"
        }
        
        painSectionSelectedLabel.textColor = MAIN_GREEN_COLOUR
        painSectionSelectedLabel.backgroundColor = UIColor.white
        painSectionSelectedLabel.font = UIFont.systemFont(ofSize: 13)
        painSectionSelectedLabel.textAlignment = NSTextAlignment.right
        headBgView.addSubview(painSectionSelectedLabel)
        
        let bottomLineView = UIView(frame:CGRect(x:50,y:59,width:KSCREEN_WIDTH-100,height:1))
        bottomLineView.backgroundColor = LINE_COLOUR
        headBgView.addSubview(bottomLineView)
        
        let sectionViewTap = UITapGestureRecognizer(target:self,action:(#selector(self.titleTapClick(tapGesture:))))
        headBgView.addGestureRecognizer(sectionViewTap)
        
        return headBgView
        
    }

    func titleTapClick(tapGesture:UITapGestureRecognizer) {
    

        let tempModel = self.dataModel.datas[tapGesture.view!.tag]
        
        if (tempModel.isShow == 1) {
            
            for model in self.dataModel.datas {
                model.isShow = 0
            }
        }else{
            for model in self.dataModel.datas {
                model.isShow = 0
            }
            tempModel.isShow = 1
        }
        
        //MARK:刷新部分section
//        let indexSet:NSIndexSet = NSIndexSet(index:tapGesture.view!.tag+1)
//        _mainTableView.reloadSections(indexSet as IndexSet, with: UITableViewRowAnimation.fade)
        _mainTableView.reloadData()

}

    func helpTapClick(tapGesture:UITapGestureRecognizer) {
        
        self.tempHelpModel = self.dataModel.datas[tapGesture.view!.tag - 100]
        
        helpDetailView = self.setHelpDetailView(helpModel: self.tempHelpModel)
        
        self.view.window?.addSubview(helpView)
        
        self.view.window?.addSubview(helpDetailView)

    }
    
    
    func helpClick() {
        
        helpDetailView.removeFromSuperview()
        helpDetailView = nil
        helpView.removeFromSuperview()
    
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
//            KfbShowWithInfo(titleString: "请详细描述您的伤病情况")
            
            for tempModel in self.dataModel.datas {
                
                var isSelect = 0
                
                for model in tempModel.Bmenu {
                    
                    if model.isSelect == 1 {
                        
                        isSelect = 1
                        break
                    }
                }
                
                if isSelect == 0 {
                    noSelectModel = tempModel
                    KfbShowWithInfo(titleString: "请选择\(noSelectModel.menuname!)")
                    return
                    
                }
            }

        }else if nextButton.titleLabel?.text == "完成" {
            
            KFBLog(message: self.deliverPositionId)
            KFBLog(message: self.deliverParentPositionId)
            KFBLog(message: postDic)

            
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
            
            
            for tempModel in self.dataModel.datas {
                var isSelect = 0
                for model in tempModel.Bmenu {
                    if model.isSelect == 1 {
                        isSelect = 1
                        break
                    }
                }
                
                if isSelect == 0 {
                    noSelectModel = tempModel
                    KFBLog(message: "\(noSelectModel.menuname)")
                    
                    let infoString:String = "请选择" + noSelectModel.menuname! as String
                    
                    KfbShowWithInfo(titleString: infoString )

                    return
                }
            }
            
            
            
            var isTestPage = 0
            
            var nextDataModel :ThirdInguryModel = ThirdInguryModel()
            
            for tempModel in self.dataModel.datas {
                
                for model in tempModel.Bmenu {
                    
                    if model.istestpage == 1 {
                        
                        isTestPage = 1
                        nextDataModel = model
                        break
                        
                    }
                }
                if isTestPage == 1 {
                    break
                }
                
            }
            
            
            
            if isTestPage == 1 {
                
                if nextDataModel.istestpage == 1 {
                    
                    let vc:DiagnoseViewController = DiagnoseViewController()
                    vc.hidesBottomBarWhenPushed = true
                    vc.positionId = nextDataModel.positionid
                    vc.AMenuId = nextDataModel.injuryinfomenuid
                    vc.postDic = postDic
                    vc.deliverPositionId = self.deliverPositionId
                    vc.deliverParentPositionId = self.deliverParentPositionId
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    
                    KFBLog(message: "下一个填信息的-现在没有这种情况")
                }
                
                
            }else{
                
                
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
