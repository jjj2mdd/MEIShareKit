//
//  URL_Extensions.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

extension URL {

    func parse() -> Dictionary<String, String> {
        var queries: Dictionary<String, String> = [:]
        let components = self.query?.components(separatedBy: "&")

        _ = components?.map {
            if let index = $0.firstIndex(of: "=") {
                let key = String($0[..<index])
                let value = String($0[index...].dropFirst())
                queries[key] = value
            }
        }

        return queries
    }

}
