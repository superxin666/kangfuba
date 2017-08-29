//
//  SportsViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2016/12/30.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//

import UIKit

let SportsDetailCollectionViewCell_Id = "SportsDetailCollectionViewCell_Id"

class SportsViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    let request = InguryDataManger.sharedInstance
    var dataModel : SportsModel = SportsModel()
    var createProgramModel : CreateProgramModel = CreateProgramModel()

    var colletionView : UICollectionView!
    var nextButton : UIButton = UIButton(type: UIButtonType.custom)

    var selectedId:Int = 0
    
    // MARK: helpView懒加载
    lazy var Home_HeadView : UIView = { () -> UIView in
        
        let Home_HeadView:UIView = UIView(frame:CGRect(x:0,y:0,width:KSCREEN_WIDTH,height:KSCREEN_HEIGHT))
        Home_HeadView.backgroundColor = UIColor.black
        Home_HeadView.alpha = 0.7
        return Home_HeadView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.naviagtionTitle(titleName: "运动种类")
        self.navigationBar_leftBtn()

        self.createUI()

        weak var weakSelf = self

        request.getSecondGuideMenu(complate: { (data) in
            weakSelf?.dataModel = data as! SportsModel
            
            weakSelf?.colletionView.reloadData()
        }) { (error) in
            self.KfbShowWithInfo(titleString: error)

        }
        
    }
    

    func createUI() {
        
        let headerLb = UILabel(frame:CGRect(x:ip6(40),y:ip6(20),width:KSCREEN_WIDTH-ip6(80),height:ip6(20)))
        headerLb.text = "选择你经常参加的体育活动"
        headerLb.font = UIFont.systemFont(ofSize: 12)
        headerLb.textColor = GRAY656A72_COLOUR
        headerLb.textAlignment = .center
        self.view.addSubview(headerLb)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ip6(65), height: ip6(90))
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = ip6(25)
        layout.minimumLineSpacing = ip6(20)
        colletionView = UICollectionView(frame: CGRect(x: ip6(40), y:ip6(70), width: KSCREEN_WIDTH-ip6(80), height: KSCREEN_HEIGHT - 64 - ip6(150)), collectionViewLayout: layout)
        //注册一个cell
        colletionView.register(SportsDetailCollectionViewCell.self, forCellWithReuseIdentifier: SportsDetailCollectionViewCell_Id)
        
        colletionView.backgroundColor = .clear
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.showsVerticalScrollIndicator = false
        colletionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(colletionView)
        
        let bottomView  = UIView(frame:CGRect(x:0,y:KSCREEN_HEIGHT-64-ip6(80),width:KSCREEN_WIDTH,height:ip6(80)))
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        nextButton.setTitle("下一步", for: UIControlState.normal)
        nextButton.layer.cornerRadius = 2
        nextButton.layer.masksToBounds = true
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        nextButton.frame = CGRect(x: KSCREEN_WIDTH-ip6(125), y:ip6(24), width:ip6(75), height: ip6(32))
        nextButton.setTitleColor( UIColor.white , for: UIControlState.normal)
        nextButton.backgroundColor = GRAY999999_COLOUR
        nextButton.addTarget(self, action:#selector(self.nextClick) , for: UIControlEvents.touchUpInside)
        bottomView.addSubview(nextButton)


    }
    
    func nextClick(){
        if selectedId == 0 {
            KfbShowWithInfo(titleString: "请选择运动种类")
        }else{
            MobClick.event("009")
            weak var weakSelf = self
            self.SVshow()
            
            request.getUserFavouriteSport(favouriteSportId: selectedId, complate: { (data) in
                weakSelf?.createProgramModel = data as! CreateProgramModel
                weakSelf?.SVdismiss()
                
                if  (weakSelf?.createProgramModel.status)! > 0{
                    
                    let dele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
                    dele.showMain()
                    
                } else {
                    weakSelf?.KfbShowWithInfo(titleString: (weakSelf?.createProgramModel.msg)!)
                    
                }

            }, failure: { (error) in
                weakSelf?.SVdismiss()
                
                weakSelf?.KfbShowWithInfo(titleString: "加载失败，请重试")
            })

        }
    }
    
    // MARK: 代理
    //每个区的item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataModel.datas.count
        
    }
    
    //分区个数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //自定义cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :SportsDetailCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: SportsDetailCollectionViewCell_Id, for: indexPath) as! SportsDetailCollectionViewCell
        
        //这是解决cell复用时重叠（比如label）的方法
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        if indexPath.row < self.dataModel.datas.count {
            cell.setSportsUI(model: self.dataModel.datas[indexPath.row])
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < self.dataModel.datas.count {
            let model = self.dataModel.datas[indexPath.row]
            
            if model.selected == 0 {
                
                for model1 in self.dataModel.datas {
                    
                    model1.selected = 0
                }
                
                model.selected = 1
                selectedId = model.guideMenuId
                nextButton.backgroundColor = GREEN_COLOUR


            }else{
                model.selected = 0
                selectedId = 0
                nextButton.backgroundColor = GRAY999999_COLOUR

            }
            
            self.colletionView.reloadData()
            
        }
        
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
