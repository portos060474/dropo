//
//  AlamofireHelper.swift
//  Store
//
//  Created by Elluminati on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

extension URLSession {
    func cancelTasks(completionHandler: @escaping (() -> Void)) {
        self.getAllTasks { (tasks: [URLSessionTask]) in
            for task in tasks {
                if let url = task.originalRequest?.url?.absoluteString {
                    print("\(#function) \(url) cancel")
                }
                task.cancel()
            }
            
            DispatchQueue.main.async(execute: {
                completionHandler()
            })
        }
    }
}

typealias voidRequestCompletionBlock = (_ response:[String:Any],_ error:Any?) -> (Void)
class AlamofireHelper: NSObject {
    static let POST_METHOD = "POST"
    static let GET_METHOD = "GET"
    static let PUT_METHOD = "PUT"
    var dataBlock:voidRequestCompletionBlock={_,_ in};
    override init() {
        super.init()
    }
    
    func getResponseFromURL(url : String,methodName : String,paramData : Dictionary<String, Any>? , block:@escaping voidRequestCompletionBlock) {
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        
        if (methodName == AlamofireHelper.POST_METHOD) {
            
            /* Changed lang set from preference */
            _ = /*0*/preferenceHelper.getLanguage()
            let header: HTTPHeaders = Utility.getHttpsHeaderForAPI()
            
            print("header: \(String(describing: header)) ")
            
            print("Url : - \(urlString) \n parameters :- \(String(describing: paramData))")
                
            
            AF.request(urlString, method: .post, parameters: paramData, encoding:JSONEncoding.default, headers: header).responseJSON {
                (response:AFDataResponse<Any>) in

                if self.isValidResponse(response: response, url: url) {
                    switch(response.result) {
                    case .success(_):
                        if response.value != nil {
                            print("Url : - \(String(describing: response.request?.urlRequest)) \n parameters :- \(String(describing: paramData)) \n  Response \(String(describing: response.value))")
                            self.dataBlock((response.value as? [String:Any])!,nil)
                        }
                        break
                        
                    case .failure(_):
                        if response.error != nil {
                            let dictResponse:[String:Any] = [:]
                            self.dataBlock(dictResponse,response.error!)
                        }
                        break
                    }
                } else {
                    let dictResponse:[String:Any] = [:]
                    self.dataBlock(dictResponse,response.error!)
                }
            }
        } else if(methodName == AlamofireHelper.GET_METHOD) {
            /* Changed lang set from preference */
            _ = /*0*/preferenceHelper.getLanguage()
            let header: HTTPHeaders = Utility.getHttpsHeaderForAPI()
                
            AF.request(urlString,headers: header).responseJSON(completionHandler: { (response:AFDataResponse<Any>) in
                if self.isValidResponse(response: response, url: url) {
                    switch(response.result) {
                    case .success(_):
                        if response.value != nil {
                            print("Url : - \(String(describing: response.request?.urlRequest)) \n parameters :- \(String(describing: paramData)) \n  Response \(String(describing: response.value))")
                            self.dataBlock((response.value as? [String:Any])!,nil)
                        }
                        break
                    case .failure(_):
                        if response.error != nil {
                            let dictResponse:[String:Any] = [:]
                            self.dataBlock(dictResponse,response.error!)
                        }
                        break
                    }
                } else {
                   let dictResponse:[String:Any] = [:]
                    self.dataBlock(dictResponse,response.error!)
                }
            })
        }
    }
    
    func getResponseFromURL(url : String,paramData : Dictionary<String, Any>? ,image : UIImage!, block:@escaping voidRequestCompletionBlock) {
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        let imgData = image!.jpegData(compressionQuality: 0.2)!
        _ = preferenceHelper.getLanguage()
        let _: HTTPHeaders = Utility.getHttpsHeaderForAPI()
           
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: PARAMS.IMAGE_URL,fileName: "file.jpeg", mimeType: "image/jpg")
            
            for (key, value) in paramData! {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:urlString).responseJSON { (response:AFDataResponse<Any>) in
           
            if self.isValidResponse(response: response, url: url){
                switch response.result {
              
                case .success(_):
                      if (response.value != nil) {
                          self.dataBlock((response.value as? [String:Any])!,nil)
                      }
                case .failure(_):
                    let dictResponse:[String:Any] = [:]
                    self.dataBlock(dictResponse,response.error!)
                }
            }
        }
    }
    
    func getResponseFromURLWithImages(url : String,paramData : Dictionary<String, Any>?,imgParamData : [String],images : [UIImage?], block:@escaping voidRequestCompletionBlock) {
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        
        AF.upload(multipartFormData: { multipartFormData in
                
            for i in 0...images.count-1 {
                let imgData = images[i]!.jpegData(compressionQuality: 1.2)
                multipartFormData.append(imgData!, withName: imgParamData[i],fileName: "File.jpg", mimeType: "image/jpg")
            }
            for (key, value) in paramData! {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            print(multipartFormData)
        },to:urlString).responseJSON { (response:AFDataResponse<Any>) in
           
            if self.isValidResponse(response: response, url: url){
                switch response.result {
              
                case .success(_):
                      if (response.value != nil) {
                          self.dataBlock((response.value as? [String:Any])!,nil)
                      }
                case .failure(_):
                    let dictResponse:[String:Any] = [:]
                    self.dataBlock(dictResponse,response.error!)
                }
            }
        }
    }

    func isValidResponse(response:AFDataResponse<Any>, url:String = "") -> Bool {
        var statusCode = response.response?.statusCode
        if let error = response.error?.asAFError {
            let status = "HTTP_ERROR_CODE_" + String(statusCode ?? 0)
            if url != "api/provider/update_location" {
                Utility.showToast(message: status.localized)
            }
            statusCode = error._code
            Utility.hideLoading()
            return false
        } else {
            return true
        }
    }

}
