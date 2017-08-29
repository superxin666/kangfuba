//
//  InjureHeadView.swift
//  kangfuba
//
//  Created by lvxin on 2016/12/28.
//  Copyright © 2016年 Xunqiu. All rights reserved.
//  常见伤病头部

import UIKit
typealias InjuryHeadViewBlock = (_ model : commonInjuriesModel) ->()
class InjureHeadView: UIView {
    var InjuryHeadBlock : InjuryHeadViewBlock!
    var homeModel : HomeViewModel = HomeViewModel()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setUpUI(model : HomeViewModel)  {
        KFBLog(message: model.commonInjuriesTitle)
        homeModel = model
        //标题
        titleLabel.text = model.commonInjuriesTitle
        //图片
        let padding : CGFloat = 15
        let width : CGFloat = ip6(105)
        let height : CGFloat = ip6(70)
        let midPadding : CGFloat = (KSCREEN_WIDTH - 30 - ip6(105)*3)/2

        for i in 0...2 {
            let subModel :commonInjuriesModel = model.commonInjuries[i]
            let subView : UIView = UIView(frame: CGRect(x: padding + CGFloat(i) * (width + midPadding), y: titleLabel.frame.maxY + 15 , width: width, height: height+31))
            //subView.backgroundColor = .red
            let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            imageView.setImageWith(URL.init(string: subModel.pic.getImageStr())!, placeholderImage: #imageLiteral(resourceName: "course_placeholder_mid"))
            imageView.isUserInteractionEnabled = true
            imageView.tag = i
            subView.addSubview(imageView)
            let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InjureHeadView.imageClick))
            subView.addGestureRecognizer(tap)

            let nameLabel : UILabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.maxY + 4, width: width, height: 27))
            nameLabel.textColor = KFBColorFromRGB(rgbValue: 0x4a4a4a)
            nameLabel.textAlignment = .center
            nameLabel.font = UIFont.systemFont(ofSize: 10)
            nameLabel.text = subModel.name
            //nameLabel.text = "把USD刚发了会计师的疯狂就爱上的恢复了卡机收到回复立刻就爱好是颠覆了金卡和第三方老卡机的护身符拉就开始对恢复了11"
            nameLabel.numberOfLines = 0
            subView.addSubview(nameLabel)
            backView.addSubview(subView)
        }
    }

    func imageClick(ges : UIGestureRecognizer) {
        let view : UIView = ges.view!
        let tagNum = view.tag
        let subModel :commonInjuriesModel = homeModel.commonInjuries[tagNum]
        KFBLog(message: "点击的是\(tagNum)")
        if let _ = InjuryHeadBlock{
            InjuryHeadBlock(subModel)
        }
    }
}

