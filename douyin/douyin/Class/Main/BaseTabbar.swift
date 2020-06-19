//
//  BaseTabbar.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/10.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

class BaseTabbar: UITabBar {

    lazy var publishBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btn_home_add"), for: .normal)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(publishBtn)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.size.width
        var btnX:CGFloat = 0
        let btnY:CGFloat = 0
        let btnW:CGFloat = width / 5
        var btnH:CGFloat = 0
        publishBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: 49)
        publishBtn.center = CGPoint(x: width * 0.5, y: 49 * 0.5)

        var index = 0
        for btn in subviews {
            if !btn.isKind(of: UIControl.self) || btn == publishBtn {
                continue
            }
            btnX = btnW * CGFloat((index > 1 ? index + 1 : index))
            btnH = btn.frame.size.height
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)

            index += 1
        }



    }
}
