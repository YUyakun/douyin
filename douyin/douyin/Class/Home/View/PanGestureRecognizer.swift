//
//  PanGestureRecognizer.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/13.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

let panThreshold = 5

enum panGestureRecognizerDirection {
    case Vertical//上下
    case Horzontal//左右
}
class PanGestureRecognizer: UIPanGestureRecognizer {

    var direction: panGestureRecognizerDirection = .Vertical
    private var drag: Bool = true
    private var moveX: CGFloat = 0
    private var moveY: CGFloat = 0


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if self.state == .failed {
            return
        }
        let nowPoint = touches.first?.location(in: self.view) ?? CGPoint(x: 0, y: 0)
        let prevPoint = touches.first?.previousLocation(in: self.view) ?? CGPoint(x: 0, y: 0)
        moveX += prevPoint.x - nowPoint.x
        moveY += prevPoint.y - nowPoint.y
        if drag == false {
            if abs(Int32(moveX)) > panThreshold {
                if direction == .Vertical {
                    self.state = .failed
                } else {
                    drag = true
                }
            } else if abs(Int32(moveY)) > panThreshold {
                if direction == .Horzontal {
                    self.state = .failed
                } else {
                    drag = true
                }
            }
        }
    }

    override func reset() {
        super.reset()
        drag = false
        moveY = 0
        moveX = 0
    }
}
