//
//  ShareManager_UI.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

extension ShareManager {

    static let delegate = ShareManagerUIDelegate()

    public static func show(in view: UIView, scenes: [ShareScene]?) {
        self.scenes = scenes

        let tapGesture = UITapGestureRecognizer(target: delegate, action: #selector(ShareManagerUIDelegate.dismiss(gesture:)))
        tapGesture.delegate = delegate
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addGestureRecognizer(tapGesture)
        view.addSubview(backgroundView)

        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let collectionHeight: CGFloat = 120.0
        let buttonHeight: CGFloat = 50.0
        var safeOffsetY: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            safeOffsetY = view.safeAreaInsets.bottom
        }
        let wrapperHeight = collectionHeight + buttonHeight + safeOffsetY

        let wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.backgroundColor = .white
        backgroundView.addSubview(wrapperView)

        wrapperView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor).isActive = true
        wrapperView.heightAnchor.constraint(equalToConstant: wrapperHeight).isActive = true
        wrapperView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        wrapperView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true

        let offsetY: CGFloat = 23.0
        let itemWidth = view.frame.width / CGFloat(scenes?.count ?? 1)
        let itemHeight = collectionHeight - offsetY * 2.0
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth < 75.0 ? 75.0 : itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = .zero
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = delegate
        collectionView.delegate = delegate
        collectionView.register(ShareSceneCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ShareSceneCollectionViewCell.self))
        wrapperView.addSubview(collectionView)

        collectionView.widthAnchor.constraint(equalTo: wrapperView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: wrapperView.topAnchor).isActive = true

        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
        wrapperView.addSubview(lineView)

        lineView.widthAnchor.constraint(equalTo: wrapperView.widthAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setAttributedTitle(NSAttributedString(string: "关闭", attributes: [.font : UIFont.systemFont(ofSize: 16.0), .foregroundColor : UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)]), for: .normal)
        wrapperView.addSubview(button)

        button.widthAnchor.constraint(equalTo: wrapperView.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 49.5).isActive = true
        button.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: lineView.bottomAnchor).isActive = true

        collectionView.reloadData()

        UIView.animate(withDuration: 0.25) {
            backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            wrapperView.transform = wrapperView.transform.translatedBy(x: 0.0, y: -wrapperHeight)
        }
    }

}
