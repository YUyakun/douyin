//
//  PlayCollectionViewCell.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/11.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit
import Reusable

class PlayCollectionViewCell: UICollectionViewCell,NibReusable {

    @IBOutlet weak var converImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var describe: UILabel!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentNum: UILabel!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var shareNum: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    var model: VideoModel? {
        didSet {
            let width = Float(model?.video_width ?? "0") ?? 0
            let height = Float(model?.video_height ?? "0") ?? 0
            if width > height {
                converImg.contentMode = .scaleAspectFit
            } else {
                converImg.contentMode = .scaleAspectFill
            }
            converImg.kf.setImage(urlString: model?.thumbnail_url)
            name.text = model?.author?.name_show
            describe.text = model?.title
            icon.kf.setImage(urlString: model?.author?.portrait)
            likeNum.text = model?.agree_num
            commentNum.text = model?.comment_num
            shareNum.text = model?.share_num
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
