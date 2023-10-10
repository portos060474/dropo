//
//  CustomPhotoDialog.swift
//  edelivery






import Foundation
import UIKit


public class DialogForCardPinVerification:CustomDialog,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate{
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var txtF: UITextField!
    @IBOutlet  var bottomAnchorView: NSLayoutConstraint!

    //MARK:Variables
    let datePicker = UIDatePicker()
    var activeField: UITextField?

    var onClickRightButton : ((_ text:String ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil

    static let  verificationDialog = "DialogForCardPinVerification"
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    public static func showCustomVerificationDialog
    (title:String,
     message:String,
     titleLeftButton:String,
     titleRightButton:String,
     txtFPlaceholder:String,
     tag:Int = 400,
     isHideBackButton : Bool,
     isShowBirthdayTextfield : Bool = false
    ) ->
    DialogForCardPinVerification
     {
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogForCardPinVerification
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame

        view.lblTitle.text = title;
        view.lblMessage.text = message;

        view.txtF.placeholder = txtFPlaceholder

        view.setLocalization()
        view.btnRight.setTitle(titleRightButton.capitalized, for: UIControl.State.normal)
        
        view.btnRight.isHidden =  titleRightButton.isEmpty()
        view.lblTitle.isHidden = title.isEmpty()

        view.btnLeft.isHidden = isHideBackButton


        if isShowBirthdayTextfield{
            view.setDatePicker()
            view.txtF.inputView = view.datePicker
        }else{
            view.txtF.keyboardType = .numberPad
        }
        
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.alertView)
        }
        
        
        return view
    }
    
    func setLocalization(){
        btnLeft.setImage(UIImage(named:"close")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeLightTextColor

        btnRight.setRound(withBorderColor: .clear, andCornerRadious: 5.0, borderWidth: 1.0)
        /* Set Font */
        btnRight.titleLabel?.font =  FontHelper.textMedium(size: FontHelper.medium)
        lblTitle.font = FontHelper.textLarge(size: FontHelper.large)
        lblMessage.font = FontHelper.textSmall(size: FontHelper.small)

        txtF.font = FontHelper.textMedium(size: FontHelper.medium)
        txtF.textColor = UIColor.themeTextColor
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 10.0, borderWidth: 1.0)
        
        deregisterFromKeyboardNotifications()
        registerForKeyboardNotifications()
        
        self.delegatekeyboardWasShown = self
        self.delegatekeyboardWillBeHidden = self
    }

    func setDatePicker() {
        //Format Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

        txtF.inputAccessoryView = toolbar
    }

    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        txtF.text = formatter.string(from: datePicker.date)
        self.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.endEditing(true)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{

        if textField == self.txtF
        {
            textField.resignFirstResponder()
        }
        else
        {
            textField.resignFirstResponder();
        }
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    //ActionMethods

    @IBAction func onClickBtnLeft(_ sender: Any)
    {
            self.onClickLeftButton!();
    }
    
    @IBAction func onClickBtnRight(_ sender: Any)
    {
        self.onClickRightButton!(txtF.text ?? "")
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()

    }
    
    
    //MARK: Keyboard Delegates
    @objc override func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            let globalPoint = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            self.bottomAnchorView.constant = 0.0
            UIView.animate(withDuration: 0.5) {
                DispatchQueue.main.async {
                    self.bottomAnchorView.constant = keyboardSize!.height
                }
            }
        }
    }
    
    
    @objc override func keyboardWillBeHidden(notification: NSNotification)
    {
        var info : NSDictionary = notification.userInfo! as NSDictionary
        var keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        var contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        
        UIView.animate(withDuration: 0.5) {
            DispatchQueue.main.async {
                self.bottomAnchorView.constant = 0.0
            }
        }
        self.endEditing(true)
    }
}



