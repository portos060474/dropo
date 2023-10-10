//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices

public class CustomPhotoDialog: CustomDialog,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var alertView: UIView!
    var onImageSelected : ((UIImage) -> Void)? = nil
    weak var parent:UIViewController?
    let picker = UIImagePickerController()
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var view:UIView?;
    var imageSelected:UIImage?;
    var isFromDocumentDailog = false
    var isCrop = false

    public override func awakeFromNib() {
        super.awakeFromNib();
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.addGestureRecognizer(tap)

        lblTitle?.font = FontHelper.textLarge()
        btnRight.titleLabel?.font = FontHelper.textRegular()
        btnLeft.titleLabel?.font = FontHelper.textRegular()
        alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
        self.backgroundColor = UIColor.themeOverlayColor
    }

    public static func showPhotoDialog(_ withTitle:String, andParent:UIViewController, leftTitle:String = "TXT_GALLERY".localized, rightTitle:String = "TXT_CAMERA".localized,isCameraOnly:Bool=false , isFrom:Bool = true, isCrop: Bool = false) -> CustomPhotoDialog {

        let view = UINib(nibName: "dialogForChoosePicture", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPhotoDialog
        view.picker.delegate = view
        view.parent = andParent;
        view.isCrop = isCrop

        if isCameraOnly {
            view.photoFromCamera(nil)
        } else {
            view.backgroundColor = UIColor.themeOverlayColor
            view.alertView.backgroundColor = UIColor.white
            view.btnLeft.setTitle("   " + leftTitle, for: UIControl.State.normal)
            view.btnRight.setTitle("   " + rightTitle, for: UIControl.State.normal)
            view.btnLeft.setImage(UIImage.init(named: "gallery_icon")?.imageWithColor(color: .themeIconTintColor), for: .normal)
            view.btnRight.setImage(UIImage.init(named: "camera_icon")?.imageWithColor(color: .themeIconTintColor), for: .normal)
            
            view.lblTitle?.text = withTitle.localizedUppercase;
            view.setLocalization()
            view.alertView.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 1.0)
            view.frame = (APPDELEGATE.window?.frame)!;
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
            view.alertView.frame = CGRect.init(x: view.center.x, y: view.center.y, width: 0, height: 0);
        }

        if arrForLanguages[preferenceHelper.getLanguage()].1 == "ar" {
            view.btnRight.contentHorizontalAlignment = .right
            view.btnLeft.contentHorizontalAlignment = .right
        }

        view.isFromDocumentDailog = isFrom
        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        return view
    }

    func setLocalization() {
        alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
        backgroundColor = UIColor.themeOverlayColor
        btnLeft.setTitleColor(.themeTextColor, for: .normal)
        btnRight.setTitleColor(.themeTextColor, for: .normal)
        btnLeft.tintColor = .themeIconTintColor
        btnRight.tintColor = .themeIconTintColor
        btnCancel.setTitle("", for: .normal)
        btnCancel.tintColor = .themeColor
        btnCancel.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }

    @IBAction func onClickBtnCancel(_ sender: Any) {
        self.animationForHideAView(alertView) {
            self.removeFromSuperview();
        }
    }

    @objc func handleTap() {
        if isFromDocumentDailog {
            self.removeFromSuperview();
        }
    }

    @IBAction func onClickBtnRight(_ sender: UIButton) {
        if isFromDocumentDailog {
            self.removeFromSuperview();
        }
        checkCamera()
    }

    @IBAction func onClickBtnLeft(_ sender: UIButton) {
        if isFromDocumentDailog {
            self.removeFromSuperview();
        }
        self.photoFromLibrary(nil)
    }

    //MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        print(info)
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            imageSelected = image
            if self.onImageSelected != nil {
                onImageSelected!(imageSelected!)
            }
        } else if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imageSelected = image
            if self.onImageSelected != nil {
                onImageSelected!(imageSelected!)
            }
        } else {
            imageSelected = nil
        }

        picker.dismiss(animated: true, completion: {
            if !self.isFromDocumentDailog {
                self.removeFromSuperview();
            }
        })
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            if !self.isFromDocumentDailog {
                self.removeFromSuperview();
            }
        })
    }

    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem?) {
        picker.navigationBar.tintColor = UIColor.black;
        picker.navigationBar.barTintColor = UIColor.white
        picker.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor.black])
        picker.allowsEditing = isCrop
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = [kUTTypeImage as String]

        DispatchQueue.main.async {
            self.parent?.present(self.picker, animated: true, completion: nil)
        }
    }

    @IBAction func photoFromCamera(_ sender: UIBarButtonItem?) {
        picker.navigationBar.tintColor = UIColor.black;
        picker.navigationBar.barTintColor = UIColor.white
        picker.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor.black])
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.cameraFlashMode = .on
            DispatchQueue.main.async {
                self.parent?.present(self.picker, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Camera Error", message: "Camera is not available", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.parent!.present(alertController, animated: true, completion: nil)
            }
        }
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview();
    }

    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)))
        switch authStatus {
        case .authorized:
            self.photoFromCamera(nil)
        case .denied:
            alertPromptToAllowCameraAccessViaSetting()
        case .notDetermined:
            alertToEncourageCameraAccessInitially()
        default:
            alertToEncourageCameraAccessInitially()
        }
    }

    func alertToEncourageCameraAccessInitially() {
        AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)), completionHandler: { success in
            if success {
                self.photoFromCamera(nil)
            }
        })
    }

    func alertPromptToAllowCameraAccessViaSetting() {
        let dialogForPermission = CustomAlertDialog.showCustomAlertDialog(title: "IMPORTANT".localized, message: "MSG_REASON_FOR_CAMERA_PERMISSION".localized.replacingOccurrences(of: "****", with: "APP_NAME".localized), titleLeftButton: "".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForPermission.onClickLeftButton = { [unowned dialogForPermission] in
            dialogForPermission.removeFromSuperview();
        }
        dialogForPermission.onClickRightButton = { [unowned dialogForPermission] in
            dialogForPermission.removeFromSuperview();
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
    return input.rawValue
}
