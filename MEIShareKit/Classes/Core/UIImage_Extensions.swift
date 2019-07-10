//
//  UIImage_Extensions.swift
//  MEIShareKit
//
//  Created by maochaolong041 on 2019/4/18.
//  Copyright (c) 2019 maochaolong041. All rights reserved.
//

import Foundation

extension UIImage {

    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = compressedData(quality: quality) else { return nil }
        return UIImage(data: data)
    }

    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return jpegData(compressionQuality: quality)
    }

    func compressedDataFit(to byteSize: Int) -> Data? {
        guard let imgData = jpegData(compressionQuality: 1.0) else {
            return nil
        }

        guard byteSize < imgData.count else {
            return imgData
        }

        return jpegData(compressionQuality: CGFloat(byteSize) / CGFloat(imgData.count))
    }

    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func scaledFit(to: CGFloat, opaque: Bool = false) -> UIImage? {
        guard to < min(size.width, size.height) else { return self }

        if size.width >= size.height {
            return scaled(toWidth: to, opaque: opaque)
        } else {
            return scaled(toHeight: to, opaque: opaque)
        }
    }

}
