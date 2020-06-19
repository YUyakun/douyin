//
//  VideoPlayer.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/12.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit
import TXLiteAVSDK_Player

enum VideoPlayerStatus {
    case unload //未加载
    case prepared //准备播放
    case loading //加载中
    case playing //正在播放
    case paused //暂停
    case ended //播放结束
    case error //播放错误
}
protocol VideoPlayerDelegate: NSObjectProtocol {
    func playerStatusChange(status: VideoPlayerStatus)
    func playertimeChange(currentTime: CGFloat, totalTime: CGFloat, progress: CGFloat)
}
class VideoPlayer: NSObject, TXVodPlayListener {

    weak var delegate: VideoPlayerDelegate?
    // 播放状态
    var status: VideoPlayerStatus = .unload
    var isPlaying: Bool = false {//是否正在播放
        didSet {
            player.isPlaying()
        }
    }
    var duration: CGFloat = 0
    //是否正在播放

    func onPlayEvent(_ player: TXVodPlayer!, event EvtID: Int32, withParam param: [AnyHashable : Any]!) {
        switch EvtID {
        case 2009://视频分辨率改变
            let width = param["EVT_PARAM1"] as! CGFloat
            let height = param["EVT_PARAM2"] as! CGFloat
            if width > height {
                player.setRenderMode(.RENDER_MODE_FILL_EDGE)
            } else {
                player.setRenderMode(.RENDER_MODE_FILL_SCREEN)
            }

        case 2007://loading
            if status == .paused {
                playerStatusChanged(status: VideoPlayerStatus.paused)
            } else {
                playerStatusChanged(status: VideoPlayerStatus.loading)
            }
        case 2004://开始播放
            playerStatusChanged(status: VideoPlayerStatus.playing)
        case 2006://播放结束
            if delegate != nil {
                delegate?.playertimeChange(currentTime: duration, totalTime: duration, progress: 1.0)
            }
            playerStatusChanged(status: VideoPlayerStatus.ended)
        case -2301: //失败，多次重连无效
            playerStatusChanged(status: VideoPlayerStatus.error)
        case 2005: //播放进度
            if status == .playing {
                duration = param["EVT_PLAY_DURATION"] as! CGFloat
                let currTime:CGFloat = param["EVT_PLAY_PROGRESS"] as! CGFloat
                let progress = duration == 0 ? 0 : currTime / duration
                if delegate != nil {
                    delegate?.playertimeChange(currentTime: currTime, totalTime: duration, progress: progress)
                }
            }
        default:
            break
        }
    }

    func onNetStatus(_ player: TXVodPlayer!, withParam param: [AnyHashable : Any]!) {

    }


    //MARK: 在指定试图上播放
    public func playVideo(view: UIView, url: String)  {
        //设置播放试图
        player.setupVideoWidget(view, insert: 0)
        //准备播放
        playerStatusChanged(status: VideoPlayerStatus.prepared)
        //开始播放
        if player.startPlay(url) == 0 {
            // 缓冲试图
        } else {
            playerStatusChanged(status: VideoPlayerStatus.error)
        }
    }
    //移除播放试图
    public func removeVideo() {
        //先停止播放
        player.stopPlay()
        //在移除播放试图
        player.removeVideoWidget()
        //改变状态
        playerStatusChanged(status: VideoPlayerStatus.unload)
    }
    //暂停播放
    public func pausePlay() {
        player.pause()
        playerStatusChanged(status: VideoPlayerStatus.paused)
    }
    // 恢复播放
    public func resumePlay() {
        if status == .paused {
            player.resume()
            playerStatusChanged(status: VideoPlayerStatus.playing)
        }
    }
    //重新播放
    public func resetPlay() {
        player.resume()
        playerStatusChanged(status: VideoPlayerStatus.playing)
    }

    private func playerStatusChanged(status: VideoPlayerStatus) {
        self.status = status
        if delegate != nil {
            delegate?.playerStatusChange(status: status)
        }
    }
    lazy var player: TXVodPlayer = {
        TXLiveBase.setLogLevel(.LOGLEVEL_NULL)
        TXLiveBase.setConsoleEnabled(false)
        let player = TXVodPlayer()
        player.vodDelegate = self
        player.setRenderMode(.RENDER_MODE_FILL_EDGE)
        return player
    }()
}
