//
//  ShareManagerUIDelegate.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

class ShareManagerUIDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    @objc func dismiss(gesture: UITapGestureRecognizer) {
        if let view = gesture.view {
            UIView.animate(withDuration: 0.25, animations: {
                view.backgroundColor = .clear
                view.subviews.first?.transform = .identity
            }) {
                if $0 {
                    view.removeFromSuperview()
                }
            }
        }
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let view = gestureRecognizer.view, let wrapperView = view.subviews.first,
            let collectionView = wrapperView.subviews.first {
            let point = view.convert(gestureRecognizer.location(in: view), to: collectionView)
            if collectionView.layer.contains(point) {
                return false
            }
            return true
        }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShareManager.scenes?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ShareSceneCollectionViewCell.self), for: indexPath) as! ShareSceneCollectionViewCell

        if let scene = ShareManager.scenes?[indexPath.item] {
            cell.setup(with: scene)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let view = collectionView.superview?.superview {
            UIView.animate(withDuration: 0.25, animations: {
                view.backgroundColor = .clear
                collectionView.superview?.transform = .identity
            }) {
                if $0 {
                    view.removeFromSuperview()
                }
            }
        }

        guard let scene = ShareManager.scenes?[indexPath.item] else { return }

        if let item = ShareManager.item {
            ShareManager.share(item, on: scene.platform, ShareManager.result)
        }
    }

}
