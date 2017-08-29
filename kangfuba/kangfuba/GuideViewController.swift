//
//  GuideViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/12/23.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit
typealias CloseGuide = (String) -> Void

class GuideViewController: UIViewController,UIScrollViewDelegate {

    let imageArray = NSArray(objects: "guide1.png","guide2.png","guide3.png","guide4.png")
    var backClosure:CloseGuide?           //接收上个页面穿过来的闭包块
    var _jumpButton : UIButton = UIButton(type: UIButtonType.custom)
    var _startButton : UIButton = UIButton(type: UIButtonType.custom)
    let _pageControl = UIPageControl(frame:CGRect(x:KSCREEN_WIDTH/2-30,y:KSCREEN_HEIGHT-55,width:60,height:30))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }

    //闭包变量的Seter方法
    func setBackMyClosure(tempClosure:@escaping CloseGuide) {
        self.backClosure = tempClosure
    }
    
    //判断是否需要展示引导页
    func shouldShowGuide() -> Bool {
        
        // the app version in the sandbox
        var lastVersion:String? = UserDefaults.standard.value(forKey: "RecovaShouldGuide") as! String?
        if lastVersion == nil {
            lastVersion = ""
        }
        
        // the current app version
        let currentVersion = self.getAppCurrentVersion()
        
        if lastVersion == currentVersion {
            return false
        }else{
            UserDefaults.standard.set(currentVersion, forKey: "RecovaShouldGuide")
            UserDefaults.standard.synchronize()
            return true
        }
    }
    //获取app版本号
    func getAppCurrentVersion() -> String  {
        let infoDict = Bundle.main.infoDictionary
        if let info = infoDict {
            let appVersion = info["CFBundleShortVersionString"] as! String!
            return appVersion!
        } else {
            return ""
        }
    }
    
    func setGuideImages()  {
        
        if self.imageArray.count > 0 {
            
            let scrollView:UIScrollView = UIScrollView(frame:self.view.bounds)
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
            
            scrollView.contentSize = CGSize(width:KSCREEN_WIDTH * CGFloat(self.imageArray.count),height:0)
            
            self.view.addSubview(scrollView)
            
            for i in 0..<self.imageArray.count{
                
                let imageView = UIImageView(frame:CGRect(x:KSCREEN_WIDTH * CGFloat(i),y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT))
                let imageString = "\(self.imageArray.object(at: i))"
                imageView.image = UIImage(named:imageString)
                imageView.isUserInteractionEnabled = true
                scrollView.addSubview(imageView)
                
                
                if i==self.imageArray.count - 1 {
                    
                    _startButton.frame = CGRect(x: KSCREEN_WIDTH/2-ip6(100), y:KSCREEN_HEIGHT-ip6(100), width:ip6(200), height: ip6(50))
                    _startButton.setBackgroundImage(#imageLiteral(resourceName: "startRecovaBg"), for: .normal)
                    _startButton.setTitle("开始Recova", for: UIControlState.normal)
                    _startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                    _startButton.setTitleColor(UIColor.white , for: UIControlState.normal)
                    _startButton.addTarget(self, action:#selector(GuideViewController.jumpClick) , for: UIControlEvents.touchUpInside)
                    imageView.addSubview(_startButton)

                }
            }
            
            _jumpButton.setTitle("跳过", for: UIControlState.normal)
            _jumpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            _jumpButton.frame = CGRect(x: KSCREEN_WIDTH-80, y:40, width:60, height: 30)
            _jumpButton.setTitleColor(UIColor.white , for: UIControlState.normal)
            _jumpButton.backgroundColor = GRAY999999_COLOUR
            _jumpButton.addTarget(self, action:#selector(GuideViewController.jumpClick) , for: UIControlEvents.touchUpInside)
            _jumpButton.kfb_makeRadius(radius: 4)
            self.view.addSubview(_jumpButton)
            
            _pageControl.backgroundColor = UIColor.clear
            _pageControl.numberOfPages = self.imageArray.count
            _pageControl.hidesForSinglePage = true
            _pageControl.currentPage = 0
            _pageControl.isUserInteractionEnabled = false
            _pageControl.currentPageIndicatorTintColor = GREEN_COLOUR
            _pageControl.pageIndicatorTintColor = GRAY999999_COLOUR
            
            self.view.addSubview(_pageControl)
            
        }
    }
    
    
    func jumpClick() {
        
        if self.backClosure != nil {
            
            self.backClosure!("main")
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = scrollView.contentOffset.x/KSCREEN_WIDTH
        _pageControl.currentPage = Int(page)
        if Int(page) == self.imageArray.count-1 {
            _jumpButton.isHidden = true
        }else{
            _jumpButton.isHidden = false
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if Int(scrollView.contentOffset.x) > (self.imageArray.count-1) * Int(KSCREEN_WIDTH) + 50 {
            
            self.jumpClick()
        }
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
