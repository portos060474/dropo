//
//  CustomDialogViewImage.swift
//  Edelivery
//
//  Created by Elluminati on 4/16/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class CustomDialogViewImage: CustomDialog {
 @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    static let  dialogNibName = "CustomDialogViewImage"
    var imgUrl: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickTapOnImage))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap)
    }
    
    @objc func onClickTapOnImage() {
        guard let img = imgView.image else { return }
        
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(img)
        images.append(photo)

        SKPhotoBrowserOptions.displayAction = false
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        window?.rootViewController?.present(browser, animated: true, completion: {})
    }
        
    public static func  showCustomDialogViewImage(title : String ,message: String,tag:Int = 414, imgUrlToView: String) -> CustomDialogViewImage
      {
          let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDialogViewImage
          view.tag = tag
          view.lblTitle.text = title
          let frame = (APPDELEGATE.window?.frame)!;
          view.frame = frame;
          DispatchQueue.main.async{
              UIApplication.shared.keyWindow?.addSubview(view)
              APPDELEGATE.window?.bringSubviewToFront(view);
              view.animationBottomTOTop(view.alertView)
          }
        view.imgUrl = imgUrlToView
        view.setLocalization()
          return view;
      }
    
    func setLocalization() {
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
              self.alertView.updateConstraintsIfNeeded()
              self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
              self.backgroundColor = UIColor.themeOverlayColor
        btnClose.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        imgView.downloadedFrom(link: imgUrl, placeHolder: "placeholder", isIndicator: true, isAppendBaseUrl: true)
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium()
    }
    
    override func updateUIAccordingToTheme() {
        setLocalization()
    }
    
    //ActionMethods
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.animationForHideView(alertView) {
            
            self.removeFromSuperview()
        }
    }
}
