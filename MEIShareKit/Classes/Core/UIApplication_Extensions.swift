//
//  UIApplication_Extensions.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

extension UIApplication {

    var displayName: String? {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }

    var bundleID: String? {
        return Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String
    }
}
