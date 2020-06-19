//
//  BaseViewController.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/10.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit
import SnapKit
import Reusable
import SwiftyJSON
import ObjectMapper

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        barStyle(.theme)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }


}
enum UNavigationBarStyle {
    case theme
    case clear
}

extension BaseViewController {
    func barStyle(_ style: UNavigationBarStyle) -> Void {
        switch style {
        case .theme:
            navigationController?.navigationBar.setBackgroundImage(UIColor.background.image(), for: .default)
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.shadowImage = UIImage()
        case .clear:
            navigationController?.navigationBar.setBackgroundImage(UIColor.clear.image(), for: .default)
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
}
