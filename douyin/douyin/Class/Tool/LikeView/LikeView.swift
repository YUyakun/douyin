//
//  LikeView.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/12.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

class LikeView: UIView {

    var isLike = false
    lazy var likebeforeImgView: UIImageView = {
        let likeBefore = UIImageView()
        likeBefore.image = UIImage(named: "ic_home_like_before")
        return likeBefore
    }()
    lazy var likeAfterImgView: UIImageView = {
        let likeAfterImgView = UIImageView()
        likeAfterImgView.image = UIImage(named: "ic_home_like_after")
        return likeAfterImgView
    }()
    lazy var countLabel: UILabel = {
        let countLab = UILabel()
        countLab.textColor = .white
        countLab.font = .systemFont(ofSize: 13)
        return countLab
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(likebeforeImgView)
        addSubview(likeAfterImgView)
        addSubview(countLabel)

        likebeforeImgView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        likeAfterImgView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var center = likebeforeImgView.center
        center.x = frame.size.width / 2
        likebeforeImgView.center = center
        likeAfterImgView.center = center
        countLabel.sizeToFit()
        let countX = (frame.size.width - countLabel.frame.size.width) / 2
        let countY = frame.size.height - countLabel.frame.size.height
        countLabel.frame = CGRect(x: countX, y: countY, width: countLabel.frame.size.width, height: countLabel.frame.size.height)

    }

    public func setupLikeState(isLike: Bool) -> Void {
        self.isLike = isLike
        likeAfterImgView.isHidden = !isLike
    }
    public func setupLikeCount(count: String) -> Void {
        countLabel.text = count
        layoutSubviews()
    }
    public func startAnimation(isLike: Bool) {
        if self.isLike == isLike {
            return
        }
        self.isLike = isLike
        if isLike {
            let length: CGFloat = 30
            let duration: CGFloat = 0.5
            for i in 0..<6 {
                let layer = CAShapeLayer()
                layer.position = likebeforeImgView.center
                layer.fillColor = UIColor(r: 232, g: 50, b: 85).cgColor
                let startPath = UIBezierPath()
                startPath.move(to: CGPoint(x: -2, y: -length))
                startPath.addLine(to: CGPoint(x: 2, y: -length))
                startPath.addLine(to: CGPoint(x: 0, y: 0))
                layer.path = startPath.cgPath

                layer.transform = CATransform3DMakeRotation(CGFloat(Int(Double.pi) / 3 * i), 0, 0, 1)
                self.layer.addSublayer(layer)

                let group = CAAnimationGroup()
                group.isRemovedOnCompletion = false
                group.timingFunction = CAMediaTimingFunction(name: .easeOut)
                group.fillMode = .forwards
                group.duration = CFTimeInterval(duration)

                let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
                scaleAnim.fromValue = 0
                scaleAnim.toValue = 1
                scaleAnim.duration = CFTimeInterval(duration * 0.2)

                let endPath = UIBezierPath()
                endPath.move(to: CGPoint(x: -2, y: -length))
                endPath.addLine(to: CGPoint(x: 2, y: -length))
                endPath.addLine(to: CGPoint(x: 0, y: -length))

                let pathAnim = CABasicAnimation(keyPath: "path")
                pathAnim.fromValue = layer.path
                pathAnim.toValue = endPath.cgPath
                pathAnim.beginTime = CFTimeInterval(duration * 0.2)
                pathAnim.duration = CFTimeInterval(duration * 0.8)
                group.animations = [scaleAnim, pathAnim]
                layer.add(group, forKey: nil)


            }
            likeAfterImgView.isHidden = false
            likeAfterImgView.alpha = 0
            likeAfterImgView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.15, animations: {
                self.likeAfterImgView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.likeAfterImgView.alpha = 1
                self.likebeforeImgView.alpha = 0
            }) { (bool) in
                self.likeAfterImgView.transform = CGAffineTransform.identity
                self.likebeforeImgView.alpha = 1
            }

        } else {
            likeAfterImgView.alpha = 1
            likeAfterImgView.transform = CGAffineTransform(scaleX: 1, y: 1)
            UIView.animate(withDuration: 0.15, animations: {
                self.likeAfterImgView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

            }) { (bool) in
                self.likeAfterImgView.transform = CGAffineTransform.identity
                self.likeAfterImgView.isHidden = true
            }
        }
    }

    @objc func tapAction() {
        if self.isLike {
            startAnimation(isLike: false)
        } else {
            startAnimation(isLike: true)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
