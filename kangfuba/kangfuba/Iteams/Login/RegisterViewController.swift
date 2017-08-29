//
//  RegisterViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/18.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  注册

import UIKit
import MBProgressHUD

class RegisterViewController: BaseViewController ,UITextFieldDelegate{
    var time : Timer!//时间计时器
    var timeNum  = 60 //总时间
    let request = LoginDataManger.sharedInstance//数据请求
    var dataModel : GetCodeModel = GetCodeModel()//获取验证码返回的数据模型

    var phoneStr : String = ""//手机号
    var codeStr : String = ""//验证码
    var keyStr : String = ""//密码
    @IBOutlet weak var topConstraint: NSLayoutConstraint!//顶部layout
    @IBOutlet weak var midConstraint: NSLayoutConstraint!//中部
    @IBOutlet weak var phoneTextField: UITextField!//手机号
    @IBOutlet weak var codeTextField: UITextField!//验证码
    @IBOutlet weak var getCodeBtn: UIButton!//获取验证码
    @IBOutlet weak var keyTextField: UITextField!//密码
    @IBOutlet weak var registerBtn: UIButton!//注册按钮

    @IBOutlet weak var userAgreementLabel: UILabel!
    // MARK: 获取验证码 注册 老用户登录点击
    //获取验点击
    @IBAction func getCodeBtnClick(_ sender: AnyObject) {
         phoneTextField.resignFirstResponder()
        KFBLog(message: phoneStr)
        if !(String.isStr(str: phoneStr)) {
            KFBLog(message: "请填写手机号")
            self.KfbShowWithInfo(titleString: "请填写手机号")
            return
        } else {
            KFBLog(message: "手机号已经填写")
        }
        if !(String.isMobileNumber(phoneNum: phoneStr)) {
            KFBLog(message: "请填写正确手机号")
            self.KfbShowWithInfo(titleString: "请填写正确手机号")
            return
        } else {
            KFBLog(message: "手机号正确")
        }
        KFBLog(message: "获取验证码点击")
        self.getCodeBtn.isUserInteractionEnabled = false
        self.getCodeBtn.setTitle("正在发送", for: .normal)
        self.getCodeBtn.setTitleColor(GRAY656A72_COLOUR, for: .normal)
        weak var weakself = self
        request.getPhoneCodeData(phoneNum: self.phoneStr, completion: {(model) in
            weakself?.dataModel = model
            if weakself?.dataModel.status == 1{
                //请求成功开始计时
                weakself?.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RegisterViewController.timeDown), userInfo: nil, repeats: true)
            } else{
                //失败提示
                KFBLog(message: "获取验证码失败")
                self.againCode()
                weakself?.KfbShowWithInfo(titleString: (weakself?.dataModel.msg)!)
            }

        }, failure:{(data) in

                weakself?.KfbShowWithInfo(titleString: data as! String)
        })


    }
    func timeDown() {
        timeNum -= 1
        if timeNum == 0 {
            self.againCode()
        } else {
            self.getCodeBtn.setTitle("已发送\((timeNum))", for: .normal)
            self.getCodeBtn.setTitleColor(GRAY656A72_COLOUR, for: .normal)
        }
    }

    func againCode()  {
        if time != nil {
            time.invalidate()
            time = nil
        }

        self.getCodeBtn.isUserInteractionEnabled = true
        timeNum = 60
        self.getCodeBtn.setTitle("重新获取", for: .normal)
        self.getCodeBtn.setTitleColor(GREEN_COLOUR, for: .normal)
    }

    //下一步点击
    @IBAction func registerBtnClick(_ sender: AnyObject) {

//        let vc = ImproInfoViewController()
//        self.navigationController?.pushViewController(vc, animated: true)

        if phoneTextField.isFirstResponder {
            phoneTextField.resignFirstResponder()
        } else if codeTextField.isFirstResponder {
            codeTextField.resignFirstResponder()
        } else {
            keyTextField.resignFirstResponder()
        }
        //页面下降
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
            self.topConstraint.constant = ip6(71)
            self.midConstraint.constant = ip6(99)
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

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
        if !(String.isStr(str: codeStr)) {
            KFBLog(message: "请填写验证码")
            self.KfbShowWithInfo(titleString: "请填写验证码")
            return
        }
        if !(String.isStr(str: keyStr)) {
            KFBLog(message: "请填写密码")
            self.KfbShowWithInfo(titleString: "请填写密码")
            return
        }
        if keyStr.characters.count < 6 {
            KFBLog(message: "密码至少六位")
            self.KfbShowWithInfo(titleString: "密码至少六位")
            return

        }

        if keyStr.characters.count > 20 {
            KFBLog(message: "密码不能超过20位")
            self.KfbShowWithInfo(titleString: "密码不能超过20位")
            return

        }
        //判断验证码是否已经发送成功才可以下一步验证
        if !(dataModel.status == 1){
            self.KfbShowWithInfo(titleString: "请填写正确的验证码")
            return
        }
        //本地验证 验证码是否正确
        let str = codeStr + phoneStr + "sbe#dsfsd!sdsf0067878&%dll[[p]6754th"
        KFBLog(message: "加密前字符串\(str)")
        let sha1Str = str.sha1()
        KFBLog(message: "加密后字符串\(sha1Str)")
        KFBLog(message: "模型\(dataModel.msg)")
        let tokenArr = dataModel.msg.components(separatedBy: ",")
        KFBLog(message: tokenArr)
        let tokenStr = tokenArr.first
        KFBLog(message: tokenStr)
        KFBLog(message: "数据返回\(tokenStr)  本地加密\(sha1Str))")
        if sha1Str == tokenStr {
            let vc = ImproInfoViewController()
            vc.userPhoneNum = phoneStr
            vc.codeStr = codeStr
            vc.passStr = keyStr
            vc.tokenStr = tokenArr.first
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            KFBLog(message: "请填写正确验证码")
            self.KfbShowWithInfo(titleString: "请填写正确验证码")
        }



    }
    //老用户登录
    @IBAction func loginBtnClick(_ sender: AnyObject) {
        let vc  = LoginViewController()
        vc.source = .LOGORREG
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func userAgreementClick(_ sender: Any) {
        let vc = UserAgreementViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: 生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.getCodeBtn.isUserInteractionEnabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if time != nil {
            time.invalidate()
            time = nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.midConstraint.constant = ip6(99)
        self.topConstraint.constant = ip6(71)
        self .naviagtionTitle(titleName: "注册")
        self .navigationBar_leftBtn()
        self .setUpUI()

    }
    func setUpUI() {
        self.getCodeBtn.kfb_makeBorderAndRadius(width: 1, color: green_COLOUR, radius: 4)
        self.registerBtn.kfb_makeRadius(radius: 4)
        keyTextField.delegate = self
        codeTextField.delegate = self
        phoneTextField.delegate = self
        //NSForegroundColorAttributeName
        let str : String  = "注册表示已经阅读并同意"
        let attributeStr = NSMutableAttributedString(string: str)

        let str2 : String  = "Recova用户协议"
        let attributeStr2 = NSMutableAttributedString(string: str2)
        let range : NSRange = NSRange.init(location: 0, length: str2.characters.count)
        attributeStr2.addAttribute(NSForegroundColorAttributeName, value: green_COLOUR, range: range)
        attributeStr.append(attributeStr2)
        userAgreementLabel.attributedText = attributeStr

    }
    // MARK:textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        //页面下降
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
            self.topConstraint.constant = ip6(71)
            self.midConstraint.constant = ip6(99)
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

        }
        switch textField.tag {
        case 1:
            phoneStr = textField.text!
        case 2:
            codeStr = textField.text!
        case 3:
            keyStr = textField.text!
            textField.resignFirstResponder()
        default:
            KFBLog(message: "没有键盘")
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if phoneTextField.isFirstResponder {
            phoneTextField.resignFirstResponder()
        } else if codeTextField.isFirstResponder {
            codeTextField.resignFirstResponder()
        } else {
            keyTextField.resignFirstResponder()
        }
        //页面下降
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
            self.topConstraint.constant = ip6(71)
            self.midConstraint.constant = ip6(99)
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
            //self.view.transform = CGAffineTransform(translationX: 0, y: -120)
            self.topConstraint.constant = ip6(10)
            self.midConstraint.constant = ip6(50)
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

        }

    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        switch textField.tag {
        case 1:
            phoneStr = textField.text!
            KFBLog(message: phoneStr)
        case 2:
            codeStr = textField.text!
        case 3:
            keyStr = textField.text!
        default:
            KFBLog(message: "没有键盘")
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField.tag {
        case 1:
            phoneStr = textField.text!
        case 2:
            codeStr = textField.text!
        case 3:
            keyStr = textField.text!
            keyTextField.resignFirstResponder()
        default:
            KFBLog(message: "没有键盘")
        }
        return true
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
