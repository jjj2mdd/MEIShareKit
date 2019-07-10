//
//  ShareManager_QQ.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

extension ShareManager {

    public static func QQInstalled() -> Bool {
        guard let url = URL(string: "\(SharePlatform.QQ(scene: nil).scheme)://") else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }

    static func handleQQ(url: URL) -> Bool {
        let params = url.parse()
        if let error = params["error"], Int(error) != 0 {
            result(false, "分享失败")
        } else {
            result(true, "分享成功")
        }

        return true
    }

    static func shareToQQ(_ item: ShareItem, at scene: SharePlatform.QQScene) -> URL? {
        var shareURL = "\(SharePlatform.QQ(scene: scene).scheme)://share/to_fri?thirdAppDisplayName="
        shareURL.append(UIApplication.shared.displayName?.base64Encoded ?? "")
        shareURL.append("&version=1&cflag=")
        shareURL.append("\(scene.rawValue)")
        shareURL.append("&callback_type=scheme&generalpastboard=1")
        shareURL.append("&callback_name=\(keys[SharePlatform.QQ(scene: scene).stringValue]?["callback_name"] ?? "")")
        shareURL.append("&src_type=app&shareType=0&file_type=")

        /// 纯文本
        if let title = item.title, item.image == nil, item.link == nil {
            shareURL.append("text&file_data=\(title.base64Encoded?.urlEncoded ?? "")")
        } else if let title = item.title, let image = item.image, let desc = item.desc, item.link == nil {
            /// 图片
            let imageData = image.compressedData(quality: 1)
            let thumbnail = item.thumbnail ?? image
            let thumbnailData = thumbnail.scaledFit(to: 36.0)?.compressedData(quality: 1)

            let data = ["file_data" : imageData, "previewimagedata" : thumbnailData]
            UIPasteboard.setDictionary(data as Dictionary<String, Any>, forKey: "com.tencent.mqq.api.apiLargeData", encoding: .KeyedArchiver)

            shareURL.append("img&title=\(title.base64Encoded ?? "")")
            shareURL.append("&objectlocation=pasteboard&description=\(desc.base64Encoded ?? "")")
        } else if let title = item.title, let desc = item.desc,
            let link = item.link {
            /// 新闻、多媒体
            let thumbnail = item.thumbnail ?? item.image
            let thumbnailData = thumbnail?.scaledFit(to: 36.0)?.compressedData(quality: 1)

            let data = ["previewimagedata" : thumbnailData]
            UIPasteboard.setDictionary(data as Dictionary<String, Any>, forKey: "com.tencent.mqq.api.apiLargeData", encoding: .KeyedArchiver)

            let multimediaType = item.multimediaType == .Audio ? "audio" : "news"

            shareURL.append("\(multimediaType)&title=\(title.base64Encoded?.urlEncoded ?? "")")
            shareURL.append("&url=\(link.base64Encoded?.urlEncoded ?? "")")
            shareURL.append("&description=\(desc.base64Encoded?.urlEncoded ?? "")&objectlocation=pasteboard")
        }

        return URL(string: shareURL)
    }
}
