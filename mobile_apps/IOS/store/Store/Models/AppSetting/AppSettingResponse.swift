//
//	AppSettingResponse.swift
//
//	Create by Jaydeep Vyas on 17/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class AppSettingResponse{

	var adminContactEmail : String!
	var googleKey : String!
	var isDocumentMandatory : Bool!
	var isForceUpdate : Bool!
	var isShowOptionalField : Bool!
	var isLoginByEmail : Bool!
	var isLoginByPhone : Bool!
	var isOpenUpdateDialog : Bool!
	var isProfilePictureRequired : Bool!
	var isUseReferral : Bool!
	var isVerifyEmail : Bool!
	var isVerifyPhone : Bool!
	var message : Int!
	var success : Bool!
	var versionCode : String!
    var isSocialLoginEnable:Bool!

    var adminEmail:String!
    var adminContact:String!
    var termsAndCondition:String!
    var privacyPolicy:String!
    
    var userBaseUrl:String!
    
    var mobileMinLenfth = 7
    var mobileMaxLenfth = 12
    
    var is_enable_twilio_call_masking = false
    
    var languages: [AdminLanguage] = []
    public var langItems : Array<SettingLangModel>?

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    init(fromDictionary dictionary: [String:Any]){
		adminContactEmail = dictionary["admin_contact_email"] as? String
		googleKey = dictionary["google_key"] as? String
		isDocumentMandatory = dictionary["is_document_mandatory"] as? Bool
		isForceUpdate = dictionary["is_force_update"] as? Bool
		isShowOptionalField = dictionary["is_show_optional_field"] as? Bool
		isLoginByEmail = dictionary["is_login_by_email"] as? Bool
		isLoginByPhone = dictionary["is_login_by_phone"] as? Bool
		isOpenUpdateDialog = dictionary["is_open_update_dialog"] as? Bool
		isProfilePictureRequired = dictionary["is_profile_picture_required"] as? Bool
		isUseReferral = dictionary["is_use_referral"] as? Bool
		isVerifyEmail = dictionary["is_verify_email"] as? Bool
		isVerifyPhone = dictionary["is_verify_phone"] as? Bool
		message = dictionary["message"] as? Int
		success = dictionary["success"] as? Bool
		versionCode = dictionary["version_code"] as? String
        userBaseUrl = (dictionary["user_base_url"] as? String) ?? ""
        
        if let languageArrya = dictionary["lang"] as? [[String:Any]] {
            ConstantsLang.adminLanguages.removeAll()
            for item in languageArrya
            {
                ConstantsLang.adminLanguages.append(AdminLanguage.init(fromDictionary: item))
            }
        }
        
        let lhs = Utility.currentAppVersion()
        let rhs = Utility.getLatestVersion()
        if lhs.compare(rhs, options: .numeric) == .orderedDescending {
            isSocialLoginEnable = false
        } else {
            isSocialLoginEnable = (dictionary["is_login_by_social"] as? Bool) ?? false
        }
        
        adminEmail = (dictionary["admin_contact_email"] as? String) ?? ""
        adminContact = (dictionary["admin_contact_phone_number"] as? String) ?? ""
        termsAndCondition = (dictionary["terms_and_condition_url"] as? String) ?? ""
        privacyPolicy = (dictionary["privacy_policy_url"] as? String) ?? ""
        
        mobileMinLenfth = (dictionary["minimum_phone_number_length"] as? Int) ?? 7
        mobileMaxLenfth = (dictionary["maximum_phone_number_length"] as? Int) ?? 12
        
        is_enable_twilio_call_masking = (dictionary["is_enable_twilio_call_masking"] as? Bool) ?? false
        
//        if (dictionary["lang"] != nil) {
//            langItems = SettingLangModel.modelsFromDictionaryArray(array: dictionary["lang"] as! NSArray)
//        }
        
	}
}


public class SettingLangModel {
    
    public var name : String?
    public var code : String?
    public var string_file_path : String?
    public var is_visible : Bool?

    public class func modelsFromDictionaryArray(array:NSArray) -> [SettingLangModel] {
           var models:[SettingLangModel] = []
           for item in array {
               models.append(SettingLangModel(dictionary: item as! NSDictionary)!)
           }
           return models
       }

    required public init?(dictionary: NSDictionary) {
          name = (dictionary["name"] as? String) ?? ""
          code = (dictionary["code"] as? String) ?? ""
          string_file_path = (dictionary["string_file_path"] as? String) ?? ""
        
        if code ==  "en"{
            is_visible = true
        }else{
            if dictionary["is_visible"] != nil{
                is_visible = (dictionary["is_visible"] as? Bool)
            }
        }
        
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.code, forKey: "code")
        dictionary.setValue(self.string_file_path, forKey: "string_file_path")
        dictionary.setValue(self.is_visible, forKey: "is_visible")

        return dictionary
    }
    
}
