//
//  BaseNavViewController.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/10.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

class BaseNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let vc = self.topViewController
        return vc!.preferredStatusBarStyle

    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 {
            self.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
