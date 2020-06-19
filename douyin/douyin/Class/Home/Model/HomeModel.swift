//
//  HomeModel.swift
//  DouyinApp
//
//  Created by Ai on 2020/6/12.
//  Copyright © 2020 yyk. All rights reserved.
//

import Foundation
import ObjectMapper

class Result: Mappable {
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        logid <- map["logid"]
        error_code <- map["error_code"]
        time <- map["time"]
        server_time <- map["server_time"]
        ctime <- map["ctime"]
        error_msg <- map["error_msg"]
        data <- map["data"]
    }

    var logid: String?
    var error_code: String?
    var time: String?
    var server_time: String?
    var ctime: String?
    var error_msg: String?
    var data: Video?

}
class Video: Mappable {
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        video_list <- map["video_list"]
        has_more <- map["has_more"]
    }

    var video_list: [VideoModel]?
    var has_more: String?
}

class VideoModel: Mappable {
    var first_frame_cover: String?
    var agree_num: String?
    var tags: String?
    var comment_num: String?
    var create_time: String?
    var agreed_num: String?
    var video_length: String?
    var is_deleted: String?
    var video_log_id: String?
    var play_count: String?
    var video_url: String?
    var thumbnail_width: String?
    var is_private: String?
    var thumbnail_url: String?
    var video_duration: String?
    var title: String?
    var thumbnail_height: String?
    var gif_cover: String?
    var thread_id: String?
    var post_id: String?
    var video_height: String?
    var share_num: String?
    var is_agreed: String?
    var video_width: String?
    var video_md5: String?
    var need_hide_title: String?
    var watermark: Watermark?
    var club_info: Clubinfo?
    var author: Author?
    var other: Other?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        first_frame_cover <- map["first_frame_cover"]
        agree_num <- map["agree_num"]
        tags <- map["tags"]
        comment_num <- map["comment_num"]
        create_time <- map["create_time"]
        agreed_num <- map["agreed_num"]
        video_length <- map["video_length"]
        is_deleted <- map["is_deleted"]
        video_log_id <- map["video_log_id"]
        play_count <- map["play_count"]
        video_url <- map["video_url"]
        thumbnail_width <- map["thumbnail_width"]
        is_private <- map["is_private"]
        thumbnail_url <- map["thumbnail_url"]
        video_duration <- map["video_duration"]
        title <- map["title"]
        thumbnail_height <- map["thumbnail_height"]
        share_num <- map["share_num"]
        is_agreed <- map["is_agreed"]
        video_width <- map["video_width"]
        video_height <- map["video_height"]
        is_agreed <- map["is_agreed"]
        video_md5 <- map["video_md5"]
        need_hide_title <- map["need_hide_title"]
        watermark <- map["watermark"]
        club_info <- map["club_info"]
        author <- map["author"]
        other <- map["other"]
    }


}
class Watermark: Mappable {
    var video_url: String?
    var video_width: String?
    var video_height: String?
    var video_length: String?
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        video_url <- map["video_url"]
        video_width <- map["video_width"]
        video_height <- map["video_height"]
        video_length <- map["video_length"]
    }
}
class Clubinfo: Mappable {
    var club_id: String?
    var club_name: String?
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        club_id <- map["club_id"]
        club_name <- map["club_name"]
    }
}
class Author: Mappable {
    var follow_num: String?
    var user_id: String?
    var is_follow: String?
    var intro: String?
    var portrait: String?
    var fans_num: String?
    var name_show: String?
    var gender: String?
    var user_name: String?
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        follow_num <- map["follow_num"]
        user_id <- map["user_id"]
        is_follow <- map["is_follow"]
        intro <- map["intro"]
        portrait <- map["portrait"]
        fans_num <- map["fans_num"]
        name_show <- map["name_show"]
        gender <- map["gender"]
        user_name <- map["user_name"]

    }
}
class Other: Mappable {
    var recom_source: String?
    var recom_extra: String?
    var forum_id: String?
    var recom_weight: String?
    var ab_tag: String?
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        recom_source <- map["recom_source"]
        recom_extra <- map["recom_extra"]
        forum_id <- map["forum_id"]
        recom_weight <- map["recom_weight"]
        ab_tag <- map["ab_tag"]
    }
}
