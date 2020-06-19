//
//  VideoItemButton.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/13.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

class VideoItemButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()

        self.imageView?.sizeToFit()
        self.titleLabel?.sizeToFit()
        let width = frame.size.width
        let height = frame.size.height
        let imgW = imageView?.frame.size.width ?? 0
        let imaH = imageView?.frame.size.height ?? 0
        imageView?.frame = CGRect(x: (width - imaH) / 2, y: 0, width: imgW, height: imaH)
        let titleW = titleLabel?.frame.size.width ?? 0
        let titleH = titleLabel?.frame.size.height ?? 0
        titleLabel?.frame = CGRect(x: (width - titleW) / 2, y: height - titleH, width: titleW, height: titleH)

    }

}
