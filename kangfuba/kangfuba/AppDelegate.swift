//
//  AppDelegate.swift
//  kangfuba
//
//  Created by lvxin on 16/10/12.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.isIdleTimerDisabled = true
        UMAnalyticsConfig.sharedInstance().appKey = "586484fdcae7e7063800224b"
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())

        Thread.sleep(forTimeInterval: 1.0)//延时一会儿
        
        let guideVC : GuideViewController = GuideViewController()
        let shouldShowGuide:Bool = guideVC.shouldShowGuide()
        
        if shouldShowGuide{
            guideVC.setGuideImages()
            self.window?.rootViewController = guideVC
            //实现回调，接收回调过来的值
            guideVC.setBackMyClosure { (inputText:String) -> Void in
                self.mainMenu()
            }
            
        }else{
            self.mainMenu()
        }

        return true
    }
    
    func mainMenu() {
        
        let login = LoginModel.getLoginIdAndTokenInUD().isHaveLogin
        KFBLog(message: "login\(login)")
        if login == "1" {
            //显示主页
            self.showMain()
        } else {
            //显示登录注册页面
            self.showLogOrRegister()
        }
    }
    
    func showLogOrRegister() {

        let logVC : LoginOrRegisterViewController = LoginOrRegisterViewController()
        let logNv :UINavigationController = UINavigationController(rootViewController: logVC)
        //logNv.setNavigationBarHidden(true, animated: true)
        self.window?.rootViewController = logNv
    }

    func showMain(){
        //首页
        let homeVc :HomeViewController = HomeViewController()
        let homeNv :UINavigationController = UINavigationController(rootViewController: homeVc)
        let item1:UITabBarItem = UITabBarItem(title:"康复", image:UIImage.init(named: "tab_irecure_normal")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: "tab_irecure_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        
        homeNv.tabBarItem = item1
        //课程
        let CourseVC : CourseViewController = CourseViewController()
        let CourseNv :UINavigationController = UINavigationController(rootViewController: CourseVC)
        let item2:UITabBarItem = UITabBarItem(title:"课程", image:UIImage.init(named: "tab_course_normal")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: "tab_course_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        CourseNv.tabBarItem = item2
        //个人
        let PersonalVC : PersonalViewController = PersonalViewController()
        let PersonaNv :UINavigationController = UINavigationController(rootViewController: PersonalVC)
        let item3:UITabBarItem = UITabBarItem(title:"个人", image:UIImage.init(named: "tab_person_normal")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage.init(named: "tab_person_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        PersonaNv.tabBarItem = item3

        //大底部导航栏
        let vcArr = [homeNv,CourseNv,PersonaNv]
        let tab : UITabBarController = UITabBarController()
//        tab.tabBar.tintColor = .black
        tab.tabBar.backgroundColor = .white
        tab.delegate = self
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:MAIN_GREEN_COLOUR, forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState.normal)
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object:GREEN_COLOUR, forKey:NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject], for:UIControlState.selected)
        tab.viewControllers = vcArr
        self.window?.rootViewController = tab

    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let num = tabBarController.selectedIndex

        if num == 0 {
            MobClick.event("13")
        } else if num == 1 {
            MobClick.event("14")
        } else {
            MobClick.event("15")
        }
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

