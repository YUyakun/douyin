//
//  DoubleLikeView.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/13.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

class DoubleLikeView: UIView {

    func createAnimation(touches: Set<UITouch>, event: UIEvent?) -> Void {
        let touch = touches.first
        if touch?.tapCount ?? 0 <= 1 {
            return
        }
        let point = touch?.location(in: touch?.view)
        let image = UIImage(named: "likeHeart")
        let imaView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        imaView.image = image
        imaView.contentMode = .scaleAspectFill
        imaView.center = point!
        //随机左右显示
        var leftOrRight:Int = Int(arc4random() % 2)
        leftOrRight = leftOrRight > 0 ? leftOrRight : -1
        imaView.transform = imaView.transform.rotated(by: CGFloat(Int((Double.pi)) / 9 * leftOrRight))
        touch?.view?.addSubview(imaView)

        //出现的时候回弹一下
        UIView.animate(withDuration: 0.1, animations: {
            imaView.transform = imaView.transform.scaledBy(x: 1.2, y: 1.2)
        }) { (bool) in
            imaView.transform = imaView.transform.scaledBy(x: 0.8, y: 0.8)
            self.perform(#selector(self.animationToTop(imaObjects:)), with: [imaView,image], afterDelay: 0.3)
        }

    }

    @objc func animationToTop(imaObjects: [Any]) -> Void {
        if imaObjects.count > 0 {
            let imgView = imaObjects.first as! UIImageView
            UIView.animate(withDuration: 1, animations: {
                var imgViewFrame = imgView.frame
                imgViewFrame.origin.x -= 100
                imgView.frame = imgViewFrame
                imgView.transform = imgView.transform.scaledBy(x: 1.8, y: 1.8)
                imgView.alpha = 0
            }) { (bool) in
                imgView.removeFromSuperview()
            }


        }
    }
}
