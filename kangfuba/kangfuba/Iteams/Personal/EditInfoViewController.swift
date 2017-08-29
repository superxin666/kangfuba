//
//  EditInfoViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/18.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class EditInfoViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

    var EditUserDataModel : PersonalInfoModel = PersonalInfoModel()
//    var EditUserDataModel : PersonalInfoModel!
    
    let titleDataArr = NSArray(objects: "昵称","性别","出生日期")
    var tableView:UITableView!
    
    var headImageView:UIImageView!
    var nameTextField:UITextField!
    
    var _manBtn : UIButton = UIButton(type: UIButtonType.custom) //男
    var _womanBtn : UIButton = UIButton(type: UIButtonType.custom)//女

//    var _dateLabel: UILabel!
    var _dateLabel:UILabel = UILabel()
    
    
    let datePicker = UIDatePicker()
    
    var _datePickerBgView: UIView!
    
    let manger : LoginDataManger = LoginDataManger.sharedInstance
    var upIconModel : UpLoadIconModel = UpLoadIconModel()//上传头像数据模型
    var iconUrl : String! = ""//头像地址

    let request = PersonalDataManger.sharedInstance

    var editUserModel : EditUserInfoModel = EditUserInfoModel()

    var defaultDateString : String! = "1990年1月1日"//默认生日啊

    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviagtionTitle(titleName: "编辑资料")

        navigationBar_leftBtn()
        navigationBar_rightBtn_title(name: "保存", textColour: GREEN_COLOUR)
        
        tableView = UITableView(frame:self.view.frame,style:UITableViewStyle.grouped)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.view.addSubview(tableView)
        
        self.iconUrl = self.EditUserDataModel.userimage
        
        if self.EditUserDataModel.userbirthday != nil{
           
            //格式转换
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let userDate = dateFormatter.date(from: self.EditUserDataModel.userbirthday)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月dd日"
            self.defaultDateString = formatter.string(from: userDate!)
        }
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleDataArr.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = createHeadView()
        return headView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "reuseIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:identifier)
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            let lineView = UIView(frame:CGRect(x:(KSCREEN_WIDTH-150)/2,y:95.5,width:150,height:0.5))
            lineView.backgroundColor = KFBColor(red: 200, green: 200, blue: 200, alpha: 1)
            cell?.contentView.addSubview(lineView)
            
            //        title
            let titleLabel = UILabel(frame:CGRect(x:(KSCREEN_WIDTH-150)/2,y:20,width:150,height:25))
            titleLabel.textColor = MAIN_GREEN_COLOUR
            titleLabel.text = "\(titleDataArr.object(at: indexPath.row))"
            titleLabel.font = UIFont.systemFont(ofSize: 17)
            titleLabel.textAlignment = NSTextAlignment.center
            
            cell?.contentView.addSubview(titleLabel)
            
            if indexPath.row==0 {
        
                nameTextField = UITextField(frame:CGRect(x:KSCREEN_WIDTH/2-75, y:55, width:150, height:30))
                nameTextField.placeholder = "请输入用户名"
                nameTextField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
                nameTextField.font = UIFont.systemFont(ofSize: 17)
                nameTextField.minimumFontSize=14  //最小可缩小的字号
                nameTextField.textColor = MAIN_GREEN_COLOUR
                nameTextField.textAlignment = .center //水平居中对齐
                nameTextField.clearButtonMode = UITextFieldViewMode.whileEditing  //编辑时出现清除按钮
                nameTextField.delegate = self
                nameTextField.text = self.EditUserDataModel.username
            
                cell?.contentView.addSubview(nameTextField)
            }
            
            if indexPath.row==1 {
            
                _manBtn.setTitle("男", for: UIControlState.normal)
                _manBtn.setTitle("男", for: UIControlState.selected)
                _manBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                _manBtn.frame = CGRect(x: KSCREEN_WIDTH/2-60, y:55, width:50, height: 30)
                _manBtn.setTitleColor( MAIN_GREEN_COLOUR , for: UIControlState.normal)
                _manBtn.setTitleColor( GREEN_COLOUR , for: UIControlState.selected)
                _manBtn.backgroundColor = UIColor.clear
                _manBtn.addTarget(self, action:#selector(EditInfoViewController.manBtnClick) , for: UIControlEvents.touchUpInside)
                cell?.contentView.addSubview(_manBtn)
            
            
                _womanBtn.setTitle("女", for: UIControlState.normal)
                _womanBtn.setTitle("女", for: UIControlState.selected)
                _womanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                _womanBtn.frame = CGRect(x: KSCREEN_WIDTH/2+10, y:55, width:50, height: 30)
                _womanBtn.setTitleColor(MAIN_GREEN_COLOUR , for: UIControlState.normal)
                _womanBtn.setTitleColor(GREEN_COLOUR , for: UIControlState.selected)
                _womanBtn.backgroundColor = UIColor.clear
                _womanBtn.addTarget(self, action:#selector(EditInfoViewController.womanBtnClick) , for: UIControlEvents.touchUpInside)
                cell?.contentView.addSubview(_womanBtn)
                
                
                if self.EditUserDataModel.usergender == 0 {
                    _manBtn.isSelected = false
                    _womanBtn.isSelected = true

                }else if self.EditUserDataModel.usergender == 1{
                    _manBtn.isSelected = true
                    _womanBtn.isSelected = false
                    
                }else{
                    _manBtn.isSelected = false
                    _womanBtn.isSelected = false
                }
            }
            
            
            if indexPath.row==2 {
            
                _dateLabel.frame = CGRect(x:KSCREEN_WIDTH/2-75, y:55, width:150, height:30)
                _dateLabel.textColor = MAIN_GREEN_COLOUR
    
                var dateStr:String = ""
                
                if self.EditUserDataModel.userbirthday != nil {
                    
                     dateStr = self.defaultDateString

                }else{
                    
                    dateStr = "点击设置您的生日"
                }
                
                
                _dateLabel.text = dateStr
                
                _dateLabel.font = UIFont.systemFont(ofSize: 17)
                _dateLabel.textAlignment = NSTextAlignment.center
                _dateLabel.isUserInteractionEnabled = true
                        
                let dateTap = UITapGestureRecognizer(target:self,action:(#selector(EditInfoViewController.dateTapClick)))
                _dateLabel.addGestureRecognizer(dateTap)
        
                cell?.contentView.addSubview(_dateLabel)
                        
            }

        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            nameTextField.resignFirstResponder()
            if (_datePickerBgView != nil) {
                datePickerHide()
            }
            
        case 1:
            
            nameTextField.resignFirstResponder()
            if (_datePickerBgView != nil) {
                datePickerHide()
            }
            
        case 2:
            
            nameTextField.resignFirstResponder()

        default:
 
            KFBLog(message: "error")
        }
    }
    
    func createHeadView() -> UIView {
        
        let headView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:184))
        headView.backgroundColor = UIColor.white
        
        headImageView = UIImageView(frame: CGRect(x: (KSCREEN_WIDTH - 65)/2,y:15,width:65,height:65))
        headImageView.layer.cornerRadius = 32.5
        headImageView.layer.masksToBounds = true
        headImageView.setImageWith(URL.init(string: self.EditUserDataModel.userimage.getImageStr())!, placeholderImage: UIImage.init(named: "Personal_icon_head"))
        headImageView.isUserInteractionEnabled = true
        headView.addSubview(headImageView)
        
        let headImageTap = UITapGestureRecognizer(target:self,action:(#selector(EditInfoViewController.setHeadImage)))
        headImageView.addGestureRecognizer(headImageTap)
        
        
        let editButton = UIButton(type:UIButtonType.custom)
        editButton.frame = CGRect(x:30,y:85,width:KSCREEN_WIDTH - 60,height:20)
        editButton.setTitle("更换头像", for: UIControlState.normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        editButton.setTitleColor(MAIN_GREEN_COLOUR, for: UIControlState.normal)
        editButton.backgroundColor = .clear
        editButton.addTarget(self, action: #selector(EditInfoViewController.setHeadImage), for: UIControlEvents.touchUpInside)
        headView.addSubview(editButton)
        
        return headView
    }

    
    override func navigationLeftBtnClick() {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:保存
    override func navigationRightBtnClick(){
        if (_datePickerBgView != nil) {
            datePickerHide()
        }
//        KFBLog(message:"-----" + self.iconUrl)

        nameTextField.resignFirstResponder()
        
        if nameTextField.text == nil || nameTextField.text == ""{
            KfbShowWithInfo(titleString: "请填写您的昵称")
            return
        }
        

        
        self.EditUserDataModel.username = nameTextField.text
        weak var weakSelf = self
        
        self.SVshow(infoStr: "正在保存信息")
        if self.EditUserDataModel.userbirthday == nil {
            
            self.EditUserDataModel.userbirthday = "0"
        }
        
        request.editUserInfo(userName: self.EditUserDataModel.username, userImage: self.iconUrl, userGender: self.EditUserDataModel.usergender, userBirthday: self.EditUserDataModel.userbirthday, complate: { (data) in
            weakSelf?.editUserModel = data as! EditUserInfoModel
            weakSelf?.SVdismiss()
            if  (weakSelf?.editUserModel.status)! > 0{
                KFBLog(message: weakSelf?.editUserModel.msg)
                _=self.navigationController?.popViewController(animated: true)
                
            } else {
                KFBLog(message: weakSelf?.editUserModel.msg)
                weakSelf?.KfbShowWithInfo(titleString: (weakSelf?.editUserModel.msg)!)
                
            }

        }) { (code) in
            weakSelf?.KfbShowWithInfo(titleString: code as! String)
            
            weakSelf?.SVdismiss()
        }
          
    }
    
    func setHeadImage() {
        
        let alertController = UIAlertController(title: "提示", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        
        let takePicturesAction = UIAlertAction(title: "拍照", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            
            self.openCamera()
        })
        
        let AlbumAction = UIAlertAction(title: "从相册选择", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            
            self.openAlbum()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(takePicturesAction)
        alertController.addAction(AlbumAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    //打开相机
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //创建图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //设置来源
            picker.sourceType = UIImagePickerControllerSourceType.camera
            //允许编辑
            picker.allowsEditing = true
            //打开相机
            self.present(picker, animated: true, completion: { () -> Void in
                
            })
        }else{
            KFBLog(message: "找不到相机")
        }
    }
    //打开相册
    func openAlbum(){
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //设置是否允许编辑
            picker.allowsEditing = true
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            KFBLog(message: "读取相册错误")
        }
    }
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {
        //查看info对象
        KFBLog(message: info)
        
        //显示的图片
        let image:UIImage!
        
        //获取选择的编辑后的
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        headImageView.image = image
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
            
            //上传头像
            self.SVshow(infoStr: "正在上传头像")

            self.loadUpUserIcon(image: image)

        })
    }
    
    //上传头像
    func loadUpUserIcon(image : UIImage) {
        KFBLog(message: "上传头像")

        weak var weakSelf = self//
        manger.upLoadUserIcon(image: image, completion: { (data) in
            weakSelf?.upIconModel = data as! UpLoadIconModel
            KFBLog(message: weakSelf?.upIconModel)
            weakSelf?.SVdismiss()

            if weakSelf?.upIconModel.status == 1{

                KFBLog(message: "上传头像成功--\(weakSelf?.upIconModel.data)")
                weakSelf?.KfbShowWithInfo(titleString: "头像上传成功")

                weakSelf?.iconUrl = (weakSelf?.upIconModel.data)!
                
            }else{
                
                weakSelf?.iconUrl = (weakSelf?.EditUserDataModel.userimage)!

            }
        }) { (error) in
            weakSelf?.SVdismiss()
            weakSelf?.KfbShowWithInfo(titleString: "头像上传失败")

            weakSelf?.iconUrl = (weakSelf?.EditUserDataModel.userimage)!

        }
    }
    
    func manBtnClick() {
        if (_datePickerBgView != nil) {
            datePickerHide()
        }
        nameTextField.resignFirstResponder()
        _manBtn.isSelected = true
        _womanBtn.isSelected = false
        self.EditUserDataModel.usergender = 1
    }
    
    func womanBtnClick() {
        if (_datePickerBgView != nil) {
            datePickerHide()
        }
        nameTextField.resignFirstResponder()

        _womanBtn.isSelected = true
        _manBtn.isSelected = false
        self.EditUserDataModel.usergender = 0

    }
    
    func dateTapClick()  {
        
        nameTextField.resignFirstResponder()

        if _datePickerBgView == nil {
            
            _datePickerBgView = UIView(frame:CGRect(x:0 ,y:self.view.frame.height - 240,width:KSCREEN_WIDTH,height:240))
            
            datePicker.frame = CGRect(x:0 ,y:40,width:_datePickerBgView.frame.size.width,height:_datePickerBgView.frame.size.height-40)
            
            //将日期选择器区域设置为中文，则选择器日期显示为中文
            datePicker.locale = Locale(identifier: "zh_CN")
            
            datePicker.addTarget(self, action: #selector(dateChanged), for: UIControlEvents.valueChanged)
            
            datePicker.datePickerMode = UIDatePickerMode.date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            let minDate = dateFormatter.date(from: "1930年1月1日")
            datePicker.maximumDate = NSDate() as Date
            datePicker.minimumDate = minDate
            // 设置默认时间
            let defaultDate = dateFormatter.date(from: self.defaultDateString)
            datePicker.date = defaultDate!
            
            let formatter = DateFormatter()
            //日期样式
            formatter.dateFormat = "yyyy-MM-dd"
            _dateLabel.text = dateFormatter.string(from: defaultDate!)
            self.EditUserDataModel.userbirthday = formatter.string(from: defaultDate!)
            
            
            //完成按钮
            let finishButton :UIButton = UIButton(type: UIButtonType.custom)
            finishButton.setTitle("完成", for: UIControlState.normal)
            finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            finishButton.frame = CGRect(x: KSCREEN_WIDTH-80, y:10, width:70, height: 30)
            finishButton.setTitleColor( DARK_COLOUR_SELECTED , for: UIControlState.normal)
            finishButton.backgroundColor = UIColor.clear
            finishButton.addTarget(self, action:#selector(EditInfoViewController.datePickerHide) , for: UIControlEvents.touchUpInside)
            
            _datePickerBgView.addSubview(finishButton)
            _datePickerBgView.addSubview(datePicker)
            
            self.view.addSubview(_datePickerBgView)
            
        }
        
        UIView.beginAnimations("", context: nil)
        tableView.frame.origin.y = -150
        UIView.commitAnimations()

        
        UIView.beginAnimations("", context: nil)
        _datePickerBgView.frame = CGRect(x:0 ,y:self.view.frame.height-240,width:KSCREEN_WIDTH,height:230)
        UIView.commitAnimations()
        
    }
    
    func datePickerHide()  {
        
        UIView.beginAnimations("", context: nil)
        _datePickerBgView.frame = CGRect(x:0 ,y:self.view.frame.height,width:KSCREEN_WIDTH,height:230)
        UIView.commitAnimations()
        
        UIView.beginAnimations("", context: nil)
        tableView.frame.origin.y = 0
        UIView.commitAnimations()
        
    }
    
    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        let formatter1 = DateFormatter()

        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter1.dateFormat = "yyyy-MM-dd"

        _dateLabel.text = formatter.string(from: datePicker.date)
        
        self.EditUserDataModel.userbirthday = formatter1.string(from: datePicker.date)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
         if (_datePickerBgView != nil) {
           datePickerHide()
         }
        return true
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
