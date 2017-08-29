//
//  AboutUsViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/18.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController,UIWebViewDelegate {

    var webView:UIWebView?
    
    override func viewWillDisappear(_ animated: Bool) {
        self.SVdismiss()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        naviagtionTitle(titleName: "关于我们")
        navigationBar_leftBtn()
        self.SVshow()

        createWebView()

        // Do any additional setup after loading the view.
    }

    func createWebView(){
        
        self.webView = UIWebView(frame:self.view.frame)
        self.webView?.delegate = self

        self.loadData()
        self.view.addSubview(self.webView!)
    }

    func loadData(){
        
//        let baseUrl=String(format: "/web/app/aboutUs?login_user_id=%@&login_token=%@&deviceId=%@&version=%@", LoginModel.getLoginIdAndTokenInUD().loginId, LoginModel.getLoginIdAndTokenInUD().tokenId,(UIDevice.current.identifierForVendor?.uuidString)!,self.getAppVersion())
        let urlStr = "http://tldnra.epub360.com/v2/manage/book/hisk3x/"
        
//        let urlStr = BASER_API + baseUrl
        
        KFBLog(message: urlStr)
        
        let url = NSURL(string: urlStr)
        let urlRequest = NSURLRequest(url :url! as URL)
        self.webView!.loadRequest(urlRequest as URLRequest)
    }
    func getAppVersion() -> String  {
        let infoDict = Bundle.main.infoDictionary
        if let info = infoDict {
            let appVersion = info["CFBundleShortVersionString"] as! String!
            return ("ios_" + appVersion!)
        } else {
            return ""
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        self.SVshow()
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.SVdismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.KfbShowWithInfo(titleString: error.localizedDescription)
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
