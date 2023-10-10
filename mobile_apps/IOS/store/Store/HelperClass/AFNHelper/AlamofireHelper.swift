
//
//  AlamofireHelper.swift
//  Store
//
//  Created by Jaydeep Vyas on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


typealias voidRequestCompletionBlock = (_ response:[String:Any],_ error:Any?) -> (Void)

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


class AlamofireHelper: NSObject {
    static let POST_METHOD = "POST"
    static let GET_METHOD = "GET"
    static let PUT_METHOD = "PUT"
    
    var dataBlock:voidRequestCompletionBlock={_,_ in};
    private lazy var alamoFireManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        //        if preferenceHelper.getUserId().count > 0{
        //
        //            configuration.httpAdditionalHeaders = ["lang":arrForLanguages[preferenceHelper.getLanguage()].code,"type":"0",PARAMS.STORE_ID:preferenceHelper.getUserId(),"token":preferenceHelper.getSessionToken()]
        //        }else{
        //            configuration.httpAdditionalHeaders = ["lang":arrForLanguages[preferenceHelper.getLanguage()].code,"type":"0"]
        //        }
        //        print("Https Header \(configuration.httpAdditionalHeaders ?? [:])")
        
        if preferenceHelper.getLanguageAdminLang().count > 0{
            ConstantsLang.AdminLanguageCodeSelected = preferenceHelper.getLanguageAdminLang()
            ConstantsLang.AdminLanguageIndexSelected = preferenceHelper.getLanguageAdminInd()
        }
        
        if preferenceHelper.getLanguageStoreLang().count > 0{
            ConstantsLang.StoreLanguageIndexSelected = preferenceHelper.getLanguageStoreInd()
            ConstantsLang.StoreLanguageCodeSelected = preferenceHelper.getLanguageStoreLang()
        }
        
