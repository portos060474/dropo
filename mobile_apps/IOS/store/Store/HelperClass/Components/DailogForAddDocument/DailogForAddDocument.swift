//
//  DailogForAddDocument.swift
//  Edelivery Provider
//
//  Created by Elluminati on 17/03/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import UIKit


class DailogForAddDocument: CustomDialog,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate{

    
    @IBOutlet weak var txtExpDate: UITextField!
    @IBOutlet weak var txtDocId: UITextField!
    @IBOutlet weak var lblDocId: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var viewExpDate: UIView!
    @IBOutlet weak var viewDocId: UIView!
    @IBOutlet weak var imageForCalendar: UIImageView!
    
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocTitle: UILabel!
    var selectedDocument:Document? = nil
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    static let  dialogNibName = "DailogForAddDocument"
    var parentView:UIViewController!
    var isPicAdded:Bool = false;
    var keyboardHeight : CGFloat = 50.0
    @IBOutlet weak var constraintForBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintForHeight: NSLayoutConstraint!
    var activeField: UITextField?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func updateUIAccordingToTheme() {
        imageForCalendar.image = UIImage.init(named: "calender")?.imageWithColor(color: UIColor.themeColor)
    }
    var onClickSubmitButton : ((_ value : Document , _ image : UIImage) -> Void)? = nil
    public static func  showCustomAddDocumentDialog(title:String,DocIDShow : Bool,DocDateShow : Bool,DocImage : Bool,
                                                    titleRightButton:String, viewController : UIViewController , selecteddocument : Document ,
                                                    tag:Int = 416) -> DailogForAddDocument
    {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailogForAddDocument
        view.tag = tag
        view.parentView = viewController
        view.setupLocalization()
        
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.txtDocId.text = ""
        view.txtExpDate.text = ""
        view.imgDocument.image = UIImage.init(named:"document_placeholder")
        view.selectedDocument = selecteddocument
        view.lblDocTitle.text = title
        view.viewDocId.isHidden = DocIDShow
        view.viewExpDate.isHidden = DocDateShow
        view.imgDocument.isHidden = DocImage
        view.btnSubmit.setTitle(titleRightButton, for: .normal)
        if (selecteddocument.documentDetails.isExpiredDate)! {
            if !selecteddocument.expiredDate.isEmpty {
                view.txtExpDate.text = Utility.stringToString(strDate: selecteddocument.expiredDate!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
                
            }
            else {
                selecteddocument.expiredDate = ""
            }
        }
        if (selecteddocument.documentDetails.isUniqueCode)! {
            view.txtDocId.text = selecteddocument.uniqueCode
        }
        if !(selecteddocument.imageUrl!.isEmpty) {
            view.isPicAdded = true
            view.imgDocument.downloadedFrom(link: (selecteddocument.imageUrl ?? ""), placeHolder: "document_placeholder")
        }
        
        DispatchQueue.main.async{
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
        }
        
        view.alertView.layoutIfNeeded()
        DispatchQueue.main.async {
            view.animationBottomTOTop(view.alertView)
        }
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        return view;
    }
   
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    func setupLocalization() {
        
        lblDocTitle.font = FontHelper.textLarge()
        lblDocTitle.textColor = UIColor.themeTitleColor
        lblDocId.font = FontHelper.textRegular()
        lblDocId.textColor = .themeLightTextColor
        
        lblExpDate.font = FontHelper.textRegular()
        lblExpDate.textColor = .themeLightTextColor
        txtExpDate.backgroundColor = .themeViewBackgroundColor
        txtDocId.backgroundColor = .themeViewBackgroundColor
        imageForCalendar.image = UIImage.init(named: "calender")?.imageWithColor(color: .themeColor)
        lblDocId.text = "TXT_ENTER_ID_NUMBER".localized
        txtExpDate.placeholder = ""
        lblExpDate.text = "TXT_ENTER_EXP_DATE".localized
        txtDocId.placeholder = ""
        
        btnCancel.setTitle("", for: .normal)
        btnCancel.tintColor = .themeColor
        btnCancel.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnCancel.tintColor = .themeColor
        btnCancel.setImage(UIImage.init(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        
        
        imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgDocument.isUserInteractionEnabled = true
        imgDocument.addGestureRecognizer(tapGestureRecognizer)
        txtExpDate.font = FontHelper.textRegular()
        txtDocId.font = FontHelper.textRegular()
        txtDocId.delegate = self
        txtExpDate.delegate = self
       /* (txtDocId as? CustomTextfield)?.selectedLineColor = .themeViewBackgroundColor
        (txtDocId as? CustomTextfield)?.lineColor = .themeViewBackgroundColor
        (txtExpDate as? CustomTextfield)?.selectedLineColor = .themeViewBackgroundColor
        (txtExpDate as? CustomTextfield)?.lineColor = .themeViewBackgroundColor*/
        
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
//        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.backgroundColor = UIColor.themeOverlayColor
    
    }
    
    override func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            
            if (aRect.contains(activeField!.frame.origin))
            {
                constraintForBottom.constant = 0.0
                UIView.animate(withDuration: 1.0) {
                    self.constraintForBottom.constant = keyboardSize?.height ?? 0.0
                }
            }
        }
    }
   override func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        
        UIView.animate(withDuration: 1.0) {
            self.constraintForBottom.constant = 00.0
        }
        self.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if txtExpDate == textField {
            openDatePicker()
            return false
        }else {
            activeField = textField
            return true
        }
            
      }
    func openImageDialog(){
        let dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: parentView, isCropRequired: false)
        dialogForImage.onImageSelected = { [unowned self, weak dialogForImage ]
            (image:UIImage) in
            
            self.imgDocument.image = image
            self.isPicAdded = true
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.endEditing(true)
        self.openImageDialog()
    }
    func openDatePicker(){
        self.endEditing(true)
        let datePickerDialog: CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_EXPIRY_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        datePickerDialog.setMinDate(mindate: Date())
        let maxDate:Date =  Calendar.current.date(byAdding: .year, value: 100, to: Date()) ?? Date.init()
        datePickerDialog.setMaxDate(maxdate: maxDate)

        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self] (selectedDate:Date) in
                let currentDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_FORMAT)
                self.selectedDocument?.expiredDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
                self.txtExpDate.text = currentDate
                datePickerDialog.removeFromSuperview()
        }
        
        
    }
    func checkDocumentValidation() -> Bool{
        

        let docDetail:DocumentDetail = (selectedDocument?.documentDetails)!
        
        
        if ((txtDocId.text?.isEmpty())! && (docDetail.isUniqueCode)!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_ID".localized)
            return false
        }else if ((txtExpDate.text?.isEmpty())! && (docDetail.isExpiredDate)!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_DOCUMENT_EXP_DATE".localized)
            return false
        }else if !isPicAdded {
            Utility.showToast(message:"MSG_PLEASE_SELECT_DOCUMENT_IMAGE".localized)
            return false
        }else {
            return true
        }
    }
    @IBAction func onClickBtnSubmit(_ sender: Any) {
        //self.endEditing(true)
        
        if self.checkDocumentValidation() {
            if !viewDocId.isHidden {
                selectedDocument?.uniqueCode = txtDocId.text
            }
            if onClickSubmitButton != nil {
                if self.onClickSubmitButton != nil {
                    
                    
                    
                    self.animationForHideAView(alertView) {
                        self.onClickSubmitButton!(self.selectedDocument! ,self.imgDocument.image!)
                        self.removeFromSuperview();
                    }
                }
                
            }
        }
        
       
        
    }
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        //self.endEditing(true)
        self.animationForHideAView(alertView) {
            
            self.removeFromSuperview();
        }
        
    }
}
