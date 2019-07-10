//
//  ViewController.swift
//  MEIShareKit
//
//  Created by jjj2mdd on 04/23/2019.
//  Copyright (c) 2019 jjj2mdd. All rights reserved.
//

import UIKit
import MEIShareKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            let newCell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            newCell.textLabel?.text = items[indexPath.row]
            return newCell
        }

        cell.textLabel?.text = items[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var shareItem = ShareItem()
        shareItem.title = "分享标题"
        shareItem.desc = "分享内容"
        shareItem.link = "https://www.baidu.com"
        shareItem.image  = UIImage(named: "qrcode")

        let result =  { (succeed: Bool, message: String) in
            if succeed {
                print("分享成功")
            } else {
                print("分享失败")
            }
        }

        switch indexPath.row {
        case 0:
            ShareManager.share(shareItem, on: .WeChat(scene: .Session), result)
        case 1:
            ShareManager.share(shareItem, on: .WeChat(scene: .Timeline), result)
        case 2:
            ShareManager.share(shareItem, on: .QQ(scene: .Friends), result)
        case 3:
            ShareManager.share(shareItem, on: .QQ(scene: .QZone), result)
        case 4:
            ShareManager.share(shareItem, on: .Weibo, result)
        default:
            if let view = UIApplication.shared.keyWindow {
                let scenes = [ShareScene(image: UIImage(named: "WeChat"), title: "微信", platform: .WeChat(scene: .Session)),
                              ShareScene(image: UIImage(named: "Timeline"), title: "朋友圈", platform: .WeChat(scene: .Timeline)),
                              ShareScene(image: UIImage(named: "QQ"), title: "QQ", platform:.QQ(scene: .Friends)),
                              ShareScene(image: UIImage(named: "QZone"), title: "QQ空间", platform: .QQ(scene: .QZone)),
                              ShareScene(image: UIImage(named: "Weibo"), title: "微博", platform: .Weibo)]
                ShareManager.setup(with: shareItem, result)
                ShareManager.show(in: view, scenes: scenes)
            }

        }
    }

    private lazy var items = ["分享到微信", "分享到朋友圈", "分享到QQ", "分享到QQ空间", "分享到微博", "调起分享菜单"]

}
