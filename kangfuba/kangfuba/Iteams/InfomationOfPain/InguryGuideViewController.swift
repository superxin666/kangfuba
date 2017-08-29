//
//  InguryGuideViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/12/30.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

class InguryGuideViewController: BaseViewController {

    var FromId:Int = 0//0-注册（返回到首页），1-非首页（返回pop）

    let request = InguryDataManger.sharedInstance
    var dataModel : guide1Model = guide1Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = LINE_COLOUR
        
        self.naviagtionTitle(titleName: "是否有运动损伤")
        self.navigationBar_leftBtn()
        
        weak var weakSelf = self
        
        request.getFirstGuideMenu(complate: { (data) in
            weakSelf?.dataModel = data as! guide1Model
    
            weakSelf?.createUI()
        }) { (error) in
            self.KfbShowWithInfo(titleString: error)

        }
    }

    func createUI()  {
        
        let inguryBottomImageView = UIImageView(frame:CGRect(x:KSCREEN_WIDTH/2 - ip6(76),y:self.view.frame.size.height-ip6(30),width:ip6(152),height:ip6(14)))
        inguryBottomImageView.image = #imageLiteral(resourceName: "inguryGuideBottom")
        self.view.addSubview(inguryBottomImageView)

        
        let model1:InguryGuideModel = self.dataModel.datas[0]
        let model2:InguryGuideModel = self.dataModel.datas[1]

        let inguryImageView1 = UIImageView(frame:CGRect(x:ip6(15),y:ip6(15),width:KSCREEN_WIDTH-ip6(30),height:ip6(200)))
        inguryImageView1.setImageWith(URL.init(string: model1.iconPic.getImageStr())!, placeholderImage: UIImage.init(named: "InguryGuide_placeholder_big"))
        inguryImageView1.isUserInteractionEnabled = true
        let inguryTap1 = UITapGestureRecognizer(target:self,action:(#selector(self.imageTapClick1)))
        inguryImageView1.addGestureRecognizer(inguryTap1)
        self.view.addSubview(inguryImageView1)
        
        
        let inguryImageView2 = UIImageView(frame:CGRect(x:ip6(15),y:ip6(230),width:KSCREEN_WIDTH-ip6(30),height:ip6(200)))
        inguryImageView2.setImageWith(URL.init(string: model2.iconPic.getImageStr())!, placeholderImage: UIImage.init(named: "InguryGuide_placeholder_big"))
        inguryImageView2.isUserInteractionEnabled = true
        let inguryTap2 = UITapGestureRecognizer(target:self,action:(#selector(self.imageTapClick2)))
        inguryImageView2.addGestureRecognizer(inguryTap2)
        self.view.addSubview(inguryImageView2)
        
    }
    
    func imageTapClick1()  {
        MobClick.event("004")
        let vc:PartOfPainViewController = PartOfPainViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func imageTapClick2()  {
        MobClick.event("005")
        let vc:SportsViewController = SportsViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    override func navigationLeftBtnClick() {
        
        if self.FromId == 0 {
            let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
            dele.showMain()
        }else{
            _=self.navigationController?.popViewController(animated: true)
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
