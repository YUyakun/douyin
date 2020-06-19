//
//  AppDelegate.swift
//  douyin
//
//  Created by yu on 2020/6/14.
//  Copyright © 2020 yu. All rights reserved.
//

import UIKit
import GKNavigationBarSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setNavUI()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let tabbar = BaseTabbarController()
        window?.rootViewController = tabbar
        window?.makeKeyAndVisible()
        return true
    }

    func setNavUI() -> Void {
        GKConfigure.setupCustom { (config) in
            config.backStyle = .white
            config.titleColor = .white
            config.statusBarStyle = .lightContent

        }
    }
}

