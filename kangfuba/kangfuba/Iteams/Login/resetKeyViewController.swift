//
//  resetKeyViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/18.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  重置密码

import UIKit

class resetKeyViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var codeStr : String = ""
    var phoneNumStr : String = ""
    var tokenStr :String = ""
    var newPassStr : String = ""
    var reNewPassStr : String = ""
    let request = LoginDataManger.sharedInstance//数据请求
    var  registerModel: LoginModel = LoginModel()//

    @IBOutlet weak var newKeyTextField: UITextField!
    @IBOutlet weak var renewKeyField: UITextField!

    @IBOutlet weak var comBtn: UIButton!
    //完成
    @IBAction func comBtnClick(_ sender: AnyObject) {
        if newKeyTextField.isFirstResponder {
            newKeyTextField.resignFirstResponder()
        }

        if renewKeyField.isFirstResponder{
            renewKeyField.resignFirstResponder()
        }

        if newPassStr.characters.count < 6 {
            KFBLog(message: "密码至少6位")
            self.KfbShowWithInfo(titleString: "密码至少6位")
            return
        }
        if newPassStr.characters.count > 20 {
            KFBLog(message: "密码不能超过20位")
            self.KfbShowWithInfo(titleString: "密码不能超过20位")
            return
        }

        if !(String.isStr(str: newPassStr)) {
            KFBLog(message: "请填写密码")
            self.KfbShowWithInfo(titleString: "请填写密码")
            return
        }
        if !(String.isStr(str: reNewPassStr)) {
            KFBLog(message: "请重复填写新密码")
            self.KfbShowWithInfo(titleString:"请重复填写新密码")
            return
        }

        if !(newPassStr == reNewPassStr) {
            KFBLog(message: "密码不一致")
            self.KfbShowWithInfo(titleString: "密码不一致")
            return
        }
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
            self.topConstraint.constant = 130
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

        }
        weak var weakSelf = self
        request.registerPass(telphone: phoneNumStr, code: codeStr, token: tokenStr, passStr: newPassStr.sha1(), completion: {(data) in
            weakSelf?.registerModel = data as! LoginModel
            if weakSelf?.registerModel.status == 1{
                //修改成功  跳转登录注册界面
//                let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
//                dele.showLogOrRegister()
                  _=weakSelf?.navigationController?.popToRootViewController(animated: true)
            } else {
                KFBLog(message: weakSelf?.registerModel.msg)
                self.KfbShowWithInfo(titleString: (weakSelf?.registerModel.msg)!)

            }

        }, faile: {(erro) in
            weakSelf?.KfbShowWithInfo(titleString: erro as! String)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar_leftBtn()
        self.naviagtionTitle(titleName: "重置密码")
        self.comBtn.kfb_makeRadius(radius: 4)
        newKeyTextField.delegate = self
        renewKeyField.delegate = self

    }

    // MARK:textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        //页面下降
        switch textField.tag {
        case 1:
            newPassStr = textField.text!
        case 2:
            reNewPassStr = textField.text!
        default:
            KFBLog(message: "没有键盘")
        }
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromBottom, animations: {
        //            //self.view.transform = CGAffineTransform(translationX: 0, y: -120)
        //            self.topConstraint.constant = 0
        //            self.view.setNeedsLayout()
        //            self.view.setNeedsUpdateConstraints()
        //        }) { (ture) in
        //
        //        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if newKeyTextField.isFirstResponder {
            newKeyTextField.resignFirstResponder()
        }

        if renewKeyField.isFirstResponder{
            renewKeyField.resignFirstResponder()
        }
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
            self.topConstraint.constant = 130
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
            self.topConstraint.constant = ip6(10)
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

        }

        switch textField.tag {
        case 1:
            newPassStr = textField.text!
            KFBLog(message: newPassStr)
        case 2:
            reNewPassStr = textField.text!
        default:
            KFBLog(message: "没有键盘")
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .transitionFlipFromTop, animations: {
            self.topConstraint.constant = 130
            self.view.setNeedsLayout()
            self.view.setNeedsUpdateConstraints()
        }) { (ture) in

        }
        switch textField.tag {
        case 1:
            newPassStr = textField.text!
            newKeyTextField.resignFirstResponder()
        case 2:
            reNewPassStr = textField.text!
            renewKeyField.resignFirstResponder()
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
