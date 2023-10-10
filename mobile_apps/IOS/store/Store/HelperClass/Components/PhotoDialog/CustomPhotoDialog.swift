//
//  CustomPhotoDialog.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices

let ANIMATION_DURATION  = 0.25

public class CustomPhotoDialog: CustomDialog,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var alertView: UIView!
    var onImageSelected : ((UIImage) -> Void)? = nil
    weak var parent:UIViewController?
    let picker = UIImagePickerController()
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnClose: UIButton!

    var isCropRequired:Bool = false
    var view:UIView?;
    var imageSelected:UIImage?;

    public override func awakeFromNib() {
        super.awakeFromNib();
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.addGestureRecognizer(tap)

        lblTitle?.font = FontHelper.textLarge()
        btnRight.titleLabel?.font = FontHelper.textRegular()
        btnLeft.titleLabel?.font = FontHelper.textRegular()
    }

    public static func showPhotoDialog(_ withTitle:String, andParent:UIViewController, leftTitle:String = "TXT_GALLERY".localized, rightTitle:String = "TXT_CAMERA".localized,isCropRequired:Bool = true) -> CustomPhotoDialog {

        let view = UINib(nibName: "dialogForChoosePicture", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPhotoDialog
        view.picker.delegate = view
        view.isCropRequired = isCropRequired
        view.btnLeft.setTitle("  " + leftTitle + "  ", for: UIControl.State.normal)
        view.btnRight.setTitle("  " + rightTitle + "  ", for: UIControl.State.normal)
        view.btnLeft.setTitleColor(.themeTextColor, for: .normal)
        view.btnRight.setTitleColor(.themeTextColor, for: .normal)
        view.lblTitle?.text = withTitle.localizedCapitalized;
        view.parent = andParent;
//        view.alertView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.themeOverlayColor
        view.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        view.frame = (APPDELEGATE.window?.frame)!;

        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
//        view.alertView.frame = CGRect.init(x: view.center.x, y: view.center.y, width: 0, height: 0);
        view.animationBottomTOTop(view.alertView)
        view.updateUIAccordingToTheme()
        return view
    }

    @objc func handleTap() {
        self.removeFromSuperview();
    }

    @IBAction func onClickBtnRight(_ sender: UIButton) {
        self.removeFromSuperview();
        checkCamera()
    }

    @IBAction func onClickBtnLeft(_ sender: UIButton) {
        self.removeFromSuperview();
        self.photoFromLibrary(nil)
    }

    @IBAction func onClickBtnClose(_ sender: UIButton) {
        self.removeFromSuperview();
    }

    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }

    override func updateUIAccordingToTheme() {
        btnClose.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        btnLeft.setImage(UIImage(named: "gallery")?.imageWithColor(color: .themeIconTintColor), for: .normal)
        btnRight.setImage(UIImage(named: "cameraBlack")?.imageWithColor(color: .themeIconTintColor), for: .normal)
    }

    //MARK: - Delegates
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        picker.dismiss(animated: true, completion: {
            if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                self.imageSelected = image
                if self.onImageSelected != nil {
                    self.onImageSelected!(self.self.imageSelected!)
                }
            } else if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                self.imageSelected = image
                if self.onImageSelected != nil {
                    self.onImageSelected!(self.imageSelected!)
                }
            } else {
                self.imageSelected = nil
            }
        })
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem?) {
        picker.navigationBar.tintColor = UIColor.black;
        picker.navigationBar.barTintColor = UIColor.white
        picker.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : UIColor.black])
        picker.allowsEditing = isCropRequired
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = [kUTTypeImage as String]
        picker.delegate = self
        DispatchQueue.main.async {
            self.parent?.present(self.picker, animated: true, completion: nil)
        }
    }

    @IBAction func photoFromCamera(_ sender: UIBarButtonItem?) {
        self.picker.navigationBar.tintColor = UIColor.black;
        self.picker.navigationBar.barTintColor = UIColor.white
        self.picker.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([
            NSAttributedString.Key.foregroundColor.rawValue : UIColor.black])
        self.picker.allowsEditing = self.isCropRequired
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.picker.sourceType = .camera
            self.picker.mediaTypes = [kUTTypeImage as String]
            self.picker.cameraFlashMode = .on
            DispatchQueue.main.async {
                self.parent?.present(self.picker, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Camera Error", message: "Camera is not available", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            DispatchQueue.main.async {
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
        let dialogForPermission = CustomAlertDialog.showCustomAlertDialog(title: "IMPORTANT".localized, message: "MSG_REASON_FOR_CAMERA_PERMISSION".localized, titleLeftButton: "".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
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
