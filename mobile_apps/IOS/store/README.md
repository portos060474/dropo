
- Set App Constants
File Name : Constants.swift


- Set server URL for APIs and Images(Assets)
static let BASE_URL =  "https://edelivery.appemporio.net/"
static let BASE_URL_ASSETS =  "https://edelivery.appemporio.net/“
 

- Set Google API Keys
         static var API_KEY = ""
           static var MAP_KEY = ""

APIs Key will be set from Admin Panel which we get in API and set to these constants 

API Name : “api/admin/check_app_keys”
Function Name : parseAppSettingDetail

Eg,
Google.API_KEY = setting.googleKey!
Google.MAP_KEY = setting.googleKey!
 
- Force App Update URL
    	
static let UPDATE_URL = "https://itunes.apple.com/us/app/edelivery-store/id1281252858?ls=1&mt=8"
 
- App Images and Icons will be in .xcassets Files. And access directly using icon name “loginlogo”
 
Eg,
imgLogo.image = UIImage(named:"loginlogo")
 
 
          
- Theme Colors and Other common text and Background colors will be set in Theme.xcassets File 
 
Color constants will be in 
File Name : myAppTheme.swift
Function Name : setColors
Eg, UIColor.themeColor  = UIColor(red: 0/255, green: 175/255, blue: 194/255, alpha: 1.0)
                    UIColor.themeViewBackgroundColor = UIColor(named: "themeViewBackgroundColor")
 
 Set Fonts
 File Name : FontHelper.swift
 
Eg, static let regular:CGFloat = 14
                    class func textRegular(size: CGFloat = 14) -> UIFont {
        		return UIFont(name: "ClanPro-News", size: size)!
       }
 

- Build Project
Target Name : Store
Select appropriate certificates and profiles like : development, adhoc, distribution
Select Device
Run the project