        let alamoFireManager = Alamofire.Session(configuration: configuration)
        return alamoFireManager
        
    }()
    
    override init() {
        
        super.init()
    }
    func getResponseFromURL(url : String,methodName : String,paramData : Dictionary<String, Any>? , block:@escaping voidRequestCompletionBlock) {
        
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        print("\nURL : \(urlString)")
        print("\n parameter : \(String(describing: paramData))")
        
        if (methodName == AlamofireHelper.POST_METHOD) {
            
            //            let header: HTTPHeaders = ["lang":arrForLanguages[preferenceHelper.getLanguage()].code]
            //            print("url : \(url) lang = \(arrForLanguages[preferenceHelper.getLanguage()].code)")
            
            //let header: HTTPHeaders = ["lang":"\(preferenceHelper.getLanguageAdminInd())","type" : "0"]
            
            //Changed Header 3-7 //Store app
            /* var header: HTTPHeaders = [:]
             print("url : \(url) lang = \(arrForLanguages[preferenceHelper.getLanguage()].code)")
             print("url : \(url) AdminLanguageCodeSelected = \(ConstantsLang.AdminLanguageCodeSelected)")
             
             if preferenceHelper.getUserId().count > 0{
             header = ["lang":"\(preferenceHelper.getLanguageAdminInd())","type" : "0","storeid":preferenceHelper.getUserId(),"token":preferenceHelper.getSessionToken()]
             }else{
             header = ["lang":"\(preferenceHelper.getLanguageAdminInd())","type" : "0"]
             }*/
            print("Https Header \(String(describing: Utility.getHttpsHeaderForAPI()))")
            print("\nURL : \(urlString)")
            print("\n parameter : \(String(describing: paramData))")
            
            alamoFireManager.request(urlString, method: .post, parameters: paramData, encoding:JSONEncoding.default, headers: Utility.getHttpsHeaderForAPI()).responseJSON {
                (response:AFDataResponse<Any>) in
                
                if self.isRequestSuccess(response: response)
                {
                    if response.value != nil{
                        Log.i("url:\(urlString) Parameters: \(response.request?.httpBody) \n Response: - \((response.value as? [String:Any])) Time Required : ")
                        switch response.result
                        {
                            
                        case .success(_):
                            if response.value != nil{
                                self.dataBlock(response.value as! [String : Any], nil)
                            }
                        case .failure(_):
                            if response.error != nil{
                                self.dataBlock(response.value as! [String : Any], response.error)
                            }
                        }
                    }
                }
                else
                {
                    print(response)
                }
            }
        }else if(methodName == AlamofireHelper.GET_METHOD) {
            
            alamoFireManager.request(urlString).responseJSON(completionHandler: { (response:AFDataResponse<Any>) in
                if self.isRequestSuccess(response: response) {
                    if response.value != nil{
                        switch response.result
                        {
                            
                        case .success(_):
                            if response.value != nil{
                                self.dataBlock(response.value as! [String : Any], nil)
                            }
                        case .failure(_):
                            if response.error != nil{
                                self.dataBlock(response.value as! [String : Any], response.error)
                            }
                        }
                    }
                    // switch(response.result)
                    //                    {
                    //
                    //                    case .success(_):
                    //
                    //                        if response.result.value != nil
                    //                        {
                    //                            self.dataBlock((response.result.value as? [String:Any])!,nil)
                    //                        }
                    //                        break
                    //
                    //                    case .failure(_):
                    //                        if response.result.error != nil
                    //                        {
                    //                            let dictResponse:[String:Any] = [:]
                    //                            self.dataBlock(dictResponse,response.result.error!)
                    //                        }
                    //                        break
                    //                    }
                }
                else {
                    print(response)
                }
                
            })
            
        }
        
    }
    
    func stringArrayToData(stringArray: [String]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: stringArray, options: [])
    }
    
    func getResponseFromURL(url : String,paramData : Dictionary<String, Any>? ,image : UIImage?, block:@escaping voidRequestCompletionBlock) {
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        
        print("\nURL : \(urlString)")
        print("\n parameter : \(String(describing: paramData))")
        
        AF.upload(multipartFormData: { multipartFormData in
            
            if image != nil {
                if let imgData = image!.jpegData(compressionQuality: 1.0) {
                    multipartFormData.append(imgData, withName: PARAMS.IMAGE_URL,fileName: "file.jpeg", mimeType: "image/jpg")
                }
            }
            
            for (key, value) in paramData! {
                if type(of: value) == String.self{
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }else{
                    multipartFormData.append(self.stringArrayToData(stringArray: (value as! [String]))!, withName: key)
                }
                
            }
        }, to: urlString).responseJSON { (response:AFDataResponse<Any>) in
            if self.isRequestSuccess(response: response) {
                switch response.result {
                case .success(_):
                    if response.value != nil {
                        block(response.value as! [String:Any], nil)
                    }
                    break
                default:
                    if response.error != nil {
                        block(response.value as! [String:Any], response.error)
                    }
                    break
                }
            } else {
                print("Check Api response")
            }
        }
    }
    
    
    
    func getResponseFromURL(url : String,paramData : Dictionary<String, Any>? ,images : [UIImage?], block:@escaping voidRequestCompletionBlock) {
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        
        print("\nURL : \(urlString)")
        print("\n parameter : \(String(describing: paramData))")
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for image in images {
                let imgData = image!.jpegData(compressionQuality: 1.0)
                multipartFormData.append(imgData!, withName: PARAMS.IMAGE_URL,fileName: "File.jpg", mimeType: "image/jpg")
            }
            for (key, value) in paramData! {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:urlString) .responseJSON { (response:AFDataResponse<Any>) in
            if self.isRequestSuccess(response: response) {
                switch response.result {
                case .success(_):
                    if response.value != nil {
                        block(response.value as! [String:Any], nil)
                    }
                    break
                default:
                    if response.error != nil {
                        block(response.value as! [String:Any], response.error)
                    }
                    break
                }
            } else {
                print("Check Api response")
            }
        }
    }
    
    
    func getResponseFromURLWithImages(url : String,paramData : Dictionary<String, Any>?,imgParamData : [String],images : [UIImage?], block:@escaping voidRequestCompletionBlock) {
        self.dataBlock = block
        let urlString:String = WebService.BASE_URL + url
        
        print("\nURL : \(urlString)")
        print("\n parameter : \(String(describing: paramData))")
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for i in 0...images.count-1 {
                let imgData = images[i]!.jpegData(compressionQuality: 1.2)
                multipartFormData.append(imgData!, withName: imgParamData[i],fileName: "File.jpg", mimeType: "image/jpg")
            }
            for (key, value) in paramData! {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            print(multipartFormData)
        },to:urlString) .responseJSON { (response:AFDataResponse<Any>) in
            if self.isRequestSuccess(response: response) {
                switch response.result {
                case .success(_):
                    if response.value != nil {
                        block(response.value as! [String:Any], nil)
                    }
                    break
                default:
                    if response.error != nil {
                        block(response.value as! [String:Any], response.error)
                    }
                    break
                }
            } else {
                print("Check Api response")
            }
        }
    }
    
    func isRequestSuccess(response:AFDataResponse<Any>) -> Bool {
        
        var statusCode = response.response?.statusCode
        if let error = response.error as? AFError {
            
            let status = "HTTP_ERROR_CODE_" + String(statusCode ?? 0)
            
            if statusCode ?? 0 != 0 {
                Utility.showToast(message: status.localized)
            }
            
            statusCode = error._code
            Utility.hideLoading()
            return false
        }else if (response.error as? URLError) != nil {
            
            //Utility.showToast(message: "URL_IS_WRONG")
            Utility.hideLoading()
            return false
        }else {
            return true
        }
    }
}
