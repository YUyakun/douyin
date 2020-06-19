//
//  UIViewExtension.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/12.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

public extension UIView {

    func clickToBound(corner: UIRectCorner, radius: CGFloat) -> Void {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer

    }

    
}
