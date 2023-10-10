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
    @IBOutlet weak var viewForDeliveryman: UIView!
    @IBOutlet weak var viewForUser: UIView!
    @IBOutlet weak var lblAdmin: UILabel!
    @IBOutlet weak var lblDeliveryman: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var ImageForAdmin: UIImageView!
    @IBOutlet weak var ImageForDeliveryman: UIImageView!
    @IBOutlet weak var ImageForUser: UIImageView!
   
    var isDeliverymanViewShow = false
    var isUserViewShow = false
    var onClickStoreButton : (() -> Void)? = nil
    var onClickDeliverymanButton : (() -> Void)? = nil
    var onClickAdminButton : (() -> Void)? = nil
    static let  dialogNibName = "dialogForChat"
  
    func setupLocalization() {
        lblAdmin.text = "TXT_CHAT_WITH".localized + "TXT_ADMIN".localized
        lblUser.text = "TXT_CHAT_WITH".localized + "TXT_STORE".localized
        lblDeliveryman.text = "TXT_CHAT_WITH".localized + "TXT_PROVIDER".localized
        lblAdmin.textColor = UIColor.themeTextColor
        lblUser.textColor = UIColor.themeTextColor
        lblDeliveryman.textColor = UIColor.themeTextColor
        lblAdmin.font = FontHelper.textRegular()
        lblUser.font = FontHelper.textRegular()
        lblDeliveryman.font = FontHelper.textRegular()
        lblTitle.text = "TXT_CHAT_WITH".localizedCapitalized
        lblTitle.font = FontHelper.textLarge()
        btnCancel.setTitleColor(UIColor.themeColor, for: .normal)
        btnCancel.tintColor = UIColor.themeColor
        btnCancel.setTitle("", for: .normal)
        btnCancel.imageView?.contentMode = .scaleAspectFit
        lblTitle.textColor = UIColor.themeTitleColor
        ImageForAdmin.image = UIImage.init(named: "chat_icon_admin")?.imageWithColor(color: .themeColor)
        ImageForDeliveryman.image = UIImage.init(named: "deliveryman_chat_icon")?.imageWithColor(color: .themeColor)
        ImageForUser.image = UIImage.init(named: "chat_icon_store")?.imageWithColor(color: .themeColor)
        self.alertView.updateConstraintsIfNeeded()
        self.backgroundColor = UIColor.themeOverlayColor
        btnCancel.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    public static func  showCustomChatDialog
        (DeliverymanChatVisible:Bool,storeChatVisible:Bool = false,
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
            view.viewForDeliveryman.isHidden = !DeliverymanChatVisible
            view.viewForUser.isHidden = storeChatVisible
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
    
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    override func updateUIAccordingToTheme() {
        self.setupLocalization()
    }
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        self.animationForHideView(alertView) {
            
            self.removeFromSuperview()
        }
    }
    
    @IBAction func onClickBtnAdmin(_ sender: Any) {
        
        self.animationForHideView(alertView) {
            
            if self.onClickAdminButton != nil {
                self.onClickAdminButton!();
            }
        }
    }
    
    @IBAction func onClickBtnDeliveryman(_ sender: Any) {
        self.animationForHideView(alertView) {
            if self.onClickDeliverymanButton != nil {
                self.onClickDeliverymanButton!();
            }
        }
    }
    
    @IBAction func onClickBtnUser(_ sender: Any) {
        self.animationForHideView(alertView) {
            if self.onClickStoreButton != nil {
                self.onClickStoreButton!();
            }
        }
    }
}
