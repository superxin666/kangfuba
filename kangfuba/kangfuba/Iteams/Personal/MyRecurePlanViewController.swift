//
//  MyRecurePlanViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/10/18.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import JavaScriptCore

class MyRecurePlanViewController: BaseViewController,UIWebViewDelegate {

    var webView:UIWebView?
    var newProgram:Int = 0//0从我的康复方案进入的，1新生成的方案进来的
    var context: JSContext = JSContext()
    var nextButton : UIButton = UIButton(type: UIButtonType.custom)

    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.SVdismiss()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SVshow()
        naviagtionTitle(titleName: "我的康复方案")

        navigationBar_leftBtn()

        if self.newProgram == 0 {
            navigationBar_rightBtn_title(name: "重置方案", textColour: GREEN_COLOUR)
        }

        createWebView()
        
        // Do any additional setup after loading the view.
    }

    func setBottomView(){
        
        let bottomView  = UIView(frame:CGRect(x:0,y:KSCREEN_HEIGHT-64-72,width:KSCREEN_WIDTH,height:72))
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        nextButton.frame = CGRect(x: (KSCREEN_WIDTH-180)/2, y:20, width:180, height: 32)
        nextButton.setTitle("开始康复", for: UIControlState.normal)
        nextButton.layer.cornerRadius = 16
        nextButton.layer.masksToBounds = true
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        nextButton.setTitleColor( UIColor.white , for: UIControlState.normal)
        nextButton.backgroundColor = GREEN_COLOUR
        nextButton.addTarget(self, action:#selector(MyRecurePlanViewController.nextClick) , for: UIControlEvents.touchUpInside)
        bottomView.addSubview(nextButton)

        
    }
//    MARK:去首页训练
    func nextClick() {
        MobClick.event("007")
        let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        dele.showMain()
    }
    
    func createWebView(){
        if self.newProgram == 0{
            self.webView = UIWebView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT-64))

        }else{
            self.webView = UIWebView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT-64-80))
        }
        self.webView?.delegate = self
        self.loadData()
        self.view.addSubview(self.webView!)
    }
    
    func loadData(){
        
        let baseUrl=String(format: "/web/program/detail?newProgram=0&login_user_id=%@&login_token=%@&deviceId=%@&version=%@", LoginModel.getLoginIdAndTokenInUD().loginId, LoginModel.getLoginIdAndTokenInUD().tokenId,(UIDevice.current.identifierForVendor?.uuidString)!,self.getAppVersion())
        
        let urlStr = BASER_API + baseUrl
        
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
        
        if self.newProgram == 1 {
            self.setBottomView()
        }
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.KfbShowWithInfo(titleString: error.localizedDescription)
    }
    

    
    //重置方案
    override func navigationRightBtnClick(){
        
        KFBLog(message: "重置方案")
        
        let alertController = UIAlertController(title: "确定重置方案吗？", message: "重置方案后，当前方案将被清除，但会保留所有的训练数据", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            MobClick.event("008")
            let vc:InguryGuideViewController = InguryGuideViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.FromId = 1
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

        
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
