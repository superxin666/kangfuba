//
//  LoginViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/17.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  登录  手机号 18518216134  密码111111 测试账号

import UIKit
import SnapKit
enum SOURCE_LOG {
    case REGISTER
    case LOGORREG
}

class LoginViewController: BaseViewController,UITextFieldDelegate {
    var topConstraint : Constraint?
    var midConstraint : Constraint?
    var needUp : Bool = true//是否需要上弹
    let request = LoginDataManger.sharedInstance//数据请求
    var dataModel : LoginModel = LoginModel()//
    var source : SOURCE_LOG!
    var phoneStr : String = ""
    var keyStr : String = ""
    let _phoneTextField : UITextField = UITextField()//手机号
    let _keyTextField : UITextField = UITextField()//密码
    let _loginBtn : UIButton = UIButton(type: UIButtonType.custom)//登录按钮
    let _forgetBtn : UIButton = UIButton(type: UIButtonType.custom)//忘记密码
    let _registerBtn : UIButton = UIButton(type: UIButtonType.custom)//新用户注册

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar_leftBtn()
        self.naviagtionTitle(titleName: "登录")
        self.creatUI()
    }
    // MARK: UI
    func creatUI() {
        //logo
        let iconImageView = UIImageView(frame: CGRect(x: (KSCREEN_WIDTH-59)/2, y: ip6(110), width: 59, height: 59))
        iconImageView.image = UIImage(named: "login_log_bg")
        self.view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (view) in
            view.centerX.equalTo(self.view)
            topConstraint = view.top.equalTo(ip6(110)).constraint
            view.width.height.equalTo(59)
        }

        //名字
        let nameImageView = UIImageView(frame: CGRect(x: (KSCREEN_WIDTH-100)/2, y: iconImageView.frame.maxY + 10, width: 100, height: 23))
        nameImageView.image = UIImage(named: "logIn_name_bg")
        self.view.addSubview(nameImageView)
        nameImageView.snp.makeConstraints { (view) in
            view.centerX.equalTo(self.view)
            view.top.equalTo(iconImageView).offset(ip6(69))
        }
        //手机号
        let space :CGFloat = ip6(51)
        let phoneBackView = UIView(frame: CGRect(x: space, y: nameImageView.frame.maxY + ip6(100), width: KSCREEN_WIDTH - space * 2, height: 35))
        //phoneBackView.backgroundColor = UIColor.green
        self.view.addSubview(phoneBackView)
        phoneBackView.snp.makeConstraints { (view) in
            view.left.equalTo(space)
            view.right.equalTo(-space)
            midConstraint = view.top.equalTo(nameImageView).offset(ip6(100)).constraint
            view.height.equalTo(35)
            
        }

        let phoneNameLabel = UILabel(frame: CGRect(x: 0, y: 10, width: 50, height: 15))
        phoneNameLabel.text = "手机号"
        phoneNameLabel.font = UIFont.systemFont(ofSize: 15)
        phoneNameLabel.textColor = KFBColor(red: 144, green: 153, blue: 167, alpha: 1)
        phoneBackView.addSubview(phoneNameLabel)
        phoneNameLabel.snp.makeConstraints { (view) in
            view.left.equalTo(0)
            view.height.equalTo(15)
            view.top.equalTo(10)
            view.width.equalTo(50)
        }
        let viewWidth : CGFloat = phoneBackView.frame.size.width
        _phoneTextField.frame = CGRect(x: phoneNameLabel.frame.maxX + 10, y: 7, width: viewWidth - 10 - 50, height: 25)
        //设置placeholder的属性
        var attributes:[String : Any] = NSDictionary() as! [String : Any]
        attributes[NSFontAttributeName] = UIFont.systemFont(ofSize: 15)
        let string:NSAttributedString = NSAttributedString.init(string: "输入手机号", attributes: attributes)
        _phoneTextField.attributedPlaceholder = string
        _phoneTextField.adjustsFontSizeToFitWidth = true
        _phoneTextField.textAlignment = .left
        _phoneTextField.keyboardType = .numberPad
        _phoneTextField.returnKeyType = .next
        _phoneTextField.delegate = self;
        _phoneTextField.tag = 100
        //_phoneTextField.backgroundColor = .red
        phoneBackView.addSubview(_phoneTextField)
