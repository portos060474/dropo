//
//  myImageDownloader.swift
//  tableViewDemo
//
//  Created by Elluminati on 17/01/17.
//  Copyright © 2017 tag. All rights reserved.
//
import UIKit
import  ImageIO
import SDWebImage

extension UIImageView {
    //Image Ratio changes
    func downloadedFrom(link: String,
                        placeHolder:String = "placeholder",
                        isFromCache:Bool = true,
                        isIndicator:Bool = true,
                        mode:UIView.ContentMode = .scaleAspectFill,isAppendBaseUrl:Bool = true,isFromResize:Bool = false, completion: ((Bool) -> Void)? = nil) {

        self.contentMode = mode
        self.clipsToBounds = true
        let placeHolderImage = UIImage.init(named: placeHolder)
        self.image=placeHolderImage

        if link.isEmpty() {
            completion?(false)
            return
        }

        else {
            var strlink = ""

            if isFromResize{
                if isAppendBaseUrl {
                    strlink =  WebService.BASE_URL +  link
                }else {
                    strlink = link
                }
            }else{
                if isAppendBaseUrl {
                    strlink =  WebService.BASE_URL_ASSETS +  link
                }else {
                    strlink = link
                }
            }
            guard let url = URL(string: strlink) else {
                completion?(false)
                return
            }
            if isIndicator {
                self.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.sd_imageIndicator?.startAnimatingIndicator()
            }

            if isFromCache {

                self.sd_setImage(with: url, placeholderImage:placeHolderImage, completed: { (image, error, cacheType, url) -> Void in
                    if ((error) != nil) {
                        completion?(false)
                        if isIndicator
                        {
                            self.sd_imageIndicator?.stopAnimatingIndicator()
                        }
                    } else {
                        self.image = image
                        self.isHidden = false
                        if isIndicator
                        {
                            self.sd_imageIndicator?.stopAnimatingIndicator()
                        }
                        completion?(true)
                    }
                })
            }else {
                let urlStr = strlink
                let url = URL(string: urlStr)
                var request: URLRequest = URLRequest(url: url!)
                request.setValue("xyz", forHTTPHeaderField:"DeviceId")

                SDWebImageManager.shared.imageLoader.requestImage(with: url, options: .refreshCached, context: nil, progress: nil) { (image, data, error, result) in
                    if ((error) != nil) {
                        completion?(false)
                        if isIndicator
                        {
                            self.sd_imageIndicator?.stopAnimatingIndicator()
                        }
                    }
                    else
                    {
                        
                        if isIndicator
                        {
                            self.sd_imageIndicator?.stopAnimatingIndicator()
                        }
                        if let downloadImage = image
                        {
                            self.image = downloadImage
                            self.isHidden = false
                            completion?(true)
                        } else {
                            completion?(false)
                        }
                    }
                }
            }
        }
    }
    func downloadOriginalImageFromUrl(strlink:String,isIndicator:Bool,isFromCache:Bool,placeHolderImage:UIImage){
        
        guard let url = URL(string: strlink) else {
            return
        }
        if isIndicator {

            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_imageIndicator?.startAnimatingIndicator()

        }
        if isFromCache {

            self.sd_setImage(with: url, placeholderImage:placeHolderImage, completed: { (image, error, cacheType, url) -> Void in
                if ((error) != nil) {
                    if isIndicator
                    {
                        self.sd_imageIndicator?.stopAnimatingIndicator()
                    }

                } else {
                    DispatchQueue.main.async {
                        self.image = image
                        self.isHidden = false
                    }
                    if isIndicator
                    {
                        self.sd_imageIndicator?.stopAnimatingIndicator()
                    }
                }
            })
        }else {
            let urlStr = strlink
            let url = URL(string: urlStr)
            var request: URLRequest = URLRequest(url: url!)
            request.setValue("xyz", forHTTPHeaderField:"DeviceId")
            SDWebImageManager.shared.imageLoader.requestImage(with: url, options: .refreshCached, context: nil, progress: nil) { (image, data, error, result) in
                if ((error) != nil) {
                    if isIndicator
                    {
                        self.sd_imageIndicator?.stopAnimatingIndicator()
                    }
                }
                else
                {
                    if isIndicator
                    {
                        self.sd_imageIndicator?.stopAnimatingIndicator()
                    }
                    if let downloadImage = image
                    {
                        DispatchQueue.main.async {
                            self.image = downloadImage
                            self.isHidden = false
                        }
                    }
                }
            }
        }
    }
}

extension UIImage {
    func jd_imageAspectScaled(toFit size: CGSize) -> UIImage {
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.width / self.size.width
        } else {
            resizeFactor = size.height / self.size.height
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    func getAspectRation() -> CGFloat {
        let size = self.size
        let height  = size.height
        let width = size.width
        return width/height
    }
}
