//
//  PlayViewController.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/11.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit
import JXSegmentedView
import SwiftyJSON
import ObjectMapper
import MJRefresh

protocol PlayViewControllerDelegate: NSObjectProtocol {
    func didClickIcon(videoView: PlayViewController, videoModel: VideoModel?)
    func didClickPraise(videoView: PlayViewController, videoModel: VideoModel?)
    func didClickComment(videoView: PlayViewController, videoModel: VideoModel?)
    func didClickShare(videoView: PlayViewController, videoModel: VideoModel?)
    func didScrollIsCritical(videoView: PlayViewController, isCritical: Bool)
    func didPanWithDistance(videoView: PlayViewController, distance: CGFloat, isEnd: Bool)

}
class PlayViewController: BaseViewController,JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }

    weak var delegate: PlayViewControllerDelegate?
    var dataArray = [VideoModel]()
    var index: Int = 0 //控制播放的索引，不完全等于当前播放内容的索引
    public var currentPlayIndex: Int = 0//当前播放内容的索引
    var vc = UIViewController()
    var isPushed: Bool = false//是否是push过来的
    var isRefreshMore: Bool = true//是否有下一页
    var currentPlayId: String?//记录播放内容
    var isPlaying_beforeScroll: Bool = false//记录滑动前的播放状态
    var interacting: Bool = false
    var startLocationY: CGFloat = 0//开始移动时的位置
    var startLocation: CGPoint = .zero
    var startFrame: CGRect = .zero
    var currentPlayView = VideoControlView()//当前播放内容的视图

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addSubview(self.topView)
        scrollView.addSubview(self.ctrView)
        scrollView.addSubview(self.btmView)
        scrollView.contentSize = CGSize(width: 0, height: ScreenH * 3)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return scrollView
    }()
    //顶部视图
    lazy var topView: VideoControlView = {
        let topView = VideoControlView()
        topView.isHidden = true
        return topView
    }()
    //中间视图
    lazy var ctrView: VideoControlView = {
        let ctrView = VideoControlView()
        ctrView.isHidden = true
        return ctrView
    }()
    //底部视图
    lazy var btmView: VideoControlView = {
        let btmView = VideoControlView()
        btmView.isHidden = true
        return btmView
    }()
    lazy var backBtn: UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "btn_back_white"), for: .normal)
        return backBtn
    }()
    //播放器
    lazy var player: VideoPlayer = {
        let player = VideoPlayer()
        player.delegate = self
        return player
    }()
    //滑动手势
    lazy var panGesture: PanGestureRecognizer = {
        let panGesture = PanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        panGesture.direction = .Vertical
        return panGesture
    }()
    lazy var doubleLikeView: DoubleLikeView = {
        let doubleLikeView = DoubleLikeView()
        return doubleLikeView
    }()
    @objc func handlePanGesture(panGesture: PanGestureRecognizer) {
        if currentPlayIndex == 0 {
            let location = panGesture.location(in: panGesture.view)
            switch panGesture.state {
            case .began:
                startLocationY = location.y
            case .changed:
                if panGesture.direction == .Vertical {
                    //这里取整是解决上滑时可能出现的distance > 0 的情况
                    let distance = ceil(location.y) - ceil(startLocationY)
                    if distance > 0 {//只要distance>0且没松手，就认为是下滑
                        scrollView.panGestureRecognizer.isEnabled = false
                    }
                    if scrollView.panGestureRecognizer.isEnabled == false {
                        if delegate != nil {
                            delegate?.didPanWithDistance(videoView: self, distance: distance, isEnd: false)
                        }
                    }
                }
            case .failed: break
            case .cancelled: break
            case .ended:
                if scrollView.panGestureRecognizer.isEnabled == false {
                    let distance = location.y - startLocationY
                    if delegate != nil {
                        delegate?.didPanWithDistance(videoView: self, distance: distance, isEnd: true)
                    }
                    scrollView.panGestureRecognizer.isEnabled = true
                }
            default:
                break
            }
            panGesture.setTranslation(.zero, in: panGesture.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        let controlW = scrollView.frame.size.width
        let controlH = scrollView.frame.size.height


        topView.frame = CGRect(x: 0, y: 0, width: controlW, height: controlH)
        ctrView.frame = CGRect(x: 0, y: controlH, width: controlW, height: controlH)
        btmView.frame = CGRect(x: 0, y: 2 * controlH, width: controlW, height: controlH)

        if isPushed == false {
            self.scrollView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
                if self?.isRefreshMore == true {return}
                self?.isRefreshMore = true
                self?.player.pausePlay()
                //当播放索引为最后一个的时候才触发下拉刷新
                self?.currentPlayIndex = self?.dataArray.count ?? 0 - 1
                self?.viewModel.refreshMoreList(success: { (array) in
                    self?.isRefreshMore = false
                    if array.count > 0 {
                        self?.setModel(models: array, index: 0)
                    } else {
                        self?.resetModels(models: array)
                    }
                    self?.scrollView.mj_footer?.endRefreshing();
                    self?.scrollView.contentOffset = CGPoint(x: 0, y: 2 * ScreenH)

                }, failure: { (error) in
                    self?.isRefreshMore = false
                    self?.scrollView.mj_footer?.endRefreshing()
                })
            })
            self.scrollView.addGestureRecognizer(self.panGesture)
        } else {
            self.view.addSubview(self.backBtn)
            self.backBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(NaviBarH + 20)
                make.width.height.equalTo(44)
            }
        }


    }

    lazy var viewModel: VideoViewModel = {
        let viewModel = VideoViewModel()
        return viewModel
    }()

    func setModel(models: [VideoModel], index: Int) {
        self.dataArray.removeAll()
        self.dataArray.append(contentsOf: models)
        self.index = index
        self.currentPlayIndex = index
        if models.count == 0 {
            return
        }
        if models.count == 1 {
            self.ctrView.removeFromSuperview()
            self.btmView.removeFromSuperview()
            self.scrollView.contentSize = CGSize(width: 0, height: ScreenH)
            self.topView.isHidden = false
            self.topView.model = self.dataArray.first
            //在topview上播放
            playVideo(fromView: topView)
        } else if models.count == 2 {
            btmView.removeFromSuperview()
            scrollView.contentSize = CGSize(width: 0, height: ScreenH * 2)
            topView.isHidden = false
            ctrView.isHidden = false
            topView.model = dataArray.first
            ctrView.model = dataArray.last
            if index == 1 {
                scrollView.contentOffset = CGPoint(x: 0, y: ScreenH)
                playVideo(fromView: ctrView)
            } else {
                playVideo(fromView: topView)
            }
        } else {
            topView.isHidden = false
            ctrView.isHidden = false
            btmView.isHidden = false
            if index == 0 {//如果是第一个，则显示上视图，预加载中下视图
                topView.model = dataArray[index]
                ctrView.model = dataArray[index + 1]
                btmView.model = dataArray[index + 2]
                playVideo(fromView: topView)
            } else if index == dataArray.count - 1 {//如果是最后一个，则显示最后一个，预加载前两个
                btmView.model = dataArray[index]
                ctrView.model = dataArray[index - 1]
                topView.model = dataArray[index - 2]
                //显示最后一个
                scrollView.contentOffset = CGPoint(x: 0, y: ScreenH * 2)
                //播放最后一个
                playVideo(fromView: btmView)
            } else {//显示中间的，预加载上下
                ctrView.model = dataArray[index]
                topView.model = dataArray[index - 1]
                btmView.model = dataArray[index + 1]
                //显示中间
                scrollView.contentOffset = CGPoint(x: 0, y: ScreenH)
                //播放中间
                playVideo(fromView: ctrView)
            }
        }
    }

    func resetModels(models: [VideoModel]) {
        dataArray.append(contentsOf: models)
    }
    //暂停播放
    public func pause() {
        if player.isPlaying == true {
            self.isPlaying_beforeScroll = true
        } else {
            self.isPlaying_beforeScroll = false
        }
        player.pausePlay()
    }
    // 恢复播放
    public func resume() {
        if self.isPlaying_beforeScroll {
            self.player.resumePlay()
        }
    }
    //移除播放
    public func destoryPlayer() {
        scrollView.delegate = nil
        player.removeVideo()
    }
    private func playVideo(fromView: VideoControlView) {
        //先移除原来的播放
        player.removeVideo()
        //取消原来视图的代理
        currentPlayView.delegate = nil
        //切换播放视图
        currentPlayId = fromView.model?.post_id
        currentPlayView = fromView
        currentPlayIndex = indexOfModel(model: fromView.model)
        //设置新视图的代理
        currentPlayView.delegate = self
        //重新播放
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.player.playVideo(view: fromView.coverImgView, url: fromView.model?.video_url ?? "")
        }
    }

    //获取当前播放内容的索引
    private func indexOfModel(model: VideoModel?) -> Int {
        var currentIndex = 0
        for (index,item) in dataArray.enumerated() {
            if item.post_id == model?.post_id {
                currentIndex = index
            }
        }
        return currentIndex
    }

    func refreshMore() {
        if isRefreshMore {
            return
        }
        isRefreshMore = true
        viewModel.refreshMoreList(success: {[weak self] (array) in

            if array.count > 0 {
                self?.dataArray.append(contentsOf: array)
                self?.scrollView.mj_footer?.endRefreshing()
            } else {
                self?.scrollView.mj_footer?.endRefreshingWithNoMoreData()
            }
            if self?.scrollView.contentOffset.y ?? 0 > 2 * ScreenH {
                self?.scrollView.contentOffset = CGPoint(x: 0, y: 2 * ScreenH)
            }
        }) { (error) in
            self.isRefreshMore = false
            self.scrollView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
}

extension PlayViewController: VideoPlayerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,VideoControlViewDelegate {
    func controlViewDidClickSelf(controlView: VideoControlView) {
        if player.isPlaying {
            player.pausePlay()
        } else {
            player.resumePlay()
        }
    }

    func controlViewDidClickIcon(controlView: VideoControlView) {
        if delegate != nil {
            delegate?.didClickIcon(videoView: self, videoModel: controlView.model)
        }
    }

    func controlViewDidClickPriase(controlView: VideoControlView) {
        if delegate != nil {
            delegate?.didClickPraise(videoView: self, videoModel: controlView.model)
        }
    }

    func controlViewDidClickComment(controlView: VideoControlView) {
        if delegate != nil {
            delegate?.didClickComment(videoView: self, videoModel: controlView.model)
        }
    }

    func controlViewDidClickShare(controlView: VideoControlView) {
        if delegate != nil {
            delegate?.didClickShare(videoView: self, videoModel: controlView.model)
        }
    }

    func controlView(controlView: VideoControlView, touches: Set<UITouch>, event: UIEvent?) {
        doubleLikeView.createAnimation(touches: touches, event: event)
        controlView.showLikeAnimation()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentPlayIndex == 0 && scrollView.contentOffset.y < 0 {
            self.scrollView.contentOffset = .zero
        }
        //slider
        if scrollView.contentOffset.y == 0 || scrollView.contentOffset.y == ScreenH || scrollView.contentOffset.y == ScreenH * 2 {
            if delegate != nil {
                delegate?.didScrollIsCritical(videoView: self, isCritical: true)
            }
        } else {
            if delegate != nil {
                delegate?.didScrollIsCritical(videoView: self, isCritical: false)
            }
        }
        //小于等于三个不处理
        if dataArray.count < 3 {
            return
        }
        //上滑到第一个
        if index == 0 && scrollView.contentOffset.y <= ScreenH {
            return
        }
        //下滑到最后一个
        if index > 0 && index == dataArray.count - 1 && scrollView.contentOffset.y > ScreenH {
            return
        }
        //判读是从中间视图上滑还是下滑
        if scrollView.contentOffset.y >= 2 * ScreenH {//上滑
            player.removeVideo()//在这里移除播放，解决闪动的bug
            if index == 0 {
                index += 2
                scrollView.contentOffset = CGPoint(x: 0, y: ScreenH)
                topView.model = ctrView.model
                ctrView.model = btmView.model
            } else {
                index += 1
                if index == dataArray.count - 1 {
                    ctrView.model = dataArray[index - 1]
                } else {
                    scrollView.contentOffset = CGPoint(x: 0, y: ScreenH)
                    topView.model = ctrView.model
                    ctrView.model = btmView.model
                }
            }
            if index < dataArray.count - 1 && dataArray.count > 3 {
                btmView.model = dataArray[index + 1]
            }
        } else if scrollView.contentOffset.y <= 0 {//下滑
            player.removeVideo()//在这里移除播放，解决闪动的bug
            if index == 1 {
                topView.model = dataArray[index - 1]
                ctrView.model = dataArray[index]
                btmView.model = dataArray[index + 1]
                index -= 1
            } else {
                if index == dataArray.count - 1 {
                    index -= 2
                } else {
                    index -= 1
                }
                scrollView.contentOffset = CGPoint(x: 0, y: ScreenH)
                btmView.model = ctrView.model
                ctrView.model = topView.model
                if index > 0 {
                    topView.model = dataArray[index - 1]
                }
            }
        }
        if isPushed == true {
            return
        }
        //自动刷新
        if scrollView.contentOffset.y == ScreenH {
            //播放到倒数第二个时，请求更多
            if currentPlayIndex == dataArray.count - 3 {
                refreshMore()
            }
        }
        if scrollView.contentOffset.y == 2 * ScreenH {
            refreshMore()
        }
    }
    //结束滚动后开始播放
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            if currentPlayId == topView.model?.post_id {
                return
            }
            playVideo(fromView: topView)
        } else if scrollView.contentOffset.y == ScreenH {
            if currentPlayId == topView.model?.post_id {
                return
            }
            playVideo(fromView: ctrView)
        } else if scrollView.contentOffset.y == 2 * ScreenH {
            if currentPlayId == topView.model?.post_id {
                return
            }
            playVideo(fromView: btmView)
        }
    }
    func playerStatusChange(status: VideoPlayerStatus) {

    }

    func playertimeChange(currentTime: CGFloat, totalTime: CGFloat, progress: CGFloat) {

    }


}
