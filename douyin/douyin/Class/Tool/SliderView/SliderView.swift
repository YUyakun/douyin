//
//  SliderView.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/13.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

@objc protocol SliderViewDelegate: NSObjectProtocol {
    //滑块滑动开始
    @objc optional func sliderTouchBegan(value: Float)
    //滑块滑动中
    @objc optional func sliderValueChange(value: Float)
    //滑块滑动结束
    @objc optional func sliderTouchEnd(value: Float)
    //滑块点击
    @objc optional func sliderTouch(value: Float)
}

let sliderBtnW:CGFloat = 19
let progressMargin:CGFloat = 2
let progressH: CGFloat = 3


class SliderView: UIView {

    weak var delegate: SliderViewDelegate?
    var lastPoint: CGPoint = .zero
    var tapGesture = UITapGestureRecognizer()
    // 默认滑竿颜色
    var maximumTrackTintColor: UIColor = .white {
        didSet {
            bgProgressView.backgroundColor = maximumTrackTintColor
        }
    }
    //滑竿进度颜色
    var minimumTrackTintColor: UIColor = .white {
        didSet {
            sliderProgressView.backgroundColor = minimumTrackTintColor
        }
    }
    //缓存进度颜色
    var bufferTrackTintColor: UIColor = .white {
        didSet {
            bufferProgressView.backgroundColor = bufferTrackTintColor
        }
    }
    //默认滑竿图片
    var maximumTrackImage: UIImage? = nil {
        didSet {
            bgProgressView.image = maximumTrackImage
            maximumTrackTintColor = .clear
        }
    }
    //滑杆进度的图片
    var minimumTrackImage: UIImage? = nil {
        didSet {
            sliderProgressView.image = minimumTrackImage
            minimumTrackTintColor = .clear
        }
    }
    //缓存进度的图片
    var bufferTrackImage: UIImage? = nil {
        didSet {
            bufferProgressView.image = bufferTrackImage
            bufferTrackTintColor = .clear
        }
    }
    //滑杆进度
    var value: CGFloat = 0 {
        didSet {
            let finishValue = bgProgressView.frame.size.width * value
            sliderProgressView.frame.size.width = finishValue
            slideBtn.frame.origin.x = (self.frame.size.width - slideBtn.frame.size.width) * value
            lastPoint = slideBtn.center
        }
    }
    //缓存进度
    var bufferValue: CGFloat = 0 {
        didSet {
            let finishValue = bgProgressView.frame.size.width * bufferValue
            bufferProgressView.frame.size.width = finishValue

        }
    }
    //是否允许点击，默认是YES
    var allowTapped: Bool = true {
        didSet {
            if isHideSliderBlock == false {
                self.removeGestureRecognizer(tapGesture)
            }
        }
    }
    //设置滑杆的高度
    var sliderHeight: CGFloat = 0 {
        didSet {
            bgProgressView.frame.size.height = sliderHeight
            bufferProgressView.frame.size.height = sliderHeight
            sliderProgressView.frame.size.height = sliderHeight
        }
    }
    //是否隐藏滑块（默认为NO）
    var isHideSliderBlock: Bool = false {
        didSet {
            if isHideSliderBlock {
                slideBtn.isHidden = true
                bgProgressView.frame.origin.x = 0
                bufferProgressView.frame.origin.x = 0
                sliderProgressView.frame.origin.x = 0
                allowTapped = false
            }
        }
    }
    //设置滑块背景色
    func SetBackgroundImage(image: UIImage, state: UIControl.State) -> Void {
        slideBtn.setBackgroundImage(image, for: state)
        slideBtn.sizeToFit()
    }
    //设置滑块图片
    func setThumbImage(image: UIImage, state: UIControl.State) -> Void {
        slideBtn.setImage(image, for: state)
        slideBtn.sizeToFit()
    }
    //显示菊花动画
    func ShowLoading() -> Void {
        slideBtn.showActivityAnim()
    }
    //隐藏菊花动画
    func hideLoading() -> Void {
        slideBtn.hideActivityAnim()
    }
    //显示进度条动画
    func showLineLoading() -> Void {
        LineLoadingView.showLoading(view: self, lineHeight: self.frame.size.height)
    }
    //隐藏进度条动画
    func hideLineLoading() -> Void {
        LineLoadingView.hideLoading(view: self)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)


