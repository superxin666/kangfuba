//
//  UserAgreementViewController.swift
//  kangfuba
//
//  Created by lvxin on 2016/11/22.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class UserAgreementViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviagtionTitle(titleName: "Recova用户协议")
        self.navigationBar_leftBtn()

        // Do any additional setup after loading the view.
        let manger = LoginDataManger.sharedInstance
        let request = URLRequest(url: URL.init(string: manger.getUserAgreement())!)
        webView.loadRequest(request)
        webView.reload()
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
