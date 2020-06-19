//
//  BallLoadingView.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/13.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

let ballW: CGFloat = 12
let ballSpeed: CGFloat = 0.7
let ballZoomScale: CGFloat = 0.25
let ballPauseTime: CGFloat = 0.18

// 球的运动方向
enum ballMoveDirection {
    case ballMoveDirectionPositive //正向
    case ballMoveDirectionNegative //逆向
}

class BallLoadingView: UIView {

    //球容器视图
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    // 绿球
    lazy var greenBall: UIView = {
        let view = UIView()
        view.layer.cornerRadius = ballW * 0.5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(r: 35, g: 246, b: 235)
        return view
    }()
    //红球
    lazy var redBall: UIView = {
        let view = UIView()
        view.layer.cornerRadius = ballW * 0.5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(r: 255, g: 46, b: 86)
        return view
    }()
    //黑球
    lazy var blackBall: UIView = {
        let view = UIView()
        view.layer.cornerRadius = ballW * 0.5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(r: 12, g: 11, b: 17)
        return view
    }()
    var moveDirection: ballMoveDirection = .ballMoveDirectionPositive
    //定时器
    lazy var displayLink: CADisplayLink = {
        let display = CADisplayLink(target: self, selector: #selector(updateBallAnimations))
        return display
    }()

    class func loadingView(view: UIView) -> UIView {
        let loadingView = BallLoadingView(frame: view.bounds)
        view.addSubview(loadingView)
        return loadingView
    }
    public func startLoadingWithProgree(progress: CGFloat) {
        updateBallPosition(progress: progress)
    }
    //开始动画
    public func startLoading() {
        startAnimation()
    }
    //结束动画
    public func stopLoading() {
        stopAnimation()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(containerView)
        containerView.addSubview(greenBall)
        containerView.addSubview(redBall)
        greenBall.addSubview(blackBall)

        containerView.center = self.center
        containerView.bounds = CGRect(x: 0, y: 0, width: 2 * ballW, height: 2 * ballW)

        greenBall.center = CGPoint(x: ballW * 0.5, y: containerView.bounds.size.height * 0.5)
        greenBall.bounds = CGRect(x: 0, y: 0, width: ballW, height: ballW)
        redBall.center = CGPoint(x: containerView.bounds.size.width - ballW * 0.5, y: containerView.bounds.size.height * 0.5)
        redBall.bounds = CGRect(x: 0, y: 0, width: ballW, height: ballW)
        blackBall.frame = CGRect(x: 0, y: 0, width: ballW, height: ballW)
        containerView.bringSubviewToFront(greenBall)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //开始动画
    @objc func startAnimation() {
        stopAnimation()
        displayLink.add(to: RunLoop.main, forMode: .common)
    }
    //结束动画
    func stopAnimation() {
        displayLink.invalidate()
        //取消延时方法
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startAnimation), object: nil)
        //恢复初始化位置
        greenBall.addSubview(blackBall)
        containerView.bringSubviewToFront(greenBall)
        moveDirection = .ballMoveDirectionPositive
        updateBallPosition(progress: 0)
    }
    //暂停动画
    func pauseAnimation() {
        displayLink.invalidate()
    }
    //重置动画
    func resetAnimation() {
        pauseAnimation()
        //延迟执行方法
        self.perform(#selector(startAnimation), with: nil, afterDelay: TimeInterval(ballPauseTime))
    }
    func updateBallPosition(progress: CGFloat) {
        var center = greenBall.center
        center.x = ballW * 0.5 + 1.1 * ballW * progress
        greenBall.center = center
        center = redBall.center
        center.x = ballW * 1.6 - 1.1 * ballW * progress
        redBall.center = center
        //缩放动画 绿球变大红球变小
        if progress != 0 && progress != 1 {
            greenBall.transform = ballLargerTransform(centerX: center.x)
            redBall.transform = ballSmallTransform(centerX: center.x)
        } else {
            greenBall.transform = CGAffineTransform.identity
            redBall.transform = CGAffineTransform.identity
        }
        //更新黑球位置
        let blackBallFrame = redBall.convert(redBall.bounds, to: greenBall)
        blackBall.frame = blackBallFrame
        blackBall.layer.cornerRadius = blackBall.bounds.size.width * 0.5
    }

    @objc func updateBallAnimations() {
        if moveDirection == .ballMoveDirectionPositive {//正向
            var center = greenBall.center
            center.x += ballSpeed
            greenBall.center = center

            center = redBall.center
            center.x -= ballSpeed
            redBall.center = center

            //缩放动画，绿球变大，红球变小
            greenBall.transform = ballLargerTransform(centerX: center.x)
            redBall.transform = ballSmallTransform(centerX: center.x)
            //更新黑球位置
            let blackBallFrame = redBall.convert(redBall.bounds, to: greenBall)
            blackBall.frame = blackBallFrame
            blackBall.layer.cornerRadius = blackBall.bounds.size.width * 0.5
            //更新方向 改变三个球的相对位置
            if greenBall.frame.maxX >= containerView.bounds.size.width || redBall.frame.minX <= 0 {
                //切换方向
                moveDirection = .ballMoveDirectionNegative //逆向旋转
                //方向运动时，红球在上绿球在下
                containerView.bringSubviewToFront(redBall)
                //黑球放到红球上面
                redBall.addSubview(blackBall)
                //重置动画
                resetAnimation()
            }

        } else { //反向
            //更新绿球位置
            var center = greenBall.center
            center.x -= ballSpeed
            greenBall.center = center
            //更新红球位置
            center = redBall.center
            center.x += ballSpeed
            redBall.center = center
            //缩放动画 红球变大，绿球变小
            redBall.transform = ballLargerTransform(centerX: center.x)
            greenBall.transform = ballSmallTransform(centerX: center.x)
            //更新黑球位置
            let blackBallFrame = greenBall.convert(greenBall.bounds, to: redBall)
            blackBall.frame = blackBallFrame
            blackBall.layer.cornerRadius = blackBall.bounds.size.width * 0.5
            //更新方向 改变三个球的相对位置
            if greenBall.frame.maxX >= containerView.bounds.size.width || redBall.frame.minX <= 0 {
                //切换方向
                moveDirection = .ballMoveDirectionPositive //正向旋转
                //方向运动时，红球在上绿球在下
                containerView.bringSubviewToFront(greenBall)
                //黑球放到绿球上面
                greenBall.addSubview(blackBall)
                //重置动画
                resetAnimation()
            }
        }
    }
    //放大动画
    private func ballLargerTransform(centerX: CGFloat) -> CGAffineTransform {
        let value = cosValue(centerX: centerX)
        return CGAffineTransform(scaleX: 1 + value * ballZoomScale, y: 1 + value * ballZoomScale)
    }

    //缩小动画
    private func ballSmallTransform(centerX: CGFloat) -> CGAffineTransform {
        let value = cosValue(centerX: centerX)
        return CGAffineTransform(scaleX: 1 - value * ballZoomScale, y: 1 - value * ballZoomScale)
    }
    //根据余弦函数获取变化区间 0-1
    private func cosValue(centerX: CGFloat) -> CGFloat {
        //移动距离
        let apart = centerX - containerView.bounds.size.width * 0.5
        //最大距离（球心距离container中心距离）
        let maxAppart = (containerView.bounds.size.width - ballW) * 0.5
        //移动距离和最大距离的比例
        let angle = apart / maxAppart * CGFloat(Double.pi / 2)
        //获取比例对应余弦曲线的Y值
        return cos(angle)

    }
}
