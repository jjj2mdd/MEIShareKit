//
//  UIPasteboard_Extensions.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

enum EncodingType {
    case KeyedArchiver
    case PropertyListSerialization
}

extension UIPasteboard {

    static func setDictionary(_ dictionary: Dictionary<String, Any>, forKey key: String, encoding: EncodingType) {
        if !dictionary.isEmpty, !key.isEmpty {
            var data: Data?

            switch encoding {
            case .KeyedArchiver:
                data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            case .PropertyListSerialization:
                do {
                    data = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .binary, options: 0)
                } catch let error {
                    print("序列化失败: \(error.localizedDescription)")
                }
            }

            if let data = data {
                general.setData(data, forPasteboardType: key)
            }
        }
    }

    static func dictionary(forKey key: String, encoding: EncodingType) -> Dictionary<String, Any> {
        var dictionary: Dictionary<String, Any> = [:]

        guard let data = general.data(forPasteboardType: key) else {
            return dictionary
        }

        switch encoding {
        case .KeyedArchiver:
            dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! Dictionary<String, Any>
        case .PropertyListSerialization:
            do {
                dictionary = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as! Dictionary<String, Any>
            } catch let error {
                print("反序列化失败: \(error.localizedDescription)")
            }
        }

        return dictionary
    }

    static func parseWeChat() -> Dictionary<String, Any> {
        var plist: Dictionary<String, Any> = dictionary(forKey: "content", encoding: .PropertyListSerialization)

        guard let key = ShareManager.keys[SharePlatform.WeChat(scene: nil).stringValue]?["key"],
            let dictionary = plist[key] else {
                return [:]
        }

        return dictionary as! Dictionary<String, Any>
    }

    static func parseWeibo() -> Dictionary<String, Int> {
        var result: Dictionary<String, Int> = [:]

        _ = general.items.map { item in
            item.map({ key, value in
                if key == "transferObject" {
                    guard let transferObject = NSKeyedUnarchiver.unarchiveObject(with: value as! Data) as? [String: Any] else {
                        return
                    }

                    if let clz = transferObject["__class"] as? String, clz == "WBSendMessageToWeiboResponse",
                        let statusCode = transferObject["statusCode"] as? Int {
                        result = ["statusCode": statusCode]
                    }
                }
            })
        }

        return result
    }

}
