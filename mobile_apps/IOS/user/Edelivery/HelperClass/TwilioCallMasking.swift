//
//  TwilloCall.swift
//  ESuper
//
//  Created by MacPro3 on 29/06/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import UIKit

class TwilioCallMasking {
    
    static let shared = TwilioCallMasking()
    
    func wsTwilloCallMasking(id: String, type: String) {
        
        Utility.showLoading()
        
        var dictParam:[String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.ORDER_ID] = id
        dictParam[PARAMS.call_to_usertype] = type
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_TWILLO_VOICE_CALL_USER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response,error) -> (Void) in
            Utility.hideLoading()
            guard let self = self else { return }
            
            if Parser.isSuccess(response: response) {
                self.openTwillioNotificationDialog()
            }
        }
    }
    
    private func openTwillioNotificationDialog() {
        let dialogForTwillioCall = CustomStatusDialog.showCustomStatusDialog(message: "TXT_CALL_MESSAGE".localized, titletButton: "TXT_CLOSE".localized)
        dialogForTwillioCall.onClickOkButton = {
            dialogForTwillioCall.removeFromSuperview()
        }
    }
}



