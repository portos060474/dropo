//
//  DialogForChatVC.swift
//  demoTransformAnimation
//
//  Created by Elluminati mac mini on 24/02/21.
//  Copyright © 2021 Elluminati mac mini. All rights reserved.
//

import UIKit

class DialogForChatVC: CustomDialog {

    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewForAdmin: UIView!
    @IBOutlet weak var viewForStore: UIView!
    @IBOutlet weak var viewForUser: UIView!
    @IBOutlet weak var lblAdmin: UILabel!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var ImageForAdmin: UIImageView!
    @IBOutlet weak var ImageForStore: UIImageView!
    @IBOutlet weak var ImageForUser: UIImageView!
    var isStoreViewShow = false
    var isUserViewShow = false
    var onClickUserButton : (() -> Void)? = nil
    var onClickStoreButton : (() -> Void)? = nil
    var onClickAdminButton : (() -> Void)? = nil
    static let  dialogNibName = "dialogForChat"

    override func updateUIAccordingToTheme() {
        self.setupLocalization()
    }

    func setupLocalization() {
        lblAdmin.text = "TXT_CHAT_WITH".localized + "TXT_ADMIN".localized
        lblUser.text = "TXT_CHAT_WITH".localized + "TXT_USER".localized
        lblStore.text = "TXT_CHAT_WITH".localized + "TXT_STORE".localized
        lblAdmin.textColor = UIColor.themeTextColor
        lblUser.textColor = UIColor.themeTextColor
        lblStore.textColor = UIColor.themeTextColor
        lblAdmin.font = FontHelper.textRegular()
        lblUser.font = FontHelper.textRegular()
        lblStore.font = FontHelper.textRegular()
        lblTitle.text = "TXT_CHAT".localizedCapitalized
        lblTitle.font = FontHelper.textLarge()
        btnCancel.setTitleColor(UIColor.themeIconTintColor, for: .normal)
         btnCancel.tintColor = UIColor.themeIconTintColor
        //btnCancel.setTitle("TXT_DONE".localizedUppercase, for: .normal)
         btnCancel.setTitle("", for: .normal)
         btnCancel.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        btnCancel.imageView?.contentMode = .scaleAspectFit
        lblTitle.textColor = UIColor.themeTitleColor
        ImageForAdmin.image = UIImage.init(named: "chat_icon_admin")?.imageWithColor(color: .themeColor)
        ImageForStore.image = UIImage.init(named: "chat_icon_store")?.imageWithColor(color: .themeColor)
        ImageForUser.image = UIImage.init(named: "chat_icon_user")?.imageWithColor(color: .themeColor)
        
        
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.backgroundColor = UIColor.themeOverlayColor
    }
    
    public static func  showCustomChatDialog
    (storeChatVisible:Bool,userChatVisible:Bool,
         tag:Int = 412
         ) ->
    DialogForChatVC
     {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogForChatVC
        view.tag = tag
        
        if ((APPDELEGATE.window?.viewWithTag(tag)) != nil) {
            APPDELEGATE.window?.bringSubviewToFront((APPDELEGATE.window?.viewWithTag(tag))!)
        }else {
            view.setupLocalization()
            view.viewForStore.isHidden = storeChatVisible
            view.viewForUser.isHidden = userChatVisible
            let frame = (APPDELEGATE.window?.frame)!;
            view.frame = frame;
           
            DispatchQueue.main.async{
                UIApplication.shared.keyWindow?.addSubview(view)
                APPDELEGATE.window?.bringSubviewToFront(view);
            }
        }
        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        return view;
    }
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewForStore.isHidden = isStoreViewShow
        viewForUser.isHidden = isUserViewShow
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }*/
    @IBAction func onClickBtnCancel(_ sender: Any) {
        self.animationForHideAView(alertView) {
            
            self.removeFromSuperview()
        }
        
    }
    @IBAction func onClickBtnAdmin(_ sender: Any) {
        self.animationForHideAView(alertView) {
            
            if self.onClickAdminButton != nil {
                self.onClickAdminButton!();
            }
        }
        
    }
    @IBAction func onClickBtnStore(_ sender: Any) {
        self.animationForHideAView(alertView) {
            
            if self.onClickStoreButton != nil {
                self.onClickStoreButton!();
            }
        }
        
    }
    
    @IBAction func onClickBtnUser(_ sender: Any) {
        self.animationForHideAView(alertView) {
            
            if self.onClickUserButton != nil {
                self.onClickUserButton!();
            }
        }
        
    }
    
  

}
