//
//  NoRecurePlanViewController.swift
//  kangfuba
//
//  Created by LiChuanmin on 2017/1/3.
//  Copyright © 2017年 Xunqiu. All rights reserved.
//

import UIKit

class NoRecurePlanViewController: BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        naviagtionTitle(titleName: "康复建议方案")
        navigationBar_leftBtn()
        
        let bgImageView = UIImageView(frame: CGRect(x: ip6(80), y: ip6(160), width: ip6(237), height: ip6(356)))
        bgImageView.image = #imageLiteral(resourceName: "noRecurePlanBg")
        self.view.addSubview(bgImageView)

        
        let noPlanLabel = UILabel(frame:CGRect(x:0,y:ip6(80),width:KSCREEN_WIDTH/2,height:ip6(30)))
        
        noPlanLabel.text = "暂无康复方案，"
        noPlanLabel.textColor = GRAY999999_COLOUR
        noPlanLabel.backgroundColor = UIColor.white
        noPlanLabel.font = UIFont.systemFont(ofSize: 17)
        noPlanLabel.textAlignment = NSTextAlignment.left
        
        let testLabel = UILabel(frame:CGRect(x:KSCREEN_WIDTH/2,y:ip6(80),width:KSCREEN_WIDTH/2,height:ip6(30)))
        
        
        let testString = NSMutableAttributedString(string: "立即进行康复检测")
        testString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: NSMakeRange(0, 8))
        testLabel.attributedText = testString        
        
        testLabel.textColor = GREEN_COLOUR
        testLabel.backgroundColor = UIColor.white
        testLabel.font = UIFont.systemFont(ofSize: 17)
        testLabel.textAlignment = NSTextAlignment.left
        testLabel.isUserInteractionEnabled = true
        let testLabelTap = UITapGestureRecognizer(target:self,action:(#selector(self.testLabelClick)))
        testLabel.addGestureRecognizer(testLabelTap)
        
        noPlanLabel.frame.size.width = (noPlanLabel.text?.getLabWidth(labelStr: noPlanLabel.text!, font: UIFont.systemFont(ofSize: 17), LabelHeight: ip6(30)))!
        
        
        testLabel.frame.size.width = (testLabel.text?.getLabWidth(labelStr: testLabel.text!, font: UIFont.systemFont(ofSize: 17), LabelHeight: ip6(30)))!

        noPlanLabel.frame.origin.x = (KSCREEN_WIDTH - noPlanLabel.frame.size.width - testLabel.frame.size.width)/2
        testLabel.frame.origin.x = noPlanLabel.frame.origin.x + noPlanLabel.frame.size.width
        
        self.view.addSubview(noPlanLabel)
        self.view.addSubview(testLabel)
        

        // Do any additional setup after loading the view.
    }

    func testLabelClick() {
        
        let vc:InguryGuideViewController = InguryGuideViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.FromId = 1
        self.navigationController?.pushViewController(vc, animated: true)

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
