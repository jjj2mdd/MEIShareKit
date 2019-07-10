//
//  ShareAsset.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

/// 分享平台
///
/// - QQ: QQ
/// - WeChat: 微信
/// - Weibo: 新浪微博
public enum SharePlatform {
    case QQ(scene: QQScene?)
    case WeChat(scene: WeChatScene?)
    case Weibo

    /// QQ场景
    ///
    /// - Friends: 好友
    /// - QZone: QQ空间
    public enum QQScene: UInt {
        case Friends = 0
        case QZone   = 1
    }

    /// 微信场景
    ///
    /// - Session: 会话
    /// - Timeline: 朋友圈
    public enum WeChatScene: UInt {
        case Session  = 0
        case Timeline = 1
    }

    var stringValue: String {
        switch self {
        case .QQ(_):
            return "QQ"
        case .WeChat(_):
            return "WeChat"
        case .Weibo:
            return "Weibo"
        }
    }

    var scheme: String {
        switch self {
        case .QQ(_):
            return "mqqapi"
        case .WeChat(_):
            return "weixin"
        case .Weibo:
            return "weibosdk"
        }
    }

}

/// 媒体类型
///
/// - News: 新闻
/// - Audio: 音频
/// - Video: 视频
/// - App: 应用
/// - Applet: 小程序
/// - File: 文件
/// - Undefined: 未知
public enum MultimediaType {
    case News
    case Audio
    case Video
    case App
    case Applet
    case File
    case Undefined
}

/// 小程序类型
///
/// - Release: 线上版
/// - Test: 测试版
/// - Preview: 预览版
public enum AppletType: UInt {
    case Release = 0
    case Test    = 1
    case Preview = 2
}

/// 分享内容
public struct ShareItem {

    /// 标题
    public var title: String?

    /// 描述
    public var desc: String?

    /// 图片
    public var image: UIImage?

    /// 缩略图
    public var thumbnail: UIImage?

    /// 链接
    public var link: String?

    /// 媒体类型
    public var multimediaType: MultimediaType = .Undefined

    // MARK: 微信

    /// 扩展信息
    public var extInfo: String?

    /// 媒体URL
    public var mediaDataURL: String?

    /// 文件扩展
    public var fileExt: String?

    /// 文件、GIF
    public var file: Data?

    // MARK: 小程序

    /// 页面路径
    public var path: String?

    /// 转发信息
    public var shareTicket: Bool = true

    /// 小程序类型
    public var appletType: AppletType = .Release

    public init() {}

}

/// 分享菜单项
public struct ShareScene {

    /// 图片
    public var image: UIImage?

    /// 文案
    public var title: String?

    /// 分享平台
    public var platform: SharePlatform = .Weibo

    public init(image: UIImage?, title: String?, platform: SharePlatform) {
        self.image = image
        self.title = title
        self.platform = platform
    }

}
