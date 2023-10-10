//
//  myImageDownloader.swift
//
//  Created by Elluminati on 17/01/17.
//  Copyright © 2017 tag. All rights reserved.
//
import UIKit

extension UIImageView {
    static let cacheData = NSCache<AnyObject, AnyObject>()
    func downloadedFrom(link: String, placeHolder:String = "placeholder",
                        isFromCache:Bool = true,
                        isIndicator:Bool = true,
                        isAppendBaseUrl:Bool = true) {
        
        let placeHolderImage = UIImage.init(named: placeHolder);
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.clipsToBounds = true;
        self.image=placeHolderImage;
        var strlink = ""
        
        if isAppendBaseUrl {
            strlink =  WebService.BASE_URL_ASSETS +  link
        }else {
            strlink = link
        }
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
                guard let url = URL(string: strlink) else {
                    activityIndicator.stopAnimating()
                    return
                }
                if isIndicator {
                    activityIndicator.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
                    activityIndicator.color = UIColor.white
                    self.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                }
                if isFromCache {
                    if let cachedImage = UIImageView.cacheData.object(forKey: url as AnyObject) as? UIImage {
        
                        if isIndicator
                        {
                            activityIndicator.stopAnimating()
                        }
                        self.image = cachedImage
                    }else {
                        self.image = placeHolderImage
                        let urlStr = strlink
                        let url = URL(string: urlStr)
                        
                        let request: URLRequest = URLRequest(url: url!)
                        
                    
                        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                            
                        if error != nil
                        {
                            print(error!)
                            activityIndicator.stopAnimating()
                            return
                        }
                            DispatchQueue.main.async(execute: { () -> Void in
                                let image = UIImage(data: data!)
                                if isIndicator
                                {
                                    activityIndicator.stopAnimating()
                                    activityIndicator.removeFromSuperview();
                                }
                                if (image != nil)
                                {
                                self.image = image
        
                                UIImageView.cacheData.setObject(image!, forKey: url as AnyObject)
                                }
        
                            })
        
        
                    }).resume()
                    }
        
                }else {
                self.image=placeHolderImage;
                    let urlStr = strlink
                    let url = URL(string: urlStr)
                    
                    var request: URLRequest = URLRequest(url: url!)
                    
                    request.setValue("xyz", forHTTPHeaderField:"DeviceId")
                    
                    

                    
                    
                    URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                        
                        if error != nil
                        {
                            print(error!)
                            activityIndicator.stopAnimating()
                            return
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            let image = UIImage(data: data!)
                            if isIndicator
                            {
                                activityIndicator.stopAnimating()
                                activityIndicator.removeFromSuperview();
                            }
                            if (image != nil)
                            {
                                self.image = image
                                
                                UIImageView.cacheData.setObject(image!, forKey: url as AnyObject)
                            }
                            
                        })
                        
                        
                    }).resume()}
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
    
}
