//
//  ShareManager_Weibo.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

extension ShareManager {

    public static func WeiboInstalled() -> Bool {
        guard let url = URL(string: "\(SharePlatform.Weibo.scheme)://request") else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }

    static func handleWeibo() -> Bool {
        let params = UIPasteboard.parseWeibo()
        if let statusCode = params["statusCode"], statusCode == 0 {
            result(true, "分享成功")
        } else {
            result(false, "分享失败")
        }

        return true
    }

    static func shareToWeibo(_ item: ShareItem) -> URL? {
        let uuid = NSUUID().uuidString

        let shareURL = "\(SharePlatform.Weibo.scheme)://request?id=\(uuid)&sdkversion=003013000"

        var message: Dictionary<String, Any> = [:]

        /// 纯文本
        if let title = item.title, item.image == nil, item.link == nil {
            message["__class"] = "WBMessageObject"
            message["text"] = title
        } else if let title = item.title, let image = item.image, item.link == nil {
            /// 图片
            message["__class"] = "WBMessageObject"
            message["text"] = title
            message["imageObject"] = ["imageData" : image.compressedData(quality: 1)]
        } else if let title = item.title, let image = item.image, let link = item.link {
            /// 链接
            let thumbnail = item.thumbnail ?? image
            let thumbnailData = thumbnail.scaledFit(to: 100.0)?.compressedDataFit(to: 0x8000)
            message["__class"] = "WBMessageObject"
            message["mediaObject"] = ["__class" : "WBWebpageObject",
                                     "description" : item.desc ?? title,
                                     "objectID" : "identifier1",
                                     "thumbnailData" : thumbnailData as Any,
                                     "title" : title,
                                     "webpageUrl" : link]
        }

        let items = [["transferObject" : NSKeyedArchiver.archivedData(withRootObject: ["__class" : "WBSendMessageToWeiboRequest", "message" : message, "requestID" : uuid])],
                     ["userInfo" : NSKeyedArchiver.archivedData(withRootObject: [:])],
                     ["app" : NSKeyedArchiver.archivedData(withRootObject: ["appKey": keys[SharePlatform.Weibo.stringValue]?["key"] ?? "", "bundleID": UIApplication.shared.bundleID])]] as [Any]
        UIPasteboard.general.items = items as! [[String : Any]]

        return URL(string: shareURL)
    }

}
