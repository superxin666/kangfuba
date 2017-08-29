//
//  BaseViewController.swift
//  kangfuba
//
//  Created by lvxin on 16/10/12.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD
import MJRefresh
import SVProgressHUD

class BaseViewController: UIViewController {
    let progressHud = MBProgressHUD()
    let header = MJRefreshNormalHeader() //头部刷新
    let footer = MJRefreshAutoNormalFooter() // 底部刷新
    
    
    let activityView:UIView = UIView(frame: CGRect(x: 0, y: -35, width: KSCREEN_WIDTH, height: 35))
    var activityLabel:UILabel = UILabel()
    var isShowing :Bool = false
    
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent=false
        // Do any additional setup after loading the view.
        self.view.backgroundColor = BACKVIEW_COLOUR
//        let request = KFBRequestViewController()
//        request.startMonitoring()

    }
    
    

    //MARK:导航栏
    //标题
    func naviagtionTitle(titleName : String) {
        self.navigationItem.title = titleName
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: KFBColor(red: 144, green: 153, blue: 167, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes  = [NSForegroundColorAttributeName: UIColor.black]
    }

    func navigationTitleImage(image: UIImage) {
        self.navigationItem.titleView = UIImageView.init(image: image)
    }
    //左边返回键
    func navigationBar_leftBtn(){
        let btn:UIButton = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setImage(UIImage(named:"navigation_left_arrow"), for:.normal)
        btn.addTarget(self, action:#selector(BaseViewController.navigationLeftBtnClick), for: .touchUpInside)
        let item:UIBarButtonItem = UIBarButtonItem(customView:btn)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,action: nil)
        spacer.width = -15;
        
//        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.leftBarButtonItems = [spacer,item]
        

    }
    //设置导航栏右键_名字 默认色值是黑色
    func navigationBar_rightBtn_title(name:String, textColour:UIColor = .black){
        let btn:UIButton = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        btn.setTitle(name, for: .normal)
        btn.setTitleColor(textColour, for: .normal)
        btn.addTarget(self, action:#selector(BaseViewController.navigationRightBtnClick), for: .touchUpInside)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        let item:UIBarButtonItem = UIBarButtonItem(customView:btn)
        self.navigationItem.rightBarButtonItem = item
    }
    //设置导航栏右键_图片
    func navigationBar_rightBtn_title(image:UIImage){
        let btn:UIButton = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 44)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action:#selector(BaseViewController.navigationRightBtnClick), for: .touchUpInside)
        let item:UIBarButtonItem = UIBarButtonItem(customView:btn)
        self.navigationItem.rightBarButtonItem = item
    }

    //返回键
    func navigationLeftBtnClick() {
        print("导航栏返回键点击")
    }
    //右键点击
    func navigationRightBtnClick(){
        print("导航栏右键点击")
    }

    
    //提示开始
    func KfbShowWithInfo(titleString:String) {
        
        if self.isShowing {
            return
        }
        
        self.isShowing = true
        
        activityView.backgroundColor = green_COLOUR
        activityView.alpha = 0.9
        self.view.addSubview(activityView)
        
        activityLabel.text = titleString
        activityLabel.textColor = UIColor.white
        activityLabel.font = UIFont.systemFont(ofSize: 15)
        activityLabel.textAlignment = NSTextAlignment.center
        let activityStrWidth = getLabWidth(labelStr: titleString as String, font: activityLabel.font, height: activityView.frame.size.height)
        
        
        activityLabel.frame = CGRect(x:KSCREEN_WIDTH/2 - activityStrWidth/2,y:0,width:activityStrWidth,height:activityView.frame.size.height)
        
        activityView.addSubview(activityLabel)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.activityView.frame.origin.y = 0
        }) { (finished) in

            self.perform(#selector(self.KfbShowStop), with: self, afterDelay: 1.5)
        }
        

    }
    //提示结束
   @objc private func KfbShowStop(){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.activityView.frame = CGRect(x: 0,y: -35,width: KSCREEN_WIDTH,height: 35)
        }) { (finished) in
            self.activityView.removeFromSuperview()
            self.isShowing = false

        }
        
    }

    func SVshow(infoStr:String) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
        SVProgressHUD.show(withStatus: infoStr)
        
    }
    
    func SVshow() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
        SVProgressHUD.show()
        
    }
    
    func SVshowSuccess(infoStr:String) {
        SVProgressHUD.showSuccess(withStatus: infoStr)
    }
    
   
    
    func SVdismiss() {
        
        SVProgressHUD.dismiss()
    }
    
    //获取宽度
    func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: KSCREEN_WIDTH - 70, height: activityView.frame.size.height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.width
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
