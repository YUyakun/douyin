//
//  VideoControlView.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/12.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

@objc protocol VideoControlViewDelegate: NSObjectProtocol {
    func controlViewDidClickSelf(controlView: VideoControlView)
    func controlViewDidClickIcon(controlView: VideoControlView)
    func controlViewDidClickPriase(controlView: VideoControlView)
    func controlViewDidClickComment(controlView: VideoControlView)
    func controlViewDidClickShare(controlView: VideoControlView)
    func controlView(controlView: VideoControlView, touches: Set<UITouch>, event: UIEvent?)
}

class VideoControlView: UIView {

    weak var delegate: VideoControlViewDelegate?

    lazy var coverImgView: UIImageView = {
        let coverImgView = UIImageView()
        coverImgView.contentMode = .scaleAspectFill
        coverImgView.clipsToBounds = true
        return coverImgView
    }()
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.clickToBound(corner: .allCorners, radius: 50)
        iconView.layer.borderColor = UIColor.white.cgColor
        iconView.layer.borderWidth = 1
        iconView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconClick))
        return iconView
    }()
    lazy var likeView: LikeView = {
        let likeView = LikeView()
        return likeView
    }()
    lazy var commentBtn: VideoItemButton = {
        let commentBtn = VideoItemButton()
        commentBtn.setImage(UIImage(named: "icon_home_comment"), for: .normal)
        commentBtn.titleLabel?.font = .systemFont(ofSize: 13)
        commentBtn.setTitleColor(.white, for: .normal)
        commentBtn.addTarget(self, action: #selector(commentBtnClick), for: .touchUpInside)
        return commentBtn
    }()
    lazy var shareBtn: VideoItemButton = {
        let shareBtn = VideoItemButton()
        shareBtn.setImage(UIImage(named: "icon_home_share"), for: .normal)
        shareBtn.titleLabel?.font = .systemFont(ofSize: 13)
        shareBtn.setTitleColor(.white, for: .normal)
        shareBtn.addTarget(self, action: #selector(shareBtnClick), for: .touchUpInside)
        return shareBtn
    }()
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 15)
        nameLabel.isUserInteractionEnabled = true
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(iconClick))
        nameLabel.addGestureRecognizer(nameTap)
        return nameLabel
    }()
    lazy var contentlabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .white
        contentLabel.font = .systemFont(ofSize: 14)
        return contentLabel
    }()

    lazy var sliderView: SliderView = {
        let sliderView = SliderView()
        sliderView.isHideSliderBlock = true
        sliderView.sliderHeight = 1
        sliderView.maximumTrackTintColor = .clear
        sliderView.minimumTrackTintColor = .white
        return sliderView
    }()
    lazy var playBtn: UIButton = {
        let playBtn = UIButton()
        playBtn.setImage(UIImage(named: "ss_icon_pause"), for: .normal)
        playBtn.isHidden = true
        return playBtn
    }()
    @objc func controlViewDidClick() {
        if delegate != nil {
            delegate?.controlViewDidClickSelf(controlView: self)
        }
    }
    @objc func iconClick() {
        if delegate != nil {
            delegate?.controlViewDidClickIcon(controlView: self)
        }
    }
    func praiseBtnClick() {
        if delegate != nil {
            delegate?.controlViewDidClickPriase(controlView: self)
        }
    }
    @objc func commentBtnClick() {
        if delegate != nil {
            delegate?.controlViewDidClickComment(controlView: self)
        }
    }
    @objc func shareBtnClick() {
        if delegate != nil {
            delegate?.controlViewDidClickShare(controlView: self)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let delayTime: TimeInterval = 0.3
        if touch?.tapCount ?? 0 <= 1 {
            self.perform(#selector(controlViewDidClick), with: nil, afterDelay: delayTime)
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(controlViewDidClick), object: nil)
            if delegate != nil {
                delegate?.controlView(controlView: self, touches: touches, event: event)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(coverImgView)
        self.addSubview(iconView)
        self.addSubview(likeView)
        self.addSubview(commentBtn)
        self.addSubview(shareBtn)
        self.addSubview(nameLabel)
        self.addSubview(contentlabel)
        self.addSubview(sliderView)
        self.addSubview(playBtn)
        coverImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        sliderView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        contentlabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(504)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentlabel)
            make.bottom.equalTo(contentlabel.snp.bottom).offset(-20)
        }
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-100)
            make.width.height.equalTo(110)
        }
        commentBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(shareBtn.snp.top).offset(-45)
            make.width.height.equalTo(110)
        }
        likeView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(commentBtn.snp.top).offset(-45)
            make.width.height.equalTo(110)
        }
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(shareBtn)
            make.bottom.equalTo(likeView.snp.top).offset(-70)
            make.width.height.equalTo(100)
        }
        playBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    var model: VideoModel? {
        didSet {
            sliderView.value = 0
            let width = Float(model?.video_width ?? "0") ?? 0
            let height = Float(model?.video_height ?? "0") ?? 0
            if width > height {
                coverImgView.contentMode = .scaleAspectFit
            } else {
                coverImgView.contentMode = .scaleAspectFill
            }
            coverImgView.kf.setImage(with: URL(string: model?.thumbnail_url ?? ""), placeholder: UIImage(named: "img_video_loading"), options: nil, progressBlock: nil, completionHandler: nil)
            nameLabel.text = String(format:"@\(model?.author?.name_show ?? "")")
            if model?.author?.portrait?.hasPrefix("http") ?? false {
                iconView.kf.setImage(with: URL(string: model?.author?.portrait ?? ""), placeholder: UIImage(named: "placeholderimg"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                iconView.image = UIImage(named: "placeholderimg")
            }
            contentlabel.text = model?.title
            likeView.setupLikeState(isLike: ((model?.is_agreed) != nil))
            likeView.setupLikeCount(count: model?.agree_num ?? "")
            commentBtn.setTitle(model?.comment_num, for: .normal)
            shareBtn.setTitle(model?.share_num, for: .normal)
        }
    }
    //进度条
    public func progress(progree: CGFloat) {
        sliderView.value = progree
    }
    //显示进度条动画
    public func startLoading() {
        sliderView.showLineLoading()
    }
    //隐藏进度条动画
    public func stopLoading() {
        sliderView.hideLineLoading()
    }
    //显示播放按钮
    public func showPlayBtn() {
        playBtn.isHidden = false
    }
    //隐藏播放按钮
    public func hidePlayBtn() {
        playBtn.isHidden = true
    }
    //显示点赞动画
    public func showLikeAnimation() {
        likeView.startAnimation(isLike: true)
    }
    //隐藏点赞动画
    public func HideLikeAnimation() {
        likeView.startAnimation(isLike: false)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
