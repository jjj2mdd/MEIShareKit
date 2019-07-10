//
//  ShareManager.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

/// 分享结果Block
public typealias ResultBlock = (Bool, String) -> ()

private protocol Configurable {

    /// 注册Key
    ///
    /// - Parameters:
    ///   - key: 应用Key
    ///   - appletKey: 小程序Key
    ///   - platform: 分享平台
    static func register(key: String, appletKey: String?, on platform: SharePlatform)

    /// 处理分享平台回调URL
    ///
    /// - Parameter url: 回调URL
    /// - Returns: 处理布尔值
    static func handle(url: URL) -> Bool

}

private protocol Shareable {

    /// 设置分享内容(用于带UI的调用)
    ///
    /// - Parameters:
    ///   - item: 分享内容
    ///   - result: 结果回调
    static func setup(with item: ShareItem, _ result: @escaping ResultBlock)

    /// 分享内容到平台(手动调用, 无UI场景)
    ///
    /// - Parameters:
    ///   - item: 分享内容
    ///   - platform: 分享平台
    ///   - result: 结果回调
    static func share(_ item: ShareItem, on platform: SharePlatform, _ result: @escaping ResultBlock)

}

public struct ShareManager: Configurable, Shareable {

    /// 保存注册的key
    static var keys = ["" : ["" : ""]]

    /// 分享内容
    static var item: ShareItem?

    /// 分享菜单项
    static var scenes: [ShareScene]?

    /// 分享结果回调
    static var result: ResultBlock = {_,_ in }

    public static func register(key: String, appletKey: String?, on platform: SharePlatform) {
        switch platform {
        case .QQ(_):
            ShareManager.keys[platform.stringValue] = ["key" : key, "callback_name" : "QQ\(String(format: "%08llX", UInt64(key) ?? 0))"]
        case .WeChat(_):
            ShareManager.keys[platform.stringValue] = ["key" : key, "appletKey" : appletKey ?? ""]
        case .Weibo:
            ShareManager.keys[platform.stringValue] = ["key" : key, "callback_name" : "wb\(key)"]
        }
    }

    /// 处理客户端返回
    public static func handle(url: URL) -> Bool {
        guard let scheme = url.scheme else { return false }

        let qqCallback = keys[SharePlatform.QQ(scene: nil).stringValue]?["callback_name"] ?? ""
        let wechatCallback = keys[SharePlatform.WeChat(scene: nil).stringValue]?["key"] ?? ""
        let weiboCallback = keys[SharePlatform.Weibo.stringValue]?["callback_name"] ?? ""

        if scheme == qqCallback {
            return handleQQ(url: url)
        } else if scheme == wechatCallback {
            return handleWeChat()
        } else if scheme == weiboCallback {
            return handleWeibo()
        }

        return false
    }

    public static func setup(with item: ShareItem, _ result: @escaping ResultBlock) {
        ShareManager.item = item
        ShareManager.result = result
    }

    public static func share(_ item: ShareItem, on platform: SharePlatform, _ result: @escaping ResultBlock) {
        var url: URL?

        switch platform {
        case .QQ(let scene):
            url = shareToQQ(item, at: scene ?? .Friends)
        case .WeChat(let scene):
            url = shareToWeChat(item, at: scene ?? .Session)
        case .Weibo:
            url = shareToWeibo(item)
        }

        if let url = url {
            ShareManager.item = item
            /// 设置客户端回调
            ShareManager.result = result
            /// 调起客户端
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
