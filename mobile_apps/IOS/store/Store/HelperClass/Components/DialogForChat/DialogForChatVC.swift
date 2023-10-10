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
    var onClickUserButton : (() -> Void)? = nil
    var onClickDeliverymanButton : (() -> Void)? = nil
    var onClickAdminButton : (() -> Void)? = nil
    static let  dialogNibName = "dialogForChat"
  
    func setupLocalization() {
        lblAdmin.text = "TXT_CHAT_WITH".localized + "TXT_ADMIN".localized
        lblUser.text = "TXT_CHAT_WITH".localized + "TXT_USER".localized
        lblDeliveryman.text = "TXT_CHAT_WITH".localized + "TXT_DELIVERYMAN".localized
        lblAdmin.textColor = UIColor.themeTextColor
        lblUser.textColor = UIColor.themeTextColor
        lblDeliveryman.textColor = UIColor.themeTextColor
        lblAdmin.font = FontHelper.textRegular()
        lblUser.font = FontHelper.textRegular()
        lblDeliveryman.font = FontHelper.textRegular()
        lblTitle.text = "TXT_CHAT".localizedCapitalized
        lblTitle.font = FontHelper.textLarge()
        btnCancel.setTitleColor(UIColor.themeColor, for: .normal)
         btnCancel.tintColor = UIColor.themeColor
        //btnCancel.setTitle("TXT_DONE".localizedUppercase, for: .normal)
         btnCancel.setTitle("", for: .normal)
        btnCancel.imageView?.contentMode = .scaleAspectFit
        lblTitle.textColor = UIColor.themeTitleColor
        ImageForAdmin.image = UIImage.init(named: "chat_icon_admin")?.imageWithColor(color: .themeColor)
        ImageForDeliveryman.image = UIImage.init(named: "deliveryman_chat_icon")?.imageWithColor(color: .themeColor)
        ImageForUser.image = UIImage.init(named: "bottomAccount")?.imageWithColor(color: .themeColor)
        
        
        self.alertView.updateConstraintsIfNeeded()
//        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.backgroundColor = UIColor.themeOverlayColor
        btnCancel.setImage(UIImage.init(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)

    }
    
    
    public static func  showCustomChatDialog(DeliverymanChatVisible:Bool,tag:Int = 412) -> DialogForChatVC
     {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogForChatVC
        view.tag = tag
        
        if ((APPDELEGATE.window?.viewWithTag(tag)) != nil) {
            APPDELEGATE.window?.bringSubviewToFront((APPDELEGATE.window?.viewWithTag(tag))!)
        }else {
            view.setupLocalization()
            view.viewForDeliveryman.isHidden = !DeliverymanChatVisible
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
        viewForDeliveryman.isHidden = isDeliverymanViewShow
        viewForUser.isHidden = isUserViewShow
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }*/
    
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    override func updateUIAccordingToTheme() {
        self.setupLocalization()
    }
    
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
    @IBAction func onClickBtnDeliveryman(_ sender: Any) {
        self.animationForHideAView(alertView) {
            
            if self.onClickDeliverymanButton != nil {
                self.onClickDeliverymanButton!();
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