//        _phoneTextField.snp.makeConstraints { (view) in
//            view.left.equalTo(60)
//            view.right.equalTo(0)
//            view.top.equalTo(7)
//            view.height.equalTo(25)
//        }

        let lineView : UIView = UIView(frame: CGRect(x: 0, y: 34.5, width: viewWidth, height: 0.5))
        lineView.backgroundColor = KFBColor(red: 151, green: 168, blue: 194, alpha: 1)
        phoneBackView.addSubview(lineView)
//        lineView.snp.makeConstraints { (view) in
//            view.left.equalTo(0)
//            view.right.equalTo(0)
//            view.bottom.equalTo(0)
//            view.height.equalTo(0.5)
//        }

        //密码
        let keyBackView = UIView(frame: CGRect(x: space, y: phoneBackView.frame.maxY + 15, width: KSCREEN_WIDTH - space * 2, height: 35))
        keyBackView.backgroundColor = UIColor.clear
        self.view.addSubview(keyBackView)
        keyBackView.snp.makeConstraints { (view) in
            view.left.equalTo(space)
            view.top.equalTo(phoneBackView).offset(50)
            view.right.equalTo(-space)
            view.height.equalTo(35)
        }

        let keyNameLabel = UILabel(frame: CGRect(x: 0, y: 10, width: 50, height: 15))
        keyNameLabel.text = "密码"
        keyNameLabel.font = UIFont.systemFont(ofSize: 15)
        keyNameLabel.textColor = KFBColor(red: 144, green: 153, blue: 167, alpha: 1)
        keyBackView.addSubview(keyNameLabel)

        _keyTextField.frame = CGRect(x: keyNameLabel.frame.maxX + 10, y: 7, width: phoneBackView.frame.size.width - 50, height: 25)
