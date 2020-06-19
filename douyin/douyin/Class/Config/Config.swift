//
//  Config.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/10.
//  Copyright © 2020 yyk. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

let ScreenW = UIScreen.main.bounds.size.width
let ScreenH = UIScreen.main.bounds.size.height

let Is_ipone = UI_USER_INTERFACE_IDIOM() == .phone
let Is_iponeX = (Is_ipone && ScreenH >= 812) ? true : false

let StatusBarH:CGFloat = Is_iponeX ? 44 : 20
let NaviBarH:CGFloat = Is_iponeX ? 88 : 64
let TabbarH:CGFloat = Is_iponeX ? 83 : 49


extension Kingfisher where Base: UIImageView {
    public func setImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "placeholderimg")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""), placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
    }
}
extension Kingfisher where Base: UIButton {
    public func setImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? "placeholderimg"),
                        for: state,
                        placeholder: placeholder,
                        options: nil)

    }
}
