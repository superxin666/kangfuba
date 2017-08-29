//
//  PersonalViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/13.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import ObjectMapper

class PersonalViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{

    let fileManger : FileManger = FileManger.sharedInstance//文件管理

    var isLoginSuccess:Bool = false

    let _mainTableView:UITableView = UITableView(frame: CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT-49),style:UITableViewStyle.grouped)

    let titleDataArr = NSArray(objects: "我的康复方案","我的训练记录","清除缓存","关于我们","退出登录")
    let imageDataArr = NSArray(objects: "Personal_icon_plan","Personal_icon_record","Personal_icon_clean","Personal_icon_about","Personal_icon_loginOut")

    let request = PersonalDataManger.sharedInstance

    var UserDataModel : UserInfoModel = UserInfoModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: 获取数据
    func getData()  {
        weak var weakSelf = self

        request.getPersonalData(complate: { (data) in
            weakSelf?.UserDataModel = data as! UserInfoModel
            weakSelf?.isLoginSuccess = true
            weakSelf?._mainTableView.reloadData()

            }) { (errorCode) in
                weakSelf?.isLoginSuccess = false
                
                if errorCode  == "403" {
                    self.KfbShowWithInfo(titleString: "账号异地登录请重新登录")
                } else {
                    self.KfbShowWithInfo(titleString: errorCode)
                }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weak var weakSelf = self
        
        weakSelf?._mainTableView.backgroundColor = UIColor.white
        weakSelf?._mainTableView.dataSource = self
        weakSelf?._mainTableView.delegate = self
        weakSelf?._mainTableView.showsVerticalScrollIndicator = false
        weakSelf?._mainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview((weakSelf?._mainTableView)!)

        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 234
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleDataArr.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = createHeadView()
        return headView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "reuseIdentifier" + "\(indexPath.row)"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:identifier)
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            let lineView = UIView(frame:CGRect(x:30,y:65,width:KSCREEN_WIDTH - 60,height:1))
            lineView.backgroundColor = LINE_COLOUR
            cell?.contentView.addSubview(lineView)
            
            //icon
            let iconImageView = UIImageView(frame: CGRect(x: 30, y: 23, width: 19, height: 19))
            let imageString = "\(imageDataArr.object(at: indexPath.row))"
            iconImageView.image = UIImage(named:imageString)
            
            cell?.contentView.addSubview(iconImageView)
            
            iconImageView.snp.makeConstraints { (view) in
                view.left.equalTo(30)
                view.top.equalTo(23)
                view.width.height.equalTo(19)
            }
            
            //        title
            let titleLabel = UILabel(frame:CGRect(x:60,y:10,width:KSCREEN_WIDTH - 100,height:45))
            titleLabel.textColor = MAIN_GREEN_COLOUR
            titleLabel.text = "\(titleDataArr.object(at: indexPath.row))"
            titleLabel.font = UIFont.systemFont(ofSize: 13)
            titleLabel.textAlignment = NSTextAlignment.left
            
            cell?.contentView.addSubview(titleLabel)
            
            //arrow
            let arrowImageView = UIImageView(frame:CGRect(x:KSCREEN_WIDTH - 40,y:25,width:8,height:15))
            
            arrowImageView.image = UIImage(named:"Personal_icon_arrow")
            cell?.contentView.addSubview(arrowImageView)

        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            if self.isLoginSuccess {
                
                MobClick.event("026")
                if self.UserDataModel.data.programid > 0 {
                    let vc:MyRecurePlanViewController = MyRecurePlanViewController()
                    vc.hidesBottomBarWhenPushed = true
                    vc.newProgram = 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc:NoRecurePlanViewController = NoRecurePlanViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else{
                KfbShowWithInfo(titleString: "账号异地登录请重新登录")
            }
            
        case 1:
            
            if self.isLoginSuccess{
                MobClick.event("027")
                let vc:MyTrainRecordViewController = MyTrainRecordViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)

            }else{
                KfbShowWithInfo(titleString: "账号异地登录请重新登录")
            }
            
        case 2:
            if self.isLoginSuccess {
                MobClick.event("028")
                self.clearData()
                self._mainTableView.reloadData()

            }else{
                KfbShowWithInfo(titleString: "账号异地登录请重新登录")
            }
           
        case 3:
//            关于我们
//            if self.isLoginSuccess{
            
                MobClick.event("029")
                let vc:AboutUsViewController = AboutUsViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)

//            }else{
//                KfbShowWithInfo(titleString: "账号异地登录请重新登录")
//            }
            
        case 4:
            self.loginOut()
            self._mainTableView.reloadData()

        default:
            KFBLog(message: "error")
        }
    }
    
    func createHeadView() -> UIView {
        
        let headView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:234))
        headView.backgroundColor = UIColor.white
        
        let headImageView = UIImageView(frame: CGRect(x: (KSCREEN_WIDTH - 65)/2,y:38,width:65,height:65))
        headImageView.layer.cornerRadius = 32.5
        headImageView.layer.masksToBounds = true
        
        var imageStr:String = "kfb"
        
        if self.UserDataModel.data.userimage != nil {
            imageStr = self.UserDataModel.data.userimage
        }
        headImageView.setImageWith(URL.init(string: imageStr.getImageStr())!, placeholderImage: UIImage.init(named: "Personal_icon_head"))
        
        headView.addSubview(headImageView)
        
        
        let nameLabel = UILabel(frame:CGRect(x:30,y:110,width:KSCREEN_WIDTH - 60,height:40))
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.text = self.UserDataModel.data.username
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.textColor = UIColor.black
        headView.addSubview(nameLabel)
        nameLabel.isUserInteractionEnabled = true
        let nameLabelTap = UITapGestureRecognizer(target:self,action:(#selector(PersonalViewController.editInfo)))
        nameLabel.addGestureRecognizer(nameLabelTap)

        
        let editButton = UIButton(type:UIButtonType.custom)
        editButton.frame = CGRect(x:30,y:155,width:KSCREEN_WIDTH - 60,height:15)
        editButton.setTitle("点击编辑资料", for: UIControlState.normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        editButton.setTitleColor(GREEN_COLOUR, for: UIControlState.normal)
        editButton.backgroundColor = .clear
        editButton.addTarget(self, action: #selector(PersonalViewController.editInfo), for: UIControlEvents.touchUpInside)
        headView.addSubview(editButton)
        
        return headView
    }
//    编辑资料
    func editInfo() {
        
        if self.isLoginSuccess {
            let  vc :EditInfoViewController = EditInfoViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.EditUserDataModel = self.UserDataModel.data
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            KfbShowWithInfo(titleString: "账号异地登录请重新登录")
        }
       
    }
    
    func clearData() {
        
        let alertController = UIAlertController(title: "确定清除缓存吗？", message: "清除缓存后，再次训练需要重新下载", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            KFBLog(message: "删除操作")
            
             self.fileManger.removeAllCourseData()
            self.KfbShowWithInfo(titleString: "清除缓存成功")

        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    func loginOut() {
        
        let alertController = UIAlertController(title: "确定要退出登录吗？", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            (action: UIAlertAction) -> Void in
          
            UserDefaults.standard.set("0", forKey: ISLOGINSTR)
            let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
            dele.showLogOrRegister()

        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
