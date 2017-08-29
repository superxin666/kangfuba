//
//  InjureDetialViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2017/1/3.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class InjureDetialViewController: BaseViewController,UIWebViewDelegate {

    var openUrl : String!
    var titleString : String!
    
    var webView:UIWebView?
    var nextButton : UIButton = UIButton(type: UIButtonType.custom)

    override func viewWillDisappear(_ animated: Bool) {
        
        self.SVdismiss()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.SVshow()
        naviagtionTitle(titleName: titleString)
        
        navigationBar_leftBtn()
        
        createWebView()

        
        // Do any additional setup after loading the view.
    }
    
    func setBottomView(){
        
        let bottomView  = UIView(frame:CGRect(x:0,y:KSCREEN_HEIGHT-64-72,width:KSCREEN_WIDTH,height:72))
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        nextButton.frame = CGRect(x: (KSCREEN_WIDTH-180)/2, y:20, width:180, height: 32)
        nextButton.setTitle("制定康复方案", for: UIControlState.normal)
        nextButton.layer.cornerRadius = 16
        nextButton.layer.masksToBounds = true
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        nextButton.setTitleColor( UIColor.white , for: UIControlState.normal)
        nextButton.backgroundColor = GREEN_COLOUR
        nextButton.addTarget(self, action:#selector(self.nextClick) , for: UIControlEvents.touchUpInside)
        bottomView.addSubview(nextButton)
        
        
    }
    func nextClick() {
        
        let vc:InguryGuideViewController = InguryGuideViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.FromId = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }

   

    func createWebView(){
       
        self.webView = UIWebView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT-64-80))
        
        self.webView?.delegate = self
        self.webView?.loadRequest(URLRequest(url: URL.init(string: openUrl)!))

        self.view.addSubview(self.webView!)
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        self.SVshow()
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.SVdismiss()
        
        self.setBottomView()
        
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
