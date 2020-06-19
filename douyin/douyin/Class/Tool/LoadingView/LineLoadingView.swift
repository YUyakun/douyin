//
//  LineLoadingView.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/13.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

let duration = 0.75

class LineLoadingView: UIView {

    class func showLoading(view: UIView, lineHeight: CGFloat) {
        let lineLoading = LineLoadingView(frame: view.frame, lineHeight: lineHeight)
        view.addSubview(lineLoading)
        lineLoading.startLoading()
    }
    class func hideLoading(view: UIView) {
        for subView in view.subviews {
            if subView.isKind(of: LineLoadingView.self) {
                let loadingView = view as! LineLoadingView
                loadingView.stopLoading()
                loadingView.removeFromSuperview()
            }
        }

    }

    convenience init(frame: CGRect, lineHeight: CGFloat) {
        self.init()
        self.backgroundColor = .white
        self.center = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        self.bounds = CGRect(x: 0, y: 0, width: 1, height: frame.size.height)
    }

    func startLoading() -> Void {
        stopLoading()
        //创建动画组
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.beginTime = CACurrentMediaTime()
        animationGroup.repeatCount = MAXFLOAT
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        //x轴缩放动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.x")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = self.superview?.frame.size.width
        //透明度
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0.5
        //把动画添加到动画组
        animationGroup.animations = [scaleAnimation,alphaAnimation]
        //添加动画
        self.layer.add(animationGroup, forKey: nil)


    }

    func stopLoading() -> Void {
        self.layer.removeAllAnimations()
        self.isHidden = true
    }

}
