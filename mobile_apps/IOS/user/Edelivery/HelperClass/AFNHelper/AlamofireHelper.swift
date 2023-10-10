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

typealias voidRequestCompletionBlock = (_ response:NSDictionary,_ error:Any?) -> (Void)


class AlamofireHelper: NSObject {
    static let POST_METHOD = "POST"
    static let GET_METHOD = "GET"
    static let PUT_METHOD = "PUT"
    
    var dataBlock:voidRequestCompletionBlock={_,_ in}

    private lazy var alamoFireManager: Session? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.httpAdditionalHeaders = ["lang":preferenceHelper.getSelectedLanguageCode()]
        let alamoFireManager = Alamofire.Session(configuration: configuration)
        return alamoFireManager
    }()

    override init() {
        super.init()
    }

    func getResponseFromURL(url:String, methodName:String, paramData:Dictionary<String, Any>? , block:@escaping voidRequestCompletionBlock) {
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        let languageIndex = preferenceHelper.getSelectedLanguage()
        let header: HTTPHeaders = Utility.getHttpsHeaderForAPI()
        
        print("URL: \(url)")
        print("PARAM: \(String(describing: paramData))")
        
        if (methodName == AlamofireHelper.POST_METHOD) {

            print("url \(Constants.selectedLanguageIndex)")
            print("getResponseFromURL ---- > url \(urlString), lang:\(languageIndex)")
            

            alamoFireManager?.request(urlString, method: .post, parameters: paramData, encoding: JSONEncoding.default ,headers: header).responseJSON { (response:AFDataResponse<Any>) in
                
                if self.isValidResponse(response: response) {
                    if response.value != nil {
                        print(Utility.convertDictToJson(dict: response.value as! Dictionary<String, Any>))
                        switch response.result {
                        case .success(_):
                            if response.value != nil {
                                
                                print("Url : - \(String(describing: response.request?.urlRequest)) \n parameters :- \(String(describing: paramData)) \n  Response \(response.value ?? "")")
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject: (response.value as? NSDictionary)!)
                                    if let json = String(data: jsonData, encoding: .utf8) {
                                        print(json)
                                    }
                                }
                                catch {
                                }
                                self.dataBlock((response.value as? NSDictionary)!,nil)
                            }
                            break
                        case .failure(_):
                            if response.error != nil {
                                let dictResponse:NSDictionary = NSDictionary.init()
                                self.dataBlock(dictResponse, response.error)
                            }
                            break
                        }
                    }
                } else {
                    let dictResponse:NSDictionary = NSDictionary.init()
                    self.dataBlock(dictResponse,response.error!)
                    Utility.hideLoading()
                }
            }
        }else if(methodName == AlamofireHelper.GET_METHOD) {
            alamoFireManager?.request(urlString, headers: header).responseJSON (completionHandler: { (response:AFDataResponse<Any>) in
                
                if self.isValidResponse(response: response) {
                    if response.value != nil {
                        switch response.result {
                        case .success(_):
                            if response.value != nil {
                                self.dataBlock((response.value as? NSDictionary)!,nil)
                            }
                            break
                        case .failure(_):
                            if response.error != nil {
                                let dictResponse:NSDictionary = NSDictionary.init()
                                self.dataBlock(dictResponse,response.error!)
                            }
                            break
                        }
                    } else {
                        print(response)
                    }
                } else {
                    Utility.hideLoading()
                    let dictResponse:NSDictionary = NSDictionary.init()
                    self.dataBlock(dictResponse,response.error!)
                }
            })
        }
    }
    
    
    func getResponseFromStoreURL(langInd:String,url : String,methodName : String,paramData : Dictionary<String, Any>? , block:@escaping voidRequestCompletionBlock) {
            self.dataBlock = block
            let urlString:String = WebService.BASE_URL + url
            let header: HTTPHeaders = Utility.getHttpsHeaderForAPI()
         
        if (methodName == AlamofireHelper.POST_METHOD) {
                
                _ = preferenceHelper.getSelectedLanguage()

                print("getResponseFromStoreURL ---- > url \(url), lang:\(langInd)")
    
                alamoFireManager?.request(urlString, method: .post, parameters: paramData, encoding:JSONEncoding.default, headers: header).responseJSON {
                    (response:AFDataResponse<Any>) in
                    
                    if self.isValidResponse(response: response) {
                        
                        switch response.result {
                        case .success(_):
                            if response.value != nil {
                                
                                print("Url : - \(String(describing: response.request?.urlRequest)) \n parameters :- \(String(describing: paramData)) \n  Response \(response.value ?? "")")
                                self.dataBlock((response.value as? NSDictionary)!,nil)
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject: (response.value as? NSDictionary)!)
                                    if let json = String(data: jsonData, encoding: .utf8) {
                                        print(json)
                                    }
                                }
                                catch {
                                }
                            }
                            break
                            
                        case .failure(_):
                            
                            if response.error != nil {
                                let dictResponse:NSDictionary = NSDictionary.init()
                                self.dataBlock(dictResponse,response.error!)
                            }
                            break
                        }
                    }else {
                        let dictResponse:NSDictionary = NSDictionary.init()
                        self.dataBlock(dictResponse,response.error!)
                        Utility.hideLoading()
                    }
                }
            }else if(methodName == AlamofireHelper.GET_METHOD) {
                alamoFireManager?.request(urlString, headers: Utility.getHttpsHeaderForAPI()).responseJSON(completionHandler: {(response:AFDataResponse<Any>) in
                    
                    if self.isValidResponse(response: response) {
                        switch(response.result) {
                        case .success(_):
                            if response.value != nil {
                                self.dataBlock((response.value as? NSDictionary)!,nil)
                            }
                            break
                        case .failure(_):
                            if response.error != nil {
                                let dictResponse:NSDictionary = NSDictionary.init()
                                self.dataBlock(dictResponse,response.error!)
                            }
                            break
                        }
                    }else {
                        Utility.hideLoading()
                        let dictResponse:NSDictionary = NSDictionary.init()
                        self.dataBlock(dictResponse,response.error!)
                    }
                })
            }
        }
    
    func getResponseFromURL(url : String,paramData : Dictionary<String, Any>? ,image : UIImage!, block:@escaping voidRequestCompletionBlock) {
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        let imgData = image!.jpegData(compressionQuality: 1.0)!
        
    
        alamoFireManager?.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: PARAMS.IMAGE_URL,fileName: "file.jpeg", mimeType: "image/jpg")
            
            for (key, value) in paramData! {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:urlString).responseJSON { (response:AFDataResponse<Any>) in
           
            if self.isValidResponse(response: response) {
                switch response.result {
              
                case .success(_):
                      if (response.value != nil) {
                            self.dataBlock((response.value as? NSDictionary)!,nil)
                      }
                case .failure(let encodingError):
                    let dictResponse:NSDictionary = NSDictionary.init()
                    self.dataBlock(dictResponse,encodingError)
                }
            }
    }
    }
    
    func getResponseFromURL(url : String,paramData : Dictionary<String, Any>? ,images : [UIImage?], block:@escaping voidRequestCompletionBlock) {
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        
        alamoFireManager?.upload(multipartFormData: { multipartFormData in
            for image in images {
                let imgData = image!.jpegData(compressionQuality: 1.0)
                multipartFormData.append(imgData!, withName: PARAMS.IMAGE_URL,fileName: "File.jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in paramData! {
                if let boolValue = value as? Bool {
                    multipartFormData.append(boolValue.description.data(using: .utf8)!, withName: key)
                } else {
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        },to:urlString).responseJSON { (response:AFDataResponse<Any>) in
            switch response.result {
          
            case .success(_):
               
                if self.isValidResponse(response: response){
                        if (response.value != nil) {
                            self.dataBlock((response.value as? NSDictionary)!,nil)
                        }
                }else {
                        Utility.hideLoading()
                        let responseError:NSDictionary = NSDictionary.init()
                        self.dataBlock(responseError,responseError)
                    }
                
            case .failure(let encodingError):
                let responseError:NSDictionary = NSDictionary.init()
                self.dataBlock(responseError,encodingError)
            }
        }
    }
    
    func isValidResponse(response:AFDataResponse<Any>) -> Bool {
        var statusCode = response.response?.statusCode
        if let error = response.error?.asAFError {
            let status = "HTTP_ERROR_CODE_" + String(statusCode ?? 0)
            Utility.showToast(message: status.localized)
            statusCode = error._code
            Utility.hideLoading()
            return false
        } else {
            return true
        }
    }
}
