//
//  LoginOrRegisterViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/14.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  注册或者是登录

import UIKit
import MBProgressHUD

class LoginOrRegisterViewController: BaseViewController {
    let _bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: KSCREEN_WIDTH, height: KSCREEN_HEIGHT))//背景图片
    let _logInBtn :UIButton = UIButton(type: UIButtonType.custom)//登录按钮
    let _registerBtn :UIButton = UIButton(type: UIButtonType.custom)//注册按钮


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.creatUI()

    }
    func creatUI() {
        //背景图
        _bgImageView.image = UIImage(named: "logIn_bg")
        self.view.addSubview(_bgImageView)
        _bgImageView.snp.makeConstraints { (view) in
            view.left.top.right.bottom.equalTo(0)
        }
        //logo
//        let iconImageView = UIImageView(frame: CGRect(x: (KSCREEN_WIDTH-65)/2, y: 80, width: 65, height: 65))
//        iconImageView.image = UIImage(named: "login_log_bg")
//        self.view.addSubview(iconImageView)
//        iconImageView.snp.makeConstraints { (view) in
//            view.centerX.equalTo(self.view)
//            view.top.equalTo(80)
//            view.width.height.equalTo(65)
//        }

        //名字
//        let nameImageView = UIImageView(frame: CGRect(x: (KSCREEN_WIDTH-73)/2, y: iconImageView.frame.maxY + 10, width: 100, height: 23))
//        nameImageView.image = UIImage(named: "logIn_name_bg")
//        self.view.addSubview(nameImageView)
//        nameImageView.snp.makeConstraints { (view) in
//            view.centerX.equalTo(self.view)
//            view.top.equalTo(iconImageView).offset(69)
//        }

        //注册按钮
        let width = (KSCREEN_WIDTH - 35 * 2 - 25)/2
        _registerBtn.setTitle("注册", for: UIControlState.normal)
        _registerBtn.frame = CGRect(x: 35, y:  KSCREEN_HEIGHT-103, width:width, height: 40)
        _registerBtn.setTitleColor(KFBColorFromRGB(rgbValue: 666666), for: UIControlState.normal)
        _registerBtn.backgroundColor = .clear
        _registerBtn.kfb_makeBorderAndRadius(width: 1, color: KFBColorFromRGB(rgbValue: 666666), radius: 4)
        _registerBtn.titleLabel?.font = UIFont(name: "GIORGIO SANS-MEDIUM", size: 13)
        _registerBtn.addTarget(self, action:#selector(LoginOrRegisterViewController.registerBtnClick) , for: UIControlEvents.touchUpInside)
        self.view.addSubview(_registerBtn)

        //登录按钮
        _logInBtn.setTitle("登录", for: UIControlState.normal)
        _logInBtn.frame = CGRect(x: _registerBtn.frame.maxX + 25, y:  KSCREEN_HEIGHT-103, width:width, height: 40)
        _logInBtn.setTitleColor( .white , for: UIControlState.normal)
        _logInBtn.backgroundColor = KFBColor(red: 65, green: 206, blue: 174, alpha: 1)
        _logInBtn.kfb_makeBorderAndRadius(width: 1, color: KFBColor(red: 65, green: 206, blue: 174, alpha: 1), radius: 4)
        _logInBtn.addTarget(self, action:#selector(LoginOrRegisterViewController.loginBtnClick) , for: UIControlEvents.touchUpInside)
        self.view.addSubview(_logInBtn)

    }
    func registerBtnClick()  {
        print("注册点击")
        MobClick.event("001")
        let vc = RegisterViewController()
        _=self.navigationController?.pushViewController(vc, animated: true)
    }
    func loginBtnClick()  {
        print("登陆点击")
        MobClick.event("002")
        let  vc :LoginViewController = LoginViewController()
        vc.source = .LOGORREG
        _=self.navigationController?.pushViewController(vc, animated: true)
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
