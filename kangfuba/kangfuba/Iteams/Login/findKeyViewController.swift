//
//  findKeyViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/18.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  找回密码

import UIKit

class findKeyViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var time : Timer!//时间计时器
    var timeNum  = 60 //总时间
    let request = LoginDataManger.sharedInstance//数据请求
    var dataModel : GetCodeModel = GetCodeModel()//获取验证码返回的数据模型

    var phoneStr : String = ""//手机号
    var codeStr : String = ""//验证码
    var keyStr : String = ""//密码

    @IBOutlet weak var phoneNumTextField: UITextField!//手机号
    @IBOutlet weak var codeTextField: UITextField!//验证码

    @IBOutlet weak var getCodeBtn: UIButton!//获取验证码
    @IBOutlet weak var nestBtn: UIButton!//下一步
    // MARK:下一步
    @IBAction func nestBtnClick(_ sender: AnyObject) {

        if phoneNumTextField.isFirstResponder {
            phoneNumTextField.resignFirstResponder()
        }
        if codeTextField.isFirstResponder {
            codeTextField.resignFirstResponder()
        }
        //页面上移
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
            self.topConstraint.constant = 130
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
            let vc = resetKeyViewController()
            vc.phoneNumStr = phoneStr
            vc.codeStr = codeStr
            vc.tokenStr = tokenStr!
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            KFBLog(message: "请填写正确验证码")
            self.KfbShowWithInfo(titleString: "请填写正确验证码")
        }

    }
    // MARK:获取验证码
    @IBAction func getCodeClick(_ sender: AnyObject) {
        KFBLog(message: "获取验证码")
        phoneNumTextField.resignFirstResponder()
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
        weak var weakself = self
        getCodeBtn.isEnabled = false
        self.getCodeBtn.setTitle("正在发送", for: .normal)
        self.getCodeBtn.setTitleColor(GRAY656A72_COLOUR, for: .normal)
        request.getPhoneCodeFindKeyData(phoneNum: self.phoneStr, completion: {(model) in
            weakself?.dataModel = model
            weakself?.dataModel = model
            if weakself?.dataModel.status == 1{
                //请求成功开始计时
                weakself?.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(findKeyViewController.timeDown), userInfo: nil, repeats: true)
            } else{
                //失败提示
                self.againCode()
                KFBLog(message: "获取验证码失败")
                self.KfbShowWithInfo(titleString: (weakself?.dataModel.msg)!)
            }

        }, failure:{(data) in

            weakself?.KfbShowWithInfo(titleString: data as! String)
        })
    }

    func againCode()  {
        time.invalidate()
        time = nil
        self.getCodeBtn.isUserInteractionEnabled = true
        timeNum = 60
        self.getCodeBtn.setTitle("重新获取", for: .normal)
        self.getCodeBtn.setTitleColor(GREEN_COLOUR, for: .normal)
    }


    func timeDown() {
        timeNum -= 1
        self.getCodeBtn.isUserInteractionEnabled = false
        if timeNum == 0 {
            time.invalidate()
            time = nil
            getCodeBtn.isUserInteractionEnabled = true
            timeNum = 60
            getCodeBtn.setTitle("重新获取", for: .normal)
            getCodeBtn.setTitleColor(GREEN_COLOUR, for: .normal)
            getCodeBtn.isEnabled = true
        } else {
            getCodeBtn.setTitle("已发送\((timeNum))", for: .normal)
            getCodeBtn.setTitleColor(GRAY656A72_COLOUR, for: .normal)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar_leftBtn()
        self.naviagtionTitle(titleName: "找回密码")
        self.setUpUI()

    }
    func setUpUI() {
        getCodeBtn.kfb_makeBorderAndRadius(width: 1, color: green_COLOUR, radius: 4)
        nestBtn.kfb_makeRadius(radius: 4)
        codeTextField.delegate = self
        phoneNumTextField.delegate = self

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //页面上移
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
            self.topConstraint.constant = 130
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

        }
        if phoneNumTextField.isFirstResponder {
            phoneNumTextField.resignFirstResponder()
        }
        if codeTextField.isFirstResponder {
            codeTextField.resignFirstResponder()
        }
    }

    // MARK:textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        //页面下降
        //页面上移
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
            self.topConstraint.constant = 130
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

        }
        switch textField.tag {
        case 1:
            phoneStr = textField.text!
        case 2:
            codeStr = textField.text!
        default:
            KFBLog(message: "没有键盘")
        }

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
            //self.view.transform = CGAffineTransform(translationX: 0, y: -120)
            self.topConstraint.constant = ip6(10)
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
