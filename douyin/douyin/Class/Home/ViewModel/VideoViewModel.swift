//
//  VideoViewModel.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/13.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

typealias successBlock = (_ result: [VideoModel]) -> Void
typealias errorBlock = (_ error: Error) -> Void
class VideoViewModel: NSObject {
    var pn: Int = 1
    public func refreshNewList(success: successBlock, failure: errorBlock) -> Void {
        self.pn = 1
        guard let path = Bundle.main.path(forResource: "video1", ofType: "json") else { return  }
        let jsonData = NSData(contentsOfFile: path)
        print(JSON(jsonData!))
        guard let json = JSON(jsonData as Any).rawString() else { return }

        let model = Mapper<Result>().map(JSONString: json)
        success(model?.data?.video_list ?? [])


    }

    public func refreshMoreList(success: successBlock, failure: errorBlock) -> Void {
        self.pn += 1
        guard let path = Bundle.main.path(forResource: String(format:"video\(self.pn)"), ofType: "json") else { return  }
        let jsonData = NSData(contentsOfFile: path)
        print(JSON(jsonData!))
        guard let json = JSON(jsonData as Any).rawString() else { return }

        let model = Mapper<Result>().map(JSONString: json)
        success(model?.data?.video_list ?? [])
    }
}
