//
//  ImproInfoViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/18.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  完善个人信息

import UIKit

class ImproInfoViewController: BaseViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UITextFieldDelegate{

    //@IBOutlet weak var nameTextField: KFBTextField!
    var iconBtn: UIButton!//头像
    @IBOutlet weak var birthdayLabel: UILabel!//生日
    @IBOutlet weak var nameTextField: UITextField!//姓名
    @IBOutlet weak var datePicker: UIDatePicker!//时间选择器
    @IBOutlet weak var pickDateBackView: UIView!//时间选择器背景图
    let manger : LoginDataManger = LoginDataManger.sharedInstance
    var userPhoneNum :String!//手机号
    var codeStr : String!//验证码
    var passStr : String!//密码
    var tokenStr : String!//验证
    var nameStr : String = ""//姓名 必填
    var gender : Int = -1//0女2男-1没有选择  默认是没有选择 选填
    var birthDay : String = ""//生日 选填
    var iconUrl : String = ""//头像地址 选填
    var upIconModel : UpLoadIconModel = UpLoadIconModel()//上传头像数据模型
    var  registerModel: LoginModel = LoginModel()//注册模型
    var isChooseIcon : Bool = false//是否选择了头像
    @IBOutlet weak var boyBtn: UIButton!
    @IBOutlet weak var girlBtn: UIButton!
    @IBOutlet weak var placeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar_leftBtn()
        self.naviagtionTitle(titleName: "完善资料")
        self.navigationBar_rightBtn_title(name: "完成", textColour: GREEN_COLOUR)
        self.setUpUI()

    }
    func setUpUI() {
        //头像
        iconBtn = UIButton(frame: CGRect(x: (KSCREEN_WIDTH - 80)/2, y: 110, width: 80, height: 80))
        iconBtn.setImage(UIImage.init(named: "login_upicon_bg"), for: .normal)
        iconBtn.addTarget(self, action: #selector(ImproInfoViewController.iconClick), for: .touchUpInside)
        iconBtn.kfb_makeRound()
        self.view.addSubview(iconBtn)
        //生日label添加手势
        let birthGes : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImproInfoViewController.birthdayGes))
        self.birthdayLabel.addGestureRecognizer(birthGes)
        self.datePicker.addTarget(self, action: #selector(ImproInfoViewController.selectedBirthday), for: .valueChanged)
        self.nameTextField.delegate = self
    }
    // MARK: 性别
    @IBAction func manBtnClick(_ sender: AnyObject) {
        if self.nameTextField.isFirstResponder {
            self.nameTextField.resignFirstResponder()
        }
        let btn  = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            gender = 1
            if girlBtn.isSelected {
                girlBtn.isSelected = false
            }
        } else {
            gender = -1
        }
    }
    @IBAction func girleBtnClick(_ sender: AnyObject) {
        if self.nameTextField.isFirstResponder {
            self.nameTextField.resignFirstResponder()
        }
        let btn  = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            gender = 0
            if boyBtn.isSelected {
                boyBtn.isSelected = false
            }
        } else {
            gender = -1
        }

    }

    // MARK: 回车收键盘

    @IBAction func CloseKeyBoard(_ sender: Any) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        }

    }
    // MARK: 时间选择器
    @IBAction func dayCompateClick(_ sender: AnyObject) {
        self.pickDateBackView.isHidden = true

    }

    func birthdayGes() {
        self.pickDateBackView.isHidden = false
    }

    func selectedBirthday() {
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: datePicker.date))
        self.birthdayLabel.text = formatter.string(from: datePicker.date)
        birthDay = formatter.string(from: datePicker.date)
    }

    // MARK: 头像点击

    func iconClick()  {
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
        iconBtn.setImage(image, for: UIControlState.normal)

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
        weak var weakSelf = self//
        manger.upLoadUserIcon(image: image, completion: { (data) in
            weakSelf?.upIconModel = data as! UpLoadIconModel
            weakSelf?.SVdismiss()
            if weakSelf?.upIconModel.status == 1{
                KFBLog(message: "上传头像成功--\(weakSelf?.upIconModel.data)")
                weakSelf?.KfbShowWithInfo(titleString: "头像上传成功")

                weakSelf?.iconUrl = (weakSelf?.upIconModel.data)!
            }
            }) { (error) in
                weakSelf?.SVdismiss()

                weakSelf?.KfbShowWithInfo(titleString: error as! String)
        }
    }
    // MARK: nameTextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameStr = textField.text!
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        nameStr = textField.text!
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameStr = textField.text!
        return true
    }

    
    // MARK: 导航栏
    override func navigationRightBtnClick() {

        KFBLog(message: "注册点击")
        MobClick.event("003")
        self.nameTextField.resignFirstResponder()
        KFBLog(message: nameStr + "\(gender)" + birthDay + iconUrl)
        if !(String.isStr(str: nameStr)) {
            KFBLog(message: "请填写用户名")
            self.KfbShowWithInfo(titleString: "请填写用户名")
            return
        }
//        if isChooseIcon {//选择了头像 判断头像是否上传成功
//            if !(String.isStr(str: iconUrl)) {
//                KFBLog(message: "正在上传头像请稍后重试")
//                self.KfbShowWithInfo(titleString: "正在上传头像请稍后重试")
//                return
//            }
//        }
        weak var weakSelf = self
//        manger.register(telphone: userPhoneNum, code: codeStr, userPass: passStr.sha1(), token: tokenStr, userName: nameStr, userImage: iconUrl, userGender: gender, userBirthday: birthDay) { (data) in
//
//        }

    
        manger.register(telphone: userPhoneNum, code: codeStr, userPass: passStr.sha1(), token: tokenStr, userName: nameStr, userImage: iconUrl, userGender: gender, userBirthday: birthDay, complate: {(data) in
            weakSelf?.registerModel = data as! LoginModel
            if  (weakSelf?.registerModel.status)! > 0{
                //注册成功存贮token loguserid
                let msgArr = weakSelf?.registerModel.msg.components(separatedBy: ",")
                KFBLog(message: msgArr)
                let loginStr = msgArr?[0]
                let tokenStr = msgArr?[1]
                LoginModel.setLoginIdAndTokenInUD(loginUserId: loginStr!, token: tokenStr!, complate: { (data) in
                    let str:String = data as! String
                    if str == "1" {
//                        let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
//                        dele.showMain()
                        let vc:InguryGuideViewController = InguryGuideViewController()
                        vc.hidesBottomBarWhenPushed = true
                        vc.FromId = 0
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        //存储信息失败
                    }
                })

            } else {
                KFBLog(message: weakSelf?.registerModel.msg)
            }

        }, failure: {(erro) in
            weakSelf?.KfbShowWithInfo(titleString: erro as! String)

        })




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
