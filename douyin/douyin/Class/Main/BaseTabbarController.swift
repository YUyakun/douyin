//
//  BaseTabbarController.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/10.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit


class BaseTabbarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        tabBar.isTranslucent = false

        addChildVC(VC: HomeViewController(), title: "首页")
        addChildVC(VC: AttentViewController(), title: "关注")
        addChildVC(VC: MessageViewController(), title: "消息")
        addChildVC(VC: MineViewController(), title: "我")

        let tabbar = BaseTabbar()
        self.setValue(tabbar, forKey: "tabBar")
        
        self.tabBar.backgroundImage = UIColor.background.image()
        self.tabBar.shadowImage = UIImage()
    }
    

    func addChildVC(VC: UIViewController, title: String) -> Void {
        VC.tabBarItem.title = title
        VC.title = title
        VC.tabBarItem.image = UIColor.clear.image(size: CGSize(width: 36, height: 3)).withRenderingMode(.alwaysOriginal)
        VC.tabBarItem.selectedImage = UIColor.white.image(size: CGSize(width: 36, height: 3)).withRenderingMode(.alwaysOriginal)
        VC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -16)
        VC.tabBarItem.imageInsets = UIEdgeInsets(top: 28, left: 0, bottom: -28, right: 0)
        VC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        VC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20)], for: .selected)
        let na = BaseNavViewController(rootVC: VC, scale: false)
        na.gk_openScrollLeftPush = true
        addChild(na)

    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }

}
