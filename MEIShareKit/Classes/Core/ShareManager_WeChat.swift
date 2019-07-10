//
//  ShareManager_WeChat.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

extension ShareManager {

    public static func WeChatInstalled() -> Bool {
        guard let url = URL(string: "\(SharePlatform.WeChat(scene: nil).scheme)://") else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }

    static func handleWeChat() -> Bool {
        let params = UIPasteboard.parseWeChat()
        if let resultValue = params["result"] as? String, Int(resultValue) == 0 {
            result(true, "分享成功")
        } else {
            result(false, "分享失败")
        }

        return true
    }

    static func shareToWeChat(_ item: ShareItem, at scene: SharePlatform.WeChatScene) -> URL? {
        let key = keys[SharePlatform.WeChat(scene: scene).stringValue]?["key"] ?? ""
        let shareURL = "\(SharePlatform.WeChat(scene: scene).scheme)://app/\(key)/sendreq/?"

        var message: Dictionary<String, Any> = [:]
        message["result"] = "1"
        message["returnFromApp"] = "1"
        message["scene"] = "\(scene.rawValue)"
        message["sdkver"] = "1.5"
        message["command"] = "1010"

        switch item.multimediaType {
        case .Audio: do {/// 音频
            message["description"] = item.desc ?? item.title ?? ""
            message["mediaUrl"] = item.link
            message["mediaDataUrl"] = item.mediaDataURL
            message["objectType"] = "3"
            message["title"] = item.title

            if let thumbnail = item.thumbnail ?? item.image {
                message["thumbData"] = thumbnail.scaledFit(to: 100.0)?.compressedDataFit(to: 0x8000)
            }
            }
        case .Video: do {/// 视频
            message["description"] = item.desc ?? item.title ?? ""
            message["mediaUrl"] = item.link
            message["objectType"] = "4"
            message["title"] = item.title

            if let thumbnail = item.thumbnail ?? item.image {
                message["thumbData"] = thumbnail.scaledFit(to: 100.0)?.compressedDataFit(to: 0x8000)
            }
            }
        case .File: do {/// 文件
            message["description"] = item.desc ?? item.title ?? ""
            message["objectType"] = "6"
            message["title"] = item.title
            message["fileData"] = item.file
            message["fileExt"] = item.fileExt ?? ""

            if let thumbnail = item.thumbnail ?? item.image {
                message["thumbData"] = thumbnail.scaledFit(to: 100.0)?.compressedDataFit(to: 0x8000)
            }
            }
        case .App: do {/// 应用
            message["description"] = item.desc ?? item.title ?? ""
            message["mediaUrl"] = item.link
            message["objectType"] = "7"
            message["title"] = item.title
            message["fileData"] = item.image?.compressedData(quality: 1)

            if let thumbnail = item.thumbnail ?? item.image {
                message["thumbData"] = thumbnail.scaledFit(to: 100.0)?.compressedDataFit(to: 0x8000)
            }
            if let extInfo = item.extInfo {
                message["extInfo"] = extInfo
            }
            }
        case .Applet: do {/// 小程序
            message["withShareTicket"] = item.shareTicket ? 1 : 0
            message["mediaUrl"] = item.link
            message["objectType"] = "36"
            message["title"] = item.title
            message["miniprogramType"] = item.appletType.rawValue
            message["hdThumbData"] = item.image?.compressedData(quality: 1)
            message["appBrandPath"] = item.path
            message["appBrandUserName"] = keys[SharePlatform.WeChat(scene: scene).stringValue]?["appletKey"]

            if let thumbnail = item.thumbnail ?? item.image {
                message["thumbData"] = thumbnail.scaledFit(to: 100.0)?.compressedDataFit(to: 0x8000)
            }
            }
        default: do {
            /// 纯文本
            if let title = item.title, item.image == nil, item.link == nil, item.file == nil {
                message["command"] = "1020"
                message["title"] = title
            } else if let image = item.image, item.link == nil {
                /// 图片
                message["objectType"] = "2"
                message["title"] = item.title
                message["fileData"] = image.compressedData(quality: 1)

                if let thumbnail = item.thumbnail ?? item.image {
                    message["thumbData"] = thumbnail.scaledFit(to: 100.0)?.compressedDataFit(to: 0x8000)
                }
            } else if let title = item.title, let link = item.link {
                /// 新闻
                message["description"] = item.desc ?? title
                message["mediaUrl"] = link
                message["objectType"] = "5"
                message["title"] = item.title

                if let thumbnail = item.thumbnail ?? item.image {
                    message["thumbData"] = thumbnail.scaledFit(to: 100.0)?.compressedDataFit(to: 0x8000)
                }
            } else if let file = item.file, item.link == nil {
                /// GIF
                message["objectType"] = "8"
                message["fileData"] = file

                if let thumbnail = item.thumbnail ?? item.image {
                    message["thumbData"] = thumbnail.scaledFit(to: 100.0)?.compressedDataFit(to: 0x8000)
                }
            }
            }
        }

        UIPasteboard.setDictionary([key : message], forKey: "content", encoding: .PropertyListSerialization)

        return URL(string: shareURL)
    }
}