//      设置placeholder的属性
        var attributes2:[String : Any] = NSDictionary() as! [String : Any]
        //var attributes2:[String:AnyObject] = NSMutableDictionary() as![String:AnyObject]
        attributes2[NSFontAttributeName] = UIFont.systemFont(ofSize: 15)
        let string2:NSAttributedString = NSAttributedString.init(string: "请输入6-20位密码", attributes: attributes)
        _keyTextField.attributedPlaceholder = string2
        _keyTextField.adjustsFontSizeToFitWidth = true
        _keyTextField.textAlignment = .left
        _keyTextField.returnKeyType = .done
        _keyTextField.isSecureTextEntry = true
        _keyTextField.delegate = self
        _keyTextField.tag = 101
        //_keyTextField.backgroundColor = .red
        keyBackView.addSubview(_keyTextField)

        let lineView2 : UIView = UIView(frame: CGRect(x: 0, y: 34.5, width: KSCREEN_WIDTH - space * 2, height: 0.5))
        lineView2.backgroundColor = KFBColor(red: 151, green: 168, blue: 194, alpha: 1)
        keyBackView.addSubview(lineView2)
        lineView2.snp.makeConstraints { (view) in
            view.left.equalTo(0)
            view.right.equalTo(0)
            view.bottom.equalTo(0)
            view.height.equalTo(0.5)
        }

        //忘记密码
        _forgetBtn.frame = CGRect(x: (KSCREEN_WIDTH - 51 - 60), y: keyBackView.frame.maxY + 11.5, width: 60, height: 40)
        _forgetBtn.setTitle("忘记密码", for: UIControlState.normal)
        _forgetBtn.backgroundColor = UIColor.clear
        _forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        _forgetBtn.setTitleColor(KFBColor(red: 144, green: 153, blue: 167, alpha: 1), for: UIControlState.normal)
        _forgetBtn.addTarget(self, action: #selector(LoginViewController.foregetBtnClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(_forgetBtn)
        _forgetBtn.snp.makeConstraints { (view) in
            view.top.equalTo(keyBackView).offset(36.5)
            view.right.equalTo(-51)
            view.height.equalTo(25)
            view.width.equalTo(60)
        }
        //登录
        let spacebtn : CGFloat = 60.5

        _loginBtn.frame = CGRect(x: spacebtn, y: keyBackView.frame.maxY + 53.5, width: KSCREEN_WIDTH - spacebtn * 2, height: 40)
        _loginBtn.setTitle("登录", for: UIControlState.normal)
        _loginBtn.backgroundColor = GREEN_COLOUR
        _loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        _loginBtn.kfb_makeRadius(radius: 4)
        _loginBtn.addTarget(self, action: #selector(LoginViewController.logInBtnClcik), for: UIControlEvents.touchUpInside)
        self.view.addSubview(_loginBtn)
        _loginBtn.snp.makeConstraints { (view) in
            view.top.equalTo(keyBackView).offset(78.5)
            view.right.equalTo(-spacebtn)
            view.left.equalTo(spacebtn)
            view.height.equalTo(40)
        }

        //新用户注册
        let spacebtn2 : CGFloat = (KSCREEN_WIDTH - 80) / 2

        _registerBtn.frame = CGRect(x: spacebtn2, y: KSCREEN_HEIGHT - 37.5, width: 80, height: 15)
        _registerBtn.setTitle("新用户注册", for: UIControlState.normal)
        _registerBtn.setTitleColor(GREEN_COLOUR, for: UIControlState.normal)
        _registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        _registerBtn.backgroundColor = UIColor.clear
        _registerBtn.addTarget(self, action: #selector(LoginViewController.registerBtnClcik), for: UIControlEvents.touchUpInside)
        self.view.addSubview(_registerBtn)
        _registerBtn.snp.makeConstraints { (view) in
            view.width.equalTo(80)
            view.height.equalTo(15)
            view.left.equalTo(spacebtn2)
            view.right.equalTo(-spacebtn2)
            view.bottom.equalTo(-37.5)
        }

    }
    // MARK: 登录 忘记密码 注册方法
    func foregetBtnClick() {
        print("忘记密码")
        let vc = findKeyViewController()
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func logInBtnClcik() {

        if _phoneTextField.isFirstResponder {
            _phoneTextField.resignFirstResponder()
        }
        if _keyTextField.isFirstResponder {
            _keyTextField.resignFirstResponder()
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
            self.topConstraint?.update(offset: 110)
            self.midConstraint?.update(offset: ip6(100))
            self.view.layoutIfNeeded()
        }) { (ture) in
             self.needUp = ture

        }
        if !(String.isStr(str: phoneStr)) {
            KFBLog(message: "请填写手机号")
            self.KfbShowWithInfo(titleString: "请填写手机号")
            return
        }
        if !(String.isMobileNumber(phoneNum: phoneStr)) {
            KFBLog(message: "请填写正确手机号")
            self.KfbShowWithInfo(titleString: "请填写正确手机号")
            return
        }
        if keyStr.characters.count < 6 {
            KFBLog(message: "密码至少六位")
            self.KfbShowWithInfo(titleString: "密码至少六位")
            return
        }
        KFBLog(message: "登录")
        //此处密码要加密  测试账号无需加密

        weak var weakSelf = self

        request.login(phoneNum: phoneStr, paseWord: keyStr.sha1(), completion: { (data) in
            weakSelf?.dataModel = data as! LoginModel
            if weakSelf?.dataModel.status == 1{
                //登录成功
                KFBLog(message: "登录成功")
                //存贮登录loginid+token
                let msgArr = self.dataModel.msg.components(separatedBy: ",")
                KFBLog(message: msgArr)
                let loginStr = msgArr[0]
                let tokenStr = msgArr[1]
                LoginModel.setLoginIdAndTokenInUD(loginUserId: loginStr, token: tokenStr, complate: { (data) in
                    let str:String = data as! String
                    if str == "1" {
                        let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
                        dele.showMain()
                    } else {
                        //存储信息失败
                    }
                })

            } else {
                //登录失败
                KFBLog(message: "登录失败\(self.dataModel.msg)")
                self.KfbShowWithInfo(titleString:"登录失败\(self.dataModel.msg!)")

            }
            }) { (erro) in
                self.KfbShowWithInfo(titleString: erro as! String)

        }


    }
    func registerBtnClcik() {
        print("注册")
        if self.source == .REGISTER {
            _=self.navigationController?.popViewController(animated: true)
        } else {
            let vc = RegisterViewController()
            self.navigationController?.pushViewController(vc, animated: true)

        }

    }
    // MARK: textFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        switch tag {
        case 100:
            print("手机号：\(textField.text)")
            phoneStr = textField.text!
        case 101:
            print("密码:\(textField.text)")
            keyStr = textField.text!
        default:
            print("既不是手机号也不是密码")
        }

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == _keyTextField {
            self.logInBtnClcik()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if needUp {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
                self.topConstraint?.update(offset: ip6(10))
                self.midConstraint?.update(offset: ip6(50))
                self.view.layoutIfNeeded()
            }) { (ture) in
                self.needUp = false
            }

        } else {

        }

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
