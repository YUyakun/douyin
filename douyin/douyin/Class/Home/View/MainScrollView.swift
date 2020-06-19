//
//  MainScrollView.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/11.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

class MainScrollView: UIScrollView {

    //当UIscrollview在水平方向滑动到第一个时，默认不能全屏返回，实现下面的方法可以解决此问题
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if panBack(gestureRecognize: gestureRecognizer) {
            return false
        }
        return true
    }

    func panBack(gestureRecognize: UIGestureRecognizer) -> Bool {
        if gestureRecognize == self.panGestureRecognizer {
            let point = self.panGestureRecognizer.translation(in: self)
            //设置手势滑动距离屏幕坐标的区域
            let locationDistance = UIScreen.main.bounds.size.width
            if gestureRecognize.state == .began || gestureRecognize.state == .possible {
                let location = gestureRecognize.location(in: self)
                // 判断如果开始滑动并且当前的滑动小于最大滑动区域就允许侧滑
                if point.x > 0 && location.x < locationDistance && self.contentOffset.x <= 0 {
                    return true
                }
                // 临界点：scrollView滑动到最后一屏时的x轴位置，可根据需求更改
                let criticalPoint = UIScreen.main.bounds.size.width
                // point.x < 0 代表左滑即手势从屏幕右边向左移动
                //当UIscrollview滑动到临界点时，则不再响应UIscrollview的滑动手势，防止与左滑手势冲突
                if point.x < 0 && self.contentOffset.x < criticalPoint {
                    return true
                }
            }
        }
        return false
    }

}
