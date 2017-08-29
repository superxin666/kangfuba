//
//  PartOfPainViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/21.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import AVFoundation

class PartOfPainViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {


    var isPlaying:Bool = false

    var avPlayer:AVPlayer? = nil
    
    var PainTableView:UITableView!
    
    var painDetailLabel:UILabel = UILabel()
    var nextButton : UIButton = UIButton(type: UIButtonType.custom)

    
    let request = InguryDataManger.sharedInstance

    var dataModel : InguryPositionModel = InguryPositionModel()
    
    var selectedDetailTempModel: DetailInguryPositionModel!//选择的cell的model
    
    var createProgramModel : CreateProgramModel = CreateProgramModel()
    var postDic:Dictionary<String,Int> = ["初始化":0]//最后上传的字典

    
    // MARK: 头部view
    lazy var headView : UIView = { () -> UIView in
        
        let headView:UIView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:ip6(280)))
        headView.backgroundColor = UIColor.white
        
        let titleLabel = UILabel(frame:CGRect(x:0,y:ip6(15),width:KSCREEN_WIDTH,height:ip6(20)))
        titleLabel.text = "让我们先了解您的伤病位置"
        titleLabel.textColor = DARK_COLOUR_SELECTED
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = NSTextAlignment.center
        headView.addSubview(titleLabel)
        
        var videoUrlString:String = self.dataModel.guidevideo
        
        let URLString = URL.init(string: videoUrlString.getImageStr())
        
        let videoItem = AVPlayerItem(url:URLString!)
        self.avPlayer = AVPlayer(playerItem:videoItem)
        let playerLayer = AVPlayerLayer.init(player: self.avPlayer)
        playerLayer.frame = CGRect(x:KSCREEN_WIDTH/2-ip6(37),y:ip6(50),width:ip6(74),height:ip6(74))
        playerLayer.cornerRadius = ip6(37)
        playerLayer.masksToBounds = true
        headView.layer.addSublayer(playerLayer)
        //        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.doctorVideoPlayerEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoItem)
        
        self.avPlayer?.play()
        
        let painTitleLabel = UILabel(frame:CGRect(x:0,y:ip6(165),width:KSCREEN_WIDTH,height:ip6(30)))
        painTitleLabel.text = "疼痛部位"
        painTitleLabel.textColor = DARK_COLOUR_SELECTED
        painTitleLabel.font = UIFont.systemFont(ofSize: 17)
        painTitleLabel.textAlignment = NSTextAlignment.center
        headView.addSubview(painTitleLabel)
    
        return headView

        
    }()
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if (self.avPlayer != nil) {
            self.avPlayer?.pause()
            isPlaying = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.naviagtionTitle(titleName: "伤病情况")
        self.navigationBar_leftBtn()
        
        painDetailLabel.text = "未选择"
        
        weak var weakSelf = self

   
        request.getInguryData(complate: { (data) in
            weakSelf?.dataModel = data as! InguryPositionModel
            KFBLog(message: weakSelf?.view.frame.size.height)
            
            weakSelf?.createTableView()
            weakSelf?.setBottomView()
            
            weakSelf?.isPlaying = true
            weakSelf?.PainTableView.reloadData()
        }) { (error) in
            self.KfbShowWithInfo(titleString: error)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidEnterPlayGround), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        

        // Do any additional setup after loading the view.
    }

    func appDidEnterBackground() {
        
        KFBLog(message: "进入后台")
        self.avPlayer?.pause()
        
        
    }
    
    func appDidEnterPlayGround() {
        
        KFBLog(message: "进入前台")
        if isPlaying {
            self.avPlayer?.play()
        }
    }

    func createTableView() {
        
        PainTableView = UITableView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT-64 - ip6(80)),style:UITableViewStyle.plain)
        PainTableView.backgroundColor = UIColor.white
        PainTableView.dataSource = self
        PainTableView.delegate = self
        PainTableView.showsVerticalScrollIndicator = false
        PainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.view.addSubview(PainTableView)

    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.dataModel.positionMenu.count + 1)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section==0 {
            return ip6(280)
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
            
            let model = self.dataModel.positionMenu[section-1]

            if (model.isShow > 0){
                return model.BMenu.count
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
                
                let tempModel = self.dataModel.positionMenu[indexPath.section-1]

                let detailTempModel = tempModel.BMenu[indexPath.row]
                let painDetailImageView = UIImageView(frame:CGRect(x:50,y:5,width:50,height:30))
                
                painDetailImageView.setImageWith(URL.init(string: detailTempModel.iconurl.getImageStr())!, placeholderImage: UIImage.init(named: "course_placeholder_big"))

                cell?.contentView.addSubview(painDetailImageView)
                
                let painTitleLabel = UILabel(frame:CGRect(x:110,y:5,width:KSCREEN_WIDTH-190,height:30))
                painTitleLabel.text = detailTempModel.positionname
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
            
            let tempModel = self.dataModel.positionMenu[indexPath.section-1]
            
            let detailTempModel = tempModel.BMenu[indexPath.row]
            
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
            

            let tempModel = self.dataModel.positionMenu[indexPath.section-1]
            
            selectedDetailTempModel = tempModel.BMenu[indexPath.row]

            
            if (selectedDetailTempModel.isSelect == 1) {
                
                selectedDetailTempModel.isSelect = 0
                painDetailLabel.text = "未选择"
                nextButton.setTitle("未选择", for: UIControlState.normal)
                nextButton.backgroundColor = GRAY999999_COLOUR
                
            }else{
                
                //自动收起
//                tempModel.isShow = 0
                
                for model in self.dataModel.positionMenu {
                    
                    for model1 in model.BMenu {
                        
                        model1.isSelect = 0;
                    }
                }
                
                self.dataModel.positionMenu[indexPath.section-1].BMenu[indexPath.row].isSelect = 1
                
                painDetailLabel.text = self.dataModel.positionMenu[indexPath.section-1].BMenu[indexPath.row].positionname
                if selectedDetailTempModel.istestpage >= 0 {
                    nextButton.setTitle("下一步", for: UIControlState.normal)
                }else{
                    nextButton.setTitle("完成", for: UIControlState.normal)
                }
                nextButton.backgroundColor = GREEN_COLOUR
            }

            PainTableView .reloadData()
            
        }
    }
    
    
    //顶部view
    func createHeadView() -> UIView {
        
        painDetailLabel.frame = CGRect(x:0,y:ip6(210),width:KSCREEN_WIDTH,height:ip6(20))
        painDetailLabel.textColor = MAIN_GREEN_COLOUR
        painDetailLabel.font = UIFont.systemFont(ofSize: 12)
        painDetailLabel.textAlignment = NSTextAlignment.center
        headView.addSubview(painDetailLabel)
        
        return headView
    }
    

    func doctorVideoPlayerEnd() {
        KFBLog(message: "播放结束")
        isPlaying = false
    }

    
    func createSectionHeadView(sectionIndex:Int) -> UIView {
        
        let tempModel = self.dataModel.positionMenu[sectionIndex]


        let sectionHeadView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:60))
        sectionHeadView.backgroundColor = UIColor.white
        sectionHeadView.tag = sectionIndex
        
        let PainIconImageView = UIImageView(frame:CGRect(x:50,y:19,width:22,height:22))

        PainIconImageView.setImageWith(URL.init(string: tempModel.iconurl.getImageStr())!, placeholderImage: UIImage.init(named: "course_placeholder_big"))
        
        sectionHeadView.addSubview(PainIconImageView)
        
        let painSectionTitleLabel = UILabel(frame:CGRect(x:78,y:8,width:KSCREEN_WIDTH - 160,height:44))
        
        painSectionTitleLabel.text = tempModel.positionname
        painSectionTitleLabel.textColor = GRAY656A72_COLOUR
        painSectionTitleLabel.backgroundColor = UIColor.white
        painSectionTitleLabel.font = UIFont.systemFont(ofSize: 15)
        painSectionTitleLabel.textAlignment = NSTextAlignment.left
        sectionHeadView.addSubview(painSectionTitleLabel)
        
        let PainArrowImageView = UIImageView(frame:CGRect(x:KSCREEN_WIDTH - 68,y:25,width:18,height:10))
        sectionHeadView.addSubview(PainArrowImageView)

        
        if (tempModel.isShow == 1) {
            
            PainArrowImageView.image = UIImage(named:"icon_up")
            
        }else{
            
            PainArrowImageView.image = UIImage(named:"icon_down")
        }

        let bottomLineView = UIView(frame:CGRect(x:50,y:59,width:KSCREEN_WIDTH-100,height:1))
        bottomLineView.backgroundColor = LINE_COLOUR
        sectionHeadView.addSubview(bottomLineView)
        
        
        let sectionViewTap = UITapGestureRecognizer(target:self,action:(#selector(self.titleTapClick(tapGesture:))))
        sectionHeadView.addGestureRecognizer(sectionViewTap)

        
        return sectionHeadView
        
    }
    
    
    func titleTapClick(tapGesture:UITapGestureRecognizer) {

        let tempModel = self.dataModel.positionMenu[tapGesture.view!.tag]

        if (tempModel.isShow == 1) {
            
            for model in self.dataModel.positionMenu {
                model.isShow = 0
            }
            
        }else{
            
            for model in self.dataModel.positionMenu {
                model.isShow = 0
            }
            tempModel.isShow = 1
        }
        
//        let indexSet:NSIndexSet = NSIndexSet(index:tapGesture.view!.tag+1)
//        
//        PainTableView.reloadSections(indexSet as IndexSet, with: UITableViewRowAnimation.fade)
        PainTableView.reloadData()

    }

    
    override func navigationLeftBtnClick() {
    
        _=self.navigationController?.popViewController(animated: true)
        
    }

    
    func setBottomView() {
        
        let bottomView  = UIView(frame:CGRect(x:0,y:KSCREEN_HEIGHT-64-ip6(80),width:KSCREEN_WIDTH,height:ip6(80)))
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        nextButton.setTitle("下一步", for: UIControlState.normal)
        nextButton.layer.cornerRadius = 2
        nextButton.layer.masksToBounds = true
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        nextButton.frame = CGRect(x: KSCREEN_WIDTH-ip6(125), y:ip6(24), width:ip6(75), height: ip6(32))
        nextButton.setTitleColor( UIColor.white , for: UIControlState.normal)
        nextButton.backgroundColor = GRAY999999_COLOUR
        nextButton.addTarget(self, action:#selector(self.nextClick) , for: UIControlEvents.touchUpInside)
        bottomView.addSubview(nextButton)
    }
    
    
    func nextClick() {
        

            if nextButton.titleLabel?.text == "未选择" {
            
                KfbShowWithInfo(titleString: "请选择您的疼痛部位")

            }else{
                
                if nextButton.titleLabel?.text == "完成" {
                   
                    KFBLog(message: selectedDetailTempModel.positionid)
                    KFBLog(message: selectedDetailTempModel.parentpositionid)
                    
                    postDic.removeValue(forKey: "初始化")
                    
                    weak var weakSelf = self

                    self.SVshow(infoStr: "正在生成康复方案")

                    
                    request.createProgram(parentPositionId: selectedDetailTempModel.parentpositionid, positionId: selectedDetailTempModel.positionid, createDict: postDic, complate: { (data) in
                        
                        weakSelf?.createProgramModel = data as! CreateProgramModel
                        
                        weakSelf?.SVdismiss()
                        
                        if  (weakSelf?.createProgramModel.status)! > 0{

                            KFBLog(message: weakSelf?.createProgramModel.msg)
//                            weakSelf?.KfbShowWithInfo(titleString: (weakSelf?.createProgramModel.msg)!)
                            
                            let vc:MyRecurePlanViewController = MyRecurePlanViewController()
                            vc.hidesBottomBarWhenPushed = true
                            vc.newProgram = 1
                            weakSelf?.navigationController?.pushViewController(vc, animated: true)

                            
                        } else {
                            KFBLog(message: weakSelf?.createProgramModel.msg)
                            weakSelf?.KfbShowWithInfo(titleString: (weakSelf?.createProgramModel.msg)!)
                        }

                    }, failure:{(error) in
                        weakSelf?.SVdismiss()

                        weakSelf?.KfbShowWithInfo(titleString: "康复方案生成失败，请重试")
                    })
          

                    
                }else{
                    KFBLog(message: "下一步")
                    KFBLog(message: selectedDetailTempModel.positionid)
                    KFBLog(message: selectedDetailTempModel.parentpositionid)
                    
                    if selectedDetailTempModel.istestpage == 0 {
                        let vc:DetailOfPainViewController = DetailOfPainViewController()
                        vc.hidesBottomBarWhenPushed = true
                        vc.deliverModel = selectedDetailTempModel
                        vc.fromId = 0
                        vc.deliverPositionId = selectedDetailTempModel.positionid
                        vc.deliverParentPositionId = selectedDetailTempModel.parentpositionid
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else{
                        
                        let vc:DiagnoseViewController = DiagnoseViewController()
                        vc.hidesBottomBarWhenPushed = true
                        vc.positionId = selectedDetailTempModel.positionid
                        vc.AMenuId = 0
                        vc.deliverPositionId = selectedDetailTempModel.positionid
                        vc.deliverParentPositionId = selectedDetailTempModel.parentpositionid
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }

                }
                
        }
        
    }
    
    deinit {
        //记得移除通知监听
        NotificationCenter.default.removeObserver(self)
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