        addSubViews()
    }
    //添加子视图
    func addSubViews() -> Void {
        //背景透明
        self.backgroundColor = .clear
        self.addSubview(bgProgressView)
        self.addSubview(bufferProgressView)
        self.addSubview(sliderProgressView)
        self.addSubview(slideBtn)

        bgProgressView.frame = CGRect(x: progressMargin, y: 0, width: 0, height: progressH)
        bufferProgressView.frame = bgProgressView.frame
        sliderProgressView.frame = bgProgressView.frame
        slideBtn.frame = CGRect(x: 0, y: 0, width: sliderBtnW, height: sliderBtnW)

        tapGesture.addTarget(self, action: #selector(tapped))
        self.addGestureRecognizer(tapGesture)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if slideBtn.isHidden {
            bgProgressView.frame.size.width = self.frame.size.width
        } else {
            bgProgressView.frame.size.width = self.frame.size.width - progressMargin * 2
        }
        bgProgressView.center.y = self.frame.size.height * 0.5
        bufferProgressView.center.y = self.frame.size.height * 0.5
        sliderProgressView.center.y = self.frame.size.height * 0.5
        slideBtn.center.y = self.frame.size.height * 0.5
    }

    lazy var bgProgressView: UIImageView = {
        let bgProgressView = UIImageView()
        bgProgressView.backgroundColor = .gray
        bgProgressView.contentMode = .scaleAspectFill
        bgProgressView.clipsToBounds = true
        return bgProgressView
    }()

    lazy var bufferProgressView: UIImageView = {
        let bufferProgressView = UIImageView()
        bufferProgressView.backgroundColor = .white
        bufferProgressView.contentMode = .scaleAspectFill
        bufferProgressView.clipsToBounds = true
        return bufferProgressView
    }()
    lazy var sliderProgressView: UIImageView = {
        let sliderProgressView = UIImageView()
        sliderProgressView.backgroundColor = .red
        sliderProgressView.contentMode = .scaleAspectFill
        sliderProgressView.clipsToBounds = true
        return sliderProgressView
    }()
    lazy var slideBtn: sliderButton = {
        let slideBtn = sliderButton()
        slideBtn.addTarget(self, action: #selector(sliderBtnTouchBegin), for: .touchDown)
        slideBtn.addTarget(self, action: #selector(sliderBtnTouchEnded), for: .touchCancel)
        slideBtn.addTarget(self, action: #selector(sliderBtnTouchEnded), for: .touchUpInside)
        slideBtn.addTarget(self, action: #selector(sliderBtnTouchEnded), for: .touchUpOutside)
        slideBtn.addTarget(self, action: #selector(slideDragMoving), for: .touchDragInside)
        return slideBtn
    }()

    @objc func sliderBtnTouchBegin() {
        if delegate != nil {
            delegate?.sliderTouchBegan?(value: Float(value))
        }
    }
    @objc func sliderBtnTouchEnded() {
        if delegate != nil {
            delegate?.sliderTouchEnd?(value: Float(value))
        }
    }
    @objc func slideDragMoving(btn: UIButton, event: UIEvent) {
        //获取点击位置
        let point = event.allTouches?.first?.location(in: self) ?? .zero
        //获取进度值 由于btn是从 0-(self.width - btn.width)
        var value = CGFloat((point.x - btn.frame.size.width * 0.5) / (self.frame.size.width - btn.frame.size.width))
        // value 0 - 1 之间
        value = value >= 1 ? 1 : value <= 0 ? 0 : value
        self.value = value
        if delegate != nil {
            delegate?.sliderValueChange?(value: Float(value))
        }
    }
    @objc func tapped(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        // 获取进度
        var value = (point.x - bgProgressView.frame.origin.x) * 1 / bgProgressView.frame.size.width
        value = value > 1 ? 1 : value <= 0 ? 0 : value
        self.value = value
        if delegate != nil {
            delegate?.sliderTouch?(value: Float(value))
        }
    }
}

class sliderButton: UIButton {

    let indicatorView = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        indicatorView.style = .gray
        indicatorView.isUserInteractionEnabled = false
        indicatorView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        indicatorView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.addSubview(indicatorView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    }

    //展示菊花动画
    public func showActivityAnim() {
        indicatorView.startAnimating()
    }
    //隐藏菊花
    public func hideActivityAnim() {
        indicatorView.startAnimating()
    }
    //重写此方法让按钮的点击范围扩大
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = self.bounds
        //扩大区域
        bounds = bounds.insetBy(dx: -20, dy: -20)
        //若点击的点在新的bounds里面，就返回true
        return bounds.contains(bounds)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
