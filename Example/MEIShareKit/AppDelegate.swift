//
//  AppDelegate.swift
//  MEIShareKit
//
//  Created by jjj2mdd on 04/23/2019.
//  Copyright (c) 2019 jjj2mdd. All rights reserved.
//

import UIKit
import MEIShareKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ShareManager.register(key: "wx4868b35061f87885", appletKey: "gh_afb25ac019c9", on: .WeChat(scene: nil))
        ShareManager.register(key: "100371282", appletKey: nil, on: .QQ(scene: nil))
        ShareManager.register(key: "568898243", appletKey: nil, on: .Weibo)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ShareManager.handle(url: url)
    }

}

