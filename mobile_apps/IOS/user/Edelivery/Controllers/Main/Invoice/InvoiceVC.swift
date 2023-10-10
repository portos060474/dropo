//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class InvoiceVC: BaseVC,UITableViewDelegate,UITableViewDataSource,LocationHandlerDelegate,UITextFieldDelegate,LeftDelegate {
    /*View Available Deliveries*/
    @IBOutlet weak var stkAddress: UIStackView!
    @IBOutlet weak var viewForAsap: UIView!
    @IBOutlet weak var viewForSchedule: UIView!
    @IBOutlet weak var btnASAP: UIButton!
    @IBOutlet weak var lblAsap: UILabel!
    @IBOutlet weak var lblScheduleOrder: UILabel!
    @IBOutlet weak var btnScheduleOrder: UIButton!
    @IBOutlet weak var viewForTime: UIView!
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var viewForDate: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewForDateAndTime: UIView!
    var unitIsKilometer:Bool = false
    @IBOutlet weak var viewForPickupDelivery: UIView!

    //MARK: - OutLets
    var storeOpen:(Bool,String) = (true,"")
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddNote: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet weak var viewForTotal: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnApplyPromo: UIButton!
    @IBOutlet weak var stkPromoView: UIStackView!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var tableForInvoice: UITableView!
    @IBOutlet weak var scrInvoice: UIScrollView!
    @IBOutlet weak var heightForTableInvoice: NSLayoutConstraint!

    //Contact less Delivery
    @IBOutlet weak var viewContactLess: UIView!
    @IBOutlet weak var viewTip: UIView!
    @IBOutlet weak var btnContactLess: UIButton!
    @IBOutlet weak var lblContactLess: UILabel!
    @IBOutlet weak var lblUserPickupDelivery: UILabel!
    @IBOutlet weak var cbPickupDelivery: UIButton!
    @IBOutlet weak var btnPickUpIcon: UIButton!
    @IBOutlet weak var lblTip5: UILabel!
    @IBOutlet weak var lblTip10: UILabel!
    @IBOutlet weak var lblTip15: UILabel!
    @IBOutlet weak var lblNoTip: UILabel!
    @IBOutlet weak var txtVTip: UITextField!
    @IBOutlet weak var viewTip5: UIView!
    @IBOutlet weak var viewTip10: UIView!
    @IBOutlet weak var viewTip15: UIView!
    @IBOutlet weak var viewNoTip: UIView!
    @IBOutlet weak var viewtxtFTip: UIView!
    @IBOutlet weak var viewForPromoCode: UIView!
    @IBOutlet weak var btnOffers: UIButton!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!

    //MARK: - Variables
    var isFreeDelivery:Bool = false
    var isTakingScheduleOrder = false
    var isShowSlots = false
    var selectedStore:StoreItem? = currentBooking.selectedStore
    var cartListLength:Int = 0
    var myDeliveryLatitude:Double = 0.0
    var myDeliveryLongitude:Double = 0.0
    var selectedTipInd:Int = -1
    var tipValue:Int = 0
    var tipEntered : Int = 0
    var myAddressArray:NSArray? = nil
    var arrForInvoice:NSMutableArray = []
    var selectedStoreTime:[StoreTime]=[]
    var selectedStoreSlotTime:[StoreTime]=[]
    var vehicleName:String = ""
    var timeZone:TimeZone = TimeZone.init(identifier:currentBooking.selectedCityTimezone)!
    //ViewForAsAp

    @IBOutlet weak var lblReopenAt: UILabel!
    //ViewForDate&Time
    @IBOutlet weak var btnEditUserDetail: UIButton!
    @IBOutlet weak var lblWhen: UILabel!
    @IBOutlet weak var btnASAPIcon: UIButton!
    @IBOutlet weak var btnScheduleIcon: UIButton!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!

    @IBOutlet weak var viewDateIcon: UIView!
    @IBOutlet weak var viewTimeIcon: UIView!
    @IBOutlet weak var lblOffers: UILabel!
    @IBOutlet weak var lblTipTitle: UILabel!
    @IBOutlet weak var lblTipMsg: UILabel!
    @IBOutlet weak var imgContactLess: UIImageView!
    @IBOutlet weak var viewAddress: UIView!

    var arrAvailabletable:[Table_list] = []
    var responseFetchStoreSetting:ResponseFetchStoreSetting?

    @IBOutlet weak var viewForTableReservation: UIView!
    @IBOutlet weak var lblReservationTable: UILabel!
    @IBOutlet weak var btnReservationIcon: UIButton!
    @IBOutlet weak var viewForNumberOfPeoples: UIView!
    @IBOutlet weak var viewForTable: UIView!
    @IBOutlet weak var viewForPeoples: UIView!
    @IBOutlet weak var lblPeoples: UILabel!
    @IBOutlet weak var txtPeoples: UITextField!
    @IBOutlet weak var viewForPeoplesIcon: UIView!
    @IBOutlet weak var lblTables: UILabel!
    @IBOutlet weak var viewForTableIcon: UIView!
    @IBOutlet weak var txtTables: UITextField!
    @IBOutlet weak var btnLogin: UIButton!

    var minDate = Date()
    var maxDate = Date()

    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideBackButtonTitle()
        Utility.showLoading()
        self.getTableBookingSetting()
        currentBooking.isUserPickUpOrder = false
        cbPickupDelivery.isSelected = false
        self.setBackBarItem(isNative: false)
        delegateLeft = self
        setLocalization()
        viewForDate.tag = 0
        viewForTime.tag = 1
        viewForTime.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(InvoiceVC.onClickBtnDate(_:))))
        viewForDate.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(InvoiceVC.onClickBtnDate(_:))))
        viewForPeoples.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(InvoiceVC.onClickBtnPeople(_:))))
        viewForTable.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(InvoiceVC.onClickBtnTable(_:))))
        self.tableForInvoice.estimatedRowHeight = 30
        self.tableForInvoice.rowHeight = UITableView.automaticDimension
        viewForTime.isUserInteractionEnabled = true
        viewForDate.isUserInteractionEnabled = true
        let asapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnASAP))
        lblAsap.isUserInteractionEnabled = true
        lblAsap.addGestureRecognizer(asapGesture)
        let scheduleGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnSchedule))
        lblScheduleOrder.isUserInteractionEnabled = true
        lblScheduleOrder.addGestureRecognizer(scheduleGesture)
        
        // Gesture for ASAP
        let asapTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onClickBtnAsap(_:)))
        lblAsap.isUserInteractionEnabled = true
        lblAsap.addGestureRecognizer(asapTapGesture)
        viewForPickupDelivery.isHidden = true
        let userPickupTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onClickCbPickupDelivery(_:)))
        lblUserPickupDelivery.isUserInteractionEnabled = true
        lblUserPickupDelivery.addGestureRecognizer(userPickupTapGesture)
        self.viewForSchedule.isHidden = true
        self.viewForPromoCode.isHidden = !IS_PROMOCODE_AVAILABLE
        self.hideDetailsWhenTableReservation()
        self.hideDetailsWhenQrCodeTableReservation()
        
        txtContactNo.keyboardType = .numberPad
    }

    func onClickLeftButton() {
        if currentBooking.isQrCodeScanBooking {
            self.openConfirmationTableBookingClearDialog(qrCode: true)
        }
        else if Utility.isTableBooking() {
            self.openConfirmationTableBookingClearDialog(qrCode: false)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func openConfirmationTableBookingClearDialog(qrCode: Bool) {
        
        let strMsg: String = {
            if qrCode {
                return "msg_clear_qr_order_data".localized
            }
            return "msg_clear_reservation_table_process".localized
        }()
        
        let dialogForClearCart = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: strMsg, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
        dialogForClearCart.onClickLeftButton = { [unowned self,unowned dialogForClearCart] in
            dialogForClearCart.removeFromSuperview()
        }
        dialogForClearCart.onClickRightButton = { [unowned self,unowned dialogForClearCart] in
            dialogForClearCart.removeFromSuperview()
            Utility.showLoading()
            self.wsClearCart()
            if qrCode {
                APPDELEGATE.clearQRUser()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APPDELEGATE.setupNavigationbar()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        btnLogin.isHidden = true
        if currentBooking.isQrCodeScanBooking {
            if preferenceHelper.getUserId().isEmpty() {
                btnLogin.isHidden = false
            }
        }

        if currentBooking.isFutureOrder {
            viewForDateAndTime.isHidden = false
            btnScheduleOrder.isSelected = true
            btnASAP.isSelected = false
            lblAsap.textColor = UIColor.themeTitleColor
            btnASAPIcon.isSelected = false
            lblScheduleOrder.textColor = UIColor.themeColor
            let components = Utility.millisecondToDateComponents(milliSeconds: currentBooking.futureDateMilliSecond)
            self.txtDate.text = String(components.day!) +  "-" + String(components.month!) + "-" + String(components.year!)
            if currentBooking.futureDateMilliSecond2 > 0 {
                let components2 = Utility.millisecondToDateComponents(milliSeconds: currentBooking.futureDateMilliSecond2)
                self.txtTime.text = "\(String(components.hour!)):00" +  " - " + "\(String(components2.hour!)):00"
            } else {
                self.txtTime.text = String(components.hour!) +  "-" + String(components.minute!)
            }
            self.lblDate.text = "TXT_DATE".localized
            self.lbltime.text = "TXT_TIME".localized

            if !Utility.isTableBooking() {
                self.txtDate.text = ""
                self.txtTime.text = ""
            }

            if Utility.isTableBooking() {
                let formatter = DateFormatter()
                formatter.dateFormat = DATE_CONSTANT.DATE_SCHEDULE
                guard let date = formatter.date(from: self.txtDate.text ?? "") else {
                    return
                }
                formatter.dateFormat = DATE_CONSTANT.DATE_FORMATE_WITHOUT_TIME
                self.selectedDateStr = formatter.string(from: date)
                formatter.dateFormat = DATE_CONSTANT.DATE_FORMATE_DAY
                self.selectedDayInd = Utility.getWeekDayInd(day: formatter.string(from: date))
                txtPeoples.text = "\(currentBooking.number_of_pepole)"
                txtTables.text = "\(currentBooking.table_no)"
            }
        } else {
            viewForDateAndTime.isHidden = true
            btnScheduleOrder.isSelected = false
            self.lblDate.text = "TXT_DATE".localized
            self.lbltime.text = "TXT_TIME".localized
            lblAsap.textColor = UIColor.themeColor
            btnASAPIcon.isSelected = true
            btnASAP.isSelected = true
            lblScheduleOrder.textColor = UIColor.themeTitleColor
            btnScheduleIcon.isSelected = false
            btnScheduleOrder.isSelected = false
            //btnOffers.setImage(UIImage.init(named: "offers_icon")?.imageWithColor(color: .themeColor), for: .normal)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareInvoicePARAMS(isFromTipApplied: false)
    }

    @IBAction func onClickBtnSchedualOrder(_ sender: Any) {
        lblAsap.textColor = UIColor.themeTitleColor
        btnASAPIcon.isSelected = false
        lblScheduleOrder.textColor = UIColor.themeColor
        btnScheduleIcon.isSelected = true
        viewForDateAndTime.isHidden = false
        btnASAP.isSelected = false
        btnScheduleOrder.isSelected = true
        lblReopenAt.isHidden = true
    }

    @IBAction func onClickBtnAsap(_ sender: Any) {
        lblAsap.textColor = UIColor.themeColor
        btnASAPIcon.isSelected = true
        lblScheduleOrder.textColor = UIColor.themeTitleColor
        btnScheduleIcon.isSelected = false
        lblReopenAt.isHidden = true
        viewForDateAndTime.isHidden = true
        btnASAP.isSelected = true
        btnScheduleOrder.isSelected = false
        self.lblDate.text = "TXT_DATE".localized
        self.lbltime.text = "TXT_TIME".localized
        currentBooking.futureUTCMilliSecond = 0
        currentBooking.futureUTCMilliSecond2 = 0
        currentBooking.isFutureOrder = false
        selectedDayInd = 0
        selectedDateStr = ""
        txtDate.text = ""
        txtTime.text = ""
        self.storeOpen = Utility.isStoreOpen(storeTime: self.selectedStoreTime,milliSeconds: currentBooking.currentDateMilliSecond)
    }

    @IBAction func contactLessPressed(_ sender: UIButton) {
        sender.isSelected =  !sender.isSelected
        currentBooking.isContactLessDelivery = sender.isSelected
    }

    @IBAction func onClickBtnEditUserData(_ sender: UIButton) {
        if currentBooking.isUserPickUpOrder || currentBooking.isQrCodeScanBooking || Utility.isTableBooking() {
            showUserDailog()
        } else {
            self.onClickBtnAddress(btnMap)
        }
 
        /*
        if btnEditUserDetail.isSelected {
            if checkValidation() {
                txtContactNo.isEnabled = false
                txtCountryCode.isEnabled = false
                btnMap.isEnabled = false
                txtName.isEnabled = false
                txtAddNote.isEnabled = false
                wsAddItemInServerCart()
            }
        } else {
            txtName.isEnabled = true
            txtContactNo.isEnabled = true
            txtCountryCode.isEnabled = true
            btnMap.isEnabled = !currentBooking.isUserPickUpOrder
            txtAddNote.isEnabled = true
        }
        btnEditUserDetail.isSelected = !btnEditUserDetail.isSelected*/
    }
    
    func showUserDailog() {
        let dailog = CustomUserDetailDialog.showCustomDialog(title: "TXT_DELIVERY_DETAILS".localizedCapitalized, titleLeftButton: "", titleRightButton: "TXT_UPDATE".localizedCapitalized)
        let detail = getDestinationAddress()
        if currentBooking.isQrCodeScanBooking {
            detail.userDetails?.email = txtEmail.text!
            detail.userDetails?.name = txtName.text!
            detail.userDetails?.lastName = txtLastName.text!
        }
        dailog.cartUserDetail = detail
        dailog.onClickRightButton = { vw in
            self.txtName.text = vw.txtName.text!
            self.txtLastName.text = vw.txtLastname.text!
            self.txtEmail.text = vw.txtEmail.text!
            self.txtCountryCode.text = vw.txtCode.text!
            self.txtContactNo.text = vw.txtMobileNo.text!
            self.txtAddNote.text = vw.txtEmail.text!
            vw.dismiss()
            self.wsAddItemInServerCart(next: false)
        }
    }

    func checkValidation() -> Bool {
        let validMobileNumber = txtContactNo.text!.isValidMobileNumber()

        if (txtName.text?.isEmpty())! {
            txtName.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
            return false
        } else if validMobileNumber.0 == false {
            txtContactNo.becomeFirstResponder()
            Utility.showToast(message:validMobileNumber.1)
            return false
        } else if (txtCountryCode.text?.isEmpty())! {
            txtContactNo.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_ENTER_MOBILE_NUMBER".localized)
            return false
        } else {
            return true
        }
    }

    func adjustLabel(label:UILabel) {
        label.text = "TXT_DELIVERY_DETAILS".localized + "    "
        label.sectionRound(label)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setLocalization() {
        /*Set Color*/
        txtName.textColor = UIColor.themeLightTextColor
        txtContactNo.textColor = UIColor.themeTextColor
        txtAddress.textColor = UIColor.themeLightTextColor
        txtPromoCode.textColor = UIColor.themeTextColor
        lblTotal.textColor = UIColor.themeLightTextColor
        lblUserPickupDelivery.textColor = UIColor.themeTitleColor
        txtContactNo.textColor = UIColor.themeLightTextColor
        txtAddNote.textColor = UIColor.themeLightTextColor
        txtEmail.textColor = UIColor.themeLightTextColor
        txtLastName.textColor = UIColor.themeLightTextColor
        
        txtCountryCode.textColor = UIColor.themeLightTextColor
        
        lblMobileNumber.textColor = UIColor.themeLightTextColor
        
        lblMobileNumber.text = "TXT_MOBILE_NO".localizedCapitalized
        if Utility.isTableBooking() {
            lblDetail.text = "TXT_RESERVATION_DETAILS".localized
        } else {
            lblDetail.text = "TXT_DELIVERY_DETAILS".localized
        }

        if preferenceHelper.getUserId().isEmpty() {
            self.txtCountryCode.text = currentBooking.pickupAddress[0].userDetails?.countryPhoneCode
            //txtCountryCode.textColor = UIColor.themeLightTextColor
        }else{
            txtCountryCode.text = preferenceHelper.getPhoneCountryCode()
            //txtCountryCode.textColor = UIColor.themeTextColor
        }
        
        if preferenceHelper.getUserId().isEmpty() {
            btnPlaceOrder.setTitle("TXT_LOGIN".localizedCapitalized, for: .normal)
            txtPromoCode.isUserInteractionEnabled = false
            btnApplyPromo.disable()
        } else {
            btnApplyPromo.enable()
            if Utility.isTableBooking() {
                btnPlaceOrder.setTitle("btn_complete_reservation".localizedCapitalized, for: .normal)
            } else {
                btnPlaceOrder.setTitle("TXT_PLACEORDER".localizedCapitalized, for: .normal)
            }
        }
        btnLogin.setTitle("TXT_LOGIN".localizedCapitalized, for: .normal)
        btnLogin.backgroundColor = UIColor.themeButtonBackgroundColor
        btnLogin.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        
        self.setNavigationTitle(title:"TXT_CHECKOUT".localizedCapitalized)

        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        tableForInvoice.backgroundColor = UIColor.themeViewBackgroundColor
        viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
        viewForTotal.backgroundColor = UIColor.themeViewBackgroundColor
        
        btnPlaceOrder.backgroundColor = UIColor.themeButtonBackgroundColor
        btnPlaceOrder.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        
        btnApplyPromo.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        lblContactLess.textColor = UIColor.themeTextColor
        lblContactLess.text = "TXT_CONTACT_LESS_DELIVERY".localized
        lblContactLess.font = FontHelper.textRegular()
        lblAsap.textColor = UIColor.themeTitleColor
        lblDate.textColor = UIColor.themeTextColor
        lbltime.textColor = UIColor.themeTextColor
        lblReopenAt.textColor = UIColor.red
        /* Set text */
        txtName.placeholder = "TXT_NAME".localizedCapitalized
        txtContactNo.placeholder = "TXT_MOBILE_NO".localizedCapitalized
        txtContactNo.text = preferenceHelper.getPhoneNumber()
        txtAddress.text = currentBooking.deliveryAddress
        txtAddress.isUserInteractionEnabled = false
        txtAddress.isEnabled = false
        txtCountryCode.placeholder = "txt_code".localized
        
        txtAddress.placeholder = "TXT_DELIVERY_ADDRESS".localizedCapitalized
        if Utility.isTableBooking() {
            txtAddNote.placeholder = "TXT_RESERVATION_NOTE".localizedCapitalized
        } else {
            txtAddNote.placeholder = "TXT_DELIVERY_NOTE".localizedCapitalized
        }
        
        txtAddNote.text = ""
        
        txtPromoCode.placeholder = "TXT_PROMO_CODE".localized
        btnApplyPromo.setTitle("TXT_APPLY".localized, for:UIControl.State.normal)
        
        lblTotal.text = "TXT_TOTAL".localizedCapitalized
        lblAsap.text = "TXT_APSA".localized
        
        lblUserPickupDelivery.text = "TXT_I_WILL_PICKUP_A_DELIVERY".localizedCapitalized
        lblScheduleOrder.textColor = UIColor.themeTitleColor
        lblScheduleOrder.text = "TXT_SCHEDULE_AN_ORDER".localized
        lblScheduleOrder.font = FontHelper.textRegular(size: FontHelper.medium)
        lblReopenAt.text = ""
        arrForInvoice = NSMutableArray.init()
        tableForInvoice.rowHeight = UITableView.automaticDimension
        tableForInvoice.estimatedRowHeight = 100
        /* Set Font */
        txtName.font = FontHelper.textRegular()
        txtContactNo.font = FontHelper.textRegular()
        txtAddress.font = FontHelper.textRegular()
        txtPromoCode.font = FontHelper.textRegular()
        txtAddNote.font = FontHelper.textRegular()
        txtCountryCode.font = FontHelper.textRegular()
        
        //  btnPlaceOrder.titleLabel?.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        btnApplyPromo.titleLabel?.font = FontHelper.textMedium()
        lblTotalValue.font = FontHelper.textMedium(size: 30)
        lblTotal.font = FontHelper.textRegular()
        //        lblDetail.backgroundColor = UIColor.themeSectionBackgroundColor
        lblDetail.textColor = UIColor.themeTitleColor
        lblDetail.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblAsap.font = FontHelper.textRegular(size: FontHelper.medium)
        
        lblDate.font = FontHelper.textSmall()
        lbltime.font = FontHelper.textSmall()
        lblReopenAt.font = FontHelper.textRegular()
        lblUserPickupDelivery.font = FontHelper.textRegular(size: FontHelper.medium)
        txtCountryCode.font = FontHelper.textRegular()
       
        txtContactNo.isEnabled = false
        txtCountryCode.isEnabled = false
        btnMap.isEnabled = false
        txtName.isEnabled = false
        txtAddNote.isEnabled = false
        txtEmail.isEnabled = false
        txtLastName.isEnabled = false
        
        lblWhen.textColor = UIColor.themeTitleColor
        lblWhen.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblWhen.text = "TXT_WHEN".localized
        
        self.setImageWithTint()
        btnASAPIcon.setImage(UIImage(named:"asap_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        btnScheduleIcon.setImage(UIImage(named:"schedule_gray_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        
        self.txtDate.layer.borderColor = UIColor.themeLightLineColor.cgColor
        self.txtTime.layer.borderColor = UIColor.themeLightLineColor.cgColor
        
        viewForDate.backgroundColor = UIColor.themeViewBackgroundColor
        viewForTime.backgroundColor = UIColor.themeViewBackgroundColor
        
        viewForTable.backgroundColor = UIColor.themeViewBackgroundColor
        viewForPeoples.backgroundColor = UIColor.themeViewBackgroundColor
        
        
        txtDate.layer.borderColor = UIColor.themeTextColor.cgColor
        txtDate.layer.borderWidth = 0.1
        txtDate.borderStyle = .roundedRect
        txtDate.tintColor = .themeTextColor
        txtDate.font = FontHelper.textSmall()
        txtTime.layer.borderColor = UIColor.themeTextColor.cgColor
        txtTime.layer.borderWidth = 0.1
        txtTime.borderStyle = .roundedRect
        txtTime.tintColor = .themeTextColor
        txtTime.font = FontHelper.textSmall()
        
        txtPeoples.layer.borderColor = UIColor.themeTextColor.cgColor
        txtPeoples.layer.borderWidth = 0.1
        txtPeoples.borderStyle = .roundedRect
        txtPeoples.tintColor = .themeTextColor
        txtPeoples.font = FontHelper.textSmall()
        txtTables.layer.borderColor = UIColor.themeTextColor.cgColor
        txtTables.layer.borderWidth = 0.1
        txtTables.borderStyle = .roundedRect
        txtTables.tintColor = .themeTextColor
        txtTables.font = FontHelper.textSmall()
        
        btnEditUserDetail.setTitle("TXT_EDIT".localized, for: .normal)
        btnEditUserDetail.setTitle("TXT_SAVE".localized, for: .selected)
        
        btnEditUserDetail.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        lblOffers.text = "TXT_OFFERS".localized
        lblOffers.textColor = UIColor.themeTitleColor
        lblOffers.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        
        btnOffers.setTitleColor(UIColor.themeColor, for: .normal)
        btnOffers.setTitle("txt_view_offer".localized, for: .normal)
        btnOffers.titleLabel?.font = FontHelper.textMedium(size: FontHelper.medium)

        lblTipTitle.text = "TXT_TIP".localized
        lblTipTitle.textColor = UIColor.themeTitleColor
        lblTipTitle.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblNoTip.text = "No Tip".localized
        lblTipMsg.text = "TXT_TIP_MSG".localized
        lblTipMsg.textColor = UIColor.themeLightTextColor
        lblTipMsg.font = FontHelper.textRegular()
        imgContactLess.image = UIImage(named: "contactless")?.imageWithColor(color: UIColor.themeTitleColor)

        txtAddress.tintColor = .themeTextColor
        let rect = CGRect(x: 0.0, y: 0.0, width: 20.0, height: txtAddress.frame.size.height)
        let leftView = UIView(frame: rect)
        txtAddress.leftView = leftView
        txtAddress.leftViewMode = .always

        cbPickupDelivery.setImage(UIImage(named: "unchecked_checkbox_icon"), for: .normal)
        cbPickupDelivery.setImage(UIImage(named: "checked_checkbox_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        btnPickUpIcon.setImage(UIImage(named: "pickup_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnContactLess.setImage(UIImage(named: "checked_checkbox_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)

        let bottomRect = CGRect(x: 0.0, y: txtVTip.frame.size.height-0.5, width: txtVTip.frame.size.width, height: 0.5)
        let lbl = UILabel(frame: bottomRect)
        lbl.backgroundColor = UIColor.themeTitleColor
        txtVTip.addSubview(lbl)
        btnMap.backgroundColor = .clear

        lblTotal.textAlignment = .left
        lblTotalValue.textAlignment = .left

        if Utility.isTableBooking() {
            btnEditUserDetail.isHidden = false
            viewAddress.isHidden = true

            /*
            txtContactNo.isEnabled = true
            txtCountryCode.isEnabled = true
            txtName.isEnabled = true
            txtAddNote.isEnabled = true*/
        }

        lblReservationTable.textColor = UIColor.themeColor
        lblReservationTable.text = "TXT_RESERVATION_TABLE".localized
        lblReservationTable.font = FontHelper.textRegular(size: FontHelper.medium)
        
        lblPeoples.text = "TXT_PEOPLE".localized
        lblPeoples.textColor = UIColor.themeTextColor
        lblPeoples.font = FontHelper.textSmall()

        txtPeoples.textColor = UIColor.themeTextColor
        txtPeoples.font = FontHelper.textSmall()

        lblTables.text = "TXT_TABLE".localized
        lblTables.textColor = UIColor.themeTextColor
        lblTables.font = FontHelper.textSmall()

        txtTables.textColor = UIColor.themeTextColor
        txtTables.font = FontHelper.textSmall()
        
        if !preferenceHelper.getFirstName().isEmpty() && !preferenceHelper.getLastName().isEmpty {
            txtName.text = preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName()
        } else if !preferenceHelper.getFirstName().isEmpty() {
            txtName.text = preferenceHelper.getFirstName()
        } else if !preferenceHelper.getLastName().isEmpty() {
            txtName.text = preferenceHelper.getLastName()
        }

        if currentBooking.isQrCodeScanBooking {
            lblDetail.text = "TXT_USER_DETAILS".localizedUppercase
            txtName.placeholder = "TXT_FIRST_NAME".localizedCapitalized
            txtName.text = preferenceHelper.getFirstName()
            txtLastName.text = preferenceHelper.getLastName()
            txtEmail.text = preferenceHelper.getEmail()
        }
        txtLastName.placeholder = "TXT_LAST_NAME".localizedCapitalized
        txtEmail.placeholder = "TXT_EMAIL".localizedCapitalized
    }

    func setupLayout() {
        viewDateIcon.setRound(withBorderColor: UIColor.themeTextColor, andCornerRadious: 3.0, borderWidth: 0.1)
        viewTimeIcon.setRound(withBorderColor: UIColor.themeTextColor, andCornerRadious: 3.0, borderWidth: 0.1)
        
        viewForPeoplesIcon.setRound(withBorderColor: UIColor.themeTextColor, andCornerRadious: 3.0, borderWidth: 0.1)
        viewForTableIcon.setRound(withBorderColor: UIColor.themeTextColor, andCornerRadious: 3.0, borderWidth: 0.1)
        
        viewNoTip.applyRoundedCornersWithHeight()
        viewTip5.applyRoundedCornersWithHeight()
        viewTip10.applyRoundedCornersWithHeight()
        viewTip15.applyRoundedCornersWithHeight()
    }

    override func updateUIAccordingToTheme() {
        viewForDate.backgroundColor = UIColor.themeViewBackgroundColor
        viewForTime.backgroundColor = UIColor.themeViewBackgroundColor
        self.setBackBarItem(isNative: true)
        setImageWithTint()
    }

    func setImageWithTint() {
        btnASAPIcon.setImage(UIImage(named:"asap_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnScheduleIcon.setImage(UIImage(named:"schedule_gray_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        cbPickupDelivery.setImage(UIImage(named: "unchecked_checkbox_icon"), for: .normal)
        cbPickupDelivery.setImage(UIImage(named: "checked_checkbox_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        btnPickUpIcon.setImage(UIImage(named: "pickup_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        imgContactLess.image = UIImage(named: "contactless")?.imageWithColor(color: UIColor.themeTitleColor)
    }

    func setUIAccordingToTipSelection() {
        if currentBooking.tip_type == TIP_TYPE.TIP_TYPE_PERCENTAGE {
            self.lblTip5.text = "5%"
            self.lblTip10.text = "10%"
            self.lblTip15.text = "15%"
            self.txtVTip.placeholder = "%"
        } else {
            self.lblTip5.text = "5\(currentBooking.cartCurrency)"
            self.lblTip10.text = "10\(currentBooking.cartCurrency)"
            self.lblTip15.text = "15\(currentBooking.cartCurrency)"
            self.txtVTip.placeholder = "\(currentBooking.cartCurrency)"
        }

        if selectedTipInd == 0 {
            tipValue = 0
            self.viewNoTip.backgroundColor = UIColor.themeSectionBackgroundColor
            self.viewTip5.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip10.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip15.backgroundColor = UIColor.themeLightBackgroundColor
            self.txtVTip.tintColor = .themeTitleColor
            self.lblTip5.textColor = .black
            self.lblTip10.textColor = .black
            self.lblTip15.textColor = .black
            self.lblNoTip.textColor = .white
        } else if selectedTipInd == 1 {
            tipValue = 5
            self.viewNoTip.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip5.backgroundColor = UIColor.themeSectionBackgroundColor
            self.viewTip10.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip15.backgroundColor = UIColor.themeLightBackgroundColor
            self.txtVTip.tintColor = .themeTitleColor
            self.lblTip5.textColor = .white
            self.lblTip10.textColor = .black
            self.lblTip15.textColor = .black
            self.lblNoTip.textColor = .black
        } else if selectedTipInd == 2 {
            tipValue = 10
            self.viewNoTip.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip5.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip10.backgroundColor = UIColor.themeSectionBackgroundColor
            self.viewTip15.backgroundColor = UIColor.themeLightBackgroundColor
            self.txtVTip.tintColor = .themeTitleColor
            self.lblTip5.textColor = .black
            self.lblTip10.textColor = .white
            self.lblTip15.textColor = .black
            self.lblNoTip.textColor = .black
        } else if selectedTipInd == 3 {
            tipValue = 15
            self.viewNoTip.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip5.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip10.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip15.backgroundColor = UIColor.themeSectionBackgroundColor
            self.txtVTip.tintColor = .themeTitleColor
            self.lblTip5.textColor = .black
            self.lblTip10.textColor = .black
            self.lblTip15.textColor = .white
            self.lblNoTip.textColor = .black
        } else {
            if self.tipEntered > 0 {
                tipValue = abs(self.tipEntered)
            } else {
                tipValue = 0
            }
            self.viewNoTip.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip5.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip10.backgroundColor = UIColor.themeLightBackgroundColor
            self.viewTip15.backgroundColor = UIColor.themeLightBackgroundColor
            self.txtVTip.textColor = UIColor.themeTextColor
            self.lblTip5.textColor = .black
            self.lblTip10.textColor = .black
            self.lblTip15.textColor = .black
            self.lblNoTip.textColor = .black
        }
    }

    func getSelectedTipIndFromTipValue(tipValue:Int)-> Int {
        switch tipValue {
            case 0:
                return 0
            case 5:
                return 1
            case 10:
                return 2
            case 15:
                return 3
            default:
                return 4
        }
    }

    func setTipViewVisibilty() {
        if currentBooking.isAllowUserToGiveTip{
            if currentBooking.isUserPickUpOrder{
                self.viewTip.isHidden = true
                return
            }
            self.viewTip.isHidden = !currentBooking.isAllowUserToGiveTip
        } else {
            self.viewTip.isHidden = true
        }
    }

    func updatePlaceOrderTitle(strTotal: String)  {
        if preferenceHelper.getUserId().isEmpty() {
            btnPlaceOrder.setTitle("TXT_LOGIN".localizedCapitalized, for: .normal)
        } else {
            if Utility.isTableBooking() {
                btnPlaceOrder.setTitle("btn_complete_reservation".localizedCapitalized, for: .normal)
            } else {
                self.btnPlaceOrder.setTitle(strTotal, for: .normal)
            }
        }
    }

    func hideDetailsWhenTableReservation() {
        if Utility.isTableBooking() {
            self.viewForAsap.isHidden = true
            self.viewForSchedule.isHidden = true
            self.viewForDateAndTime.isHidden = false
            self.viewForPickupDelivery.isHidden = true
            self.viewContactLess.isHidden = true
            self.viewTip.isHidden = true
            self.viewForNumberOfPeoples.isHidden = false
            self.viewForTable.isHidden = false
            self.viewForTableReservation.isHidden = false
            self.viewForPromoCode.isHidden = currentBooking.bookingType == 1
        } else {
            self.viewForNumberOfPeoples.isHidden = true
            self.viewForTableReservation.isHidden = true
        }
    }

    func hideDetailsWhenQrCodeTableReservation() {
        if currentBooking.isQrCodeScanBooking == true {
            self.viewForAsap.isHidden = false
            self.viewForSchedule.isHidden = true
            self.viewForDateAndTime.isHidden = true
            self.viewForPickupDelivery.isHidden = true
            self.viewContactLess.isHidden = true
            self.viewTip.isHidden = true
            self.viewForNumberOfPeoples.isHidden = true
            self.viewForTable.isHidden = true
            self.viewForTableReservation.isHidden = true
            self.viewForPromoCode.isHidden = false

            btnEditUserDetail.isHidden = false
            txtLastName.isHidden = false
            txtEmail.isHidden = false
            viewAddress.isHidden = true
            txtAddNote.isHidden = true
            
            /*
            txtContactNo.isEnabled = true
            txtCountryCode.isEnabled = true
            txtName.isEnabled = true
            txtAddNote.isEnabled = true*/

            btnPlaceOrder.setTitle("TXT_PLACEORDER".localizedCapitalized, for: .normal)
        } else {
            self.viewForNumberOfPeoples.isHidden = true
            self.viewForTableReservation.isHidden = true
        }
    }

    //MARK: - TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "TXT_ORDER_DETAILS".localized
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableForInvoice == tableView {
            let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! InvoiceSection
            sectionHeader.setData(title:"TXT_INVOICE".localized,isShowImage: isFreeDelivery)
            return sectionHeader
        } else {
            return UIView.init()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForInvoice.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:InvoiceCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InvoiceCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentInvoiceItem:Invoice = arrForInvoice.object(at: indexPath.row) as! Invoice
        cell.setCellData(cellItem: currentInvoiceItem)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  60 //35
    }

    func openMinAmountDialog(amount:String) {
        let minAmountMessage:String = "TXT_MIN_INVOICE_AMOUNT_MSG".localized + amount
        let dialogForMinAmount = CustomAlertDialog.showCustomAlertDialog(title: "TXT_MIN_AMOUNT".localized, message: minAmountMessage, titleLeftButton: "", titleRightButton: "TXT_ADD_MORE_ITEMS".localizedUppercase)
        dialogForMinAmount.onClickLeftButton = {
            [unowned dialogForMinAmount] in
            dialogForMinAmount.removeFromSuperview()
        }
        dialogForMinAmount.onClickRightButton = {
            [unowned self,unowned dialogForMinAmount] in
            dialogForMinAmount.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK: - USER DEFINE FUNCTION
    func getTableList(numberOfPerson:Int) {
        arrAvailabletable.removeAll()
        for table:Table_list in currentBooking.tableList {
            if numberOfPerson >= table.table_min_person ?? 0 && numberOfPerson <= table.table_max_person ?? 0 && table.is_user_can_book ?? false && table.is_bussiness ?? false {
                arrAvailabletable.append(table)
            }
        }
    }
    
    func setQrCodeScanBooking() {
        if currentBooking.isQrCodeScanBooking {
            for table in currentBooking.tableList {
                if currentBooking.tableID == table._id ?? "" {
                    currentBooking.table_no = table.table_no ?? 0
                    currentBooking.number_of_pepole = table.table_max_person ?? 0
                    break
                }
            }
        }
    }

    @objc func handleTapOnASAP() {
        self.onClickBtnAsap(btnASAP)
    }

    @objc func handleTapOnSchedule() {
        self.onClickBtnSchedualOrder(btnScheduleOrder)
    }

    //MARK: - ACTION METHODS
    @IBAction func onClickBtnViewOffers(_ sender: Any) {
        wsGetStoreOffers()
    }

    @IBAction func onClickCbPickupDelivery(_ sender: Any) {
        lblReopenAt.text = ""
        cbPickupDelivery.isSelected = !cbPickupDelivery.isSelected
        currentBooking.isUserPickUpOrder = cbPickupDelivery.isSelected

        self.tipValue = 0

        if currentBooking.isUserPickUpOrder {
            stkAddress.isHidden = true
            txtAddNote.isHidden = true
            viewContactLess.isHidden = true
            btnContactLess.isSelected = false
            currentBooking.isContactLessDelivery = false
        } else {
            stkAddress.isHidden = false
            txtAddNote.isHidden = false
            viewContactLess.isHidden = currentBooking.isAllowContactLessDelivery
        }

        if btnEditUserDetail.isSelected {
            btnMap.isEnabled = !currentBooking.isUserPickUpOrder
        } else {
            btnMap.isEnabled = false
        }
        prepareInvoicePARAMS(isFromTipApplied: false)
    }

    @IBAction func onClickPlaceOrder(_ sender: Any) {
        if preferenceHelper.getUserId().isEmpty() && currentBooking.isQrCodeScanBooking == false {
            APPDELEGATE.goToHome()
        } else {
            if Utility.isTableBooking() {
                if self.txtTables.text!.isEmpty {
                    Utility.showToast(message: "error_choose_table_number".localized)
                } else if self.txtDate.text!.isEmpty || self.txtTime.text!.isEmpty {
                    Utility.showToast(message: "MSG_PLEASE_SELECT_VALID_DATE".localized)
                } else {
                    if (storeOpen.0) {
                        self.wsAddItemInServerCart(next: true)
                    } else {
                        let strMsg:String = self.storeOpen.1
                        lblReopenAt.text = strMsg
                        lblReopenAt.isHidden = false
                    }
                }
            } else if currentBooking.isQrCodeScanBooking {
                if (storeOpen.0) {
                    self.wsAddItemInServerCart(next: true)
                } else {
                    let strMsg:String = self.storeOpen.1
                    lblReopenAt.text = strMsg
                    lblReopenAt.isHidden = false
                }
            } else {
                if currentBooking.isFutureOrder && txtDate.text == "" {
                    Utility.showToast(message: "MSG_PLEASE_SELECT_VALID_DATE".localized)
                } else if !currentBooking.isFutureOrder && btnScheduleOrder.isSelected {
                    Utility.showToast(message: "MSG_PLEASE_SELECT_VALID_DATE".localized)
                } else {
                    if !isTakingScheduleOrder && currentBooking.isFutureOrder {
                        Utility.showToast(message: "MSG_SELECTED_STORE_DOES_NOT_ACCEPT_SCHEDULE_ORDER".localized)
                    } else {
                        if (storeOpen.0) {
                            currentBooking.isHidePayNow = false
                            currentBooking.deliveryName = txtName.text ?? ""
                            currentBooking.deliveryContact = txtContactNo.text ?? ""
                            if currentBooking.deliveryName.isEmpty() {
                                txtName.becomeFirstResponder()
                                Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
                            } else if currentBooking.deliveryContact.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty() {
                                txtContactNo.becomeFirstResponder()
                                Utility.showToast(message:"MSG_PLEASE_ENTER_MOBILE_NUMBER".localized)
                            } else if btnEditUserDetail.isSelected {
                                Utility.showToast(message:"MSG_UPDATE_DETAIL".localized)
                            } else {
                                if let store = self.selectedStore {
                                    openDeliveryPriceConfirmationDialog()
                                } else {
                                    openChangeAddressDialog()
                                }
                            }
                        } else {
                            let strMsg:String = self.storeOpen.1
                            lblReopenAt.text = strMsg
                            lblReopenAt.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        APPDELEGATE.goToHome()
    }
    
    func qrCodePlaceOrder() {
        let validMobileNumber = txtContactNo.text!.isValidMobileNumber()
        let validEmail = txtEmail.text!.checkEmailValidation()
        
        if (txtName.text?.isEmpty())! {
            Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_NAME".localized)
        } else if (txtLastName.text?.isEmpty() ?? true) {
            Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_NAME".localized)
        } else if (txtCountryCode.text?.isEmpty())! && !currentBooking.isQrCodeScanBooking  {
            Utility.showToast(message:"MSG_TXT_PLEASE_ENTER_VALID_MOBILE_NUMBER".localized)
        } else if validMobileNumber.0 == false && txtContactNo.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            Utility.showToast(message:validMobileNumber.1)
        } else if validEmail.0 == false && txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            Utility.showToast(message: validEmail.1)
        } else {
            wsRegisterUserWithoutCred()
        }
    }

    func openChangeAddressDialog() {
        let deliveryRadiousMsg : String = "ERROR_CODE_967".localized
        let dialogForMinAmount = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: deliveryRadiousMsg, titleLeftButton: "", titleRightButton: "TXT_CHANGE_ADDRESS".localized)
        dialogForMinAmount.btnRight.isHidden = true
        dialogForMinAmount.onClickLeftButton = { [unowned self,unowned dialogForMinAmount] in
            dialogForMinAmount.removeFromSuperview()
            self.btnEditUserDetail.isSelected = false
            self.onClickBtnEditUserData(self.btnEditUserDetail)
        }
        dialogForMinAmount.onClickRightButton = { [unowned self] in
            dialogForMinAmount.removeFromSuperview()
            self.btnEditUserDetail.isSelected = false
            self.onClickBtnEditUserData(self.btnEditUserDetail)
        }
    }

    func providerDeliveryDistanceValidation() {
        if let store = self.selectedStore {
            if cbPickupDelivery.isSelected || store.isProvideDelivryAnywhere {
                openDeliveryPriceConfirmationDialog()
            } else {
                let storeLatlong = currentBooking.storeLatLng
                let deliveryLatlong = currentBooking.deliveryLatLng
                let distance:Int = Utility.distance(lat1: storeLatlong[0], lon1: storeLatlong[1], lat2: deliveryLatlong[0], lon2: deliveryLatlong[1], isUnitKiloMeter: self.unitIsKilometer)
                if store.delivryRadious >= Double(distance) {
                    if checkValidation() {
                        openDeliveryPriceConfirmationDialog()
                    }
                } else {
                    opentChangeAddressDialog()
                }
            }
        }
    }

    func opentChangeAddressDialog() {
        let deliveryRadiousMsg : String = "ERROR_CODE_967".localized
        if (selectedStore?.isProvidePickupDelivery)! {
            let dialogForMinAmount = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: deliveryRadiousMsg, titleLeftButton: "TXT_CHANGE_ADDRESS".localized, titleRightButton: "TXT_I_WILL_PICKUP".localizedUppercase)
            dialogForMinAmount.onClickLeftButton = { [unowned self,unowned dialogForMinAmount] in
                dialogForMinAmount.removeFromSuperview()
                self.btnEditUserDetail.isSelected = false
                self.onClickBtnEditUserData(self.btnEditUserDetail)
            }
            dialogForMinAmount.onClickRightButton = { [unowned self,unowned dialogForMinAmount] in
                dialogForMinAmount.removeFromSuperview()
                self.cbPickupDelivery.isSelected = false
                self.onClickCbPickupDelivery(self.cbPickupDelivery)
            }
        } else {
            let dialogForMinAmount = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: deliveryRadiousMsg, titleLeftButton: "TXT_CHANGE_ADDRESS".localized, titleRightButton: "")
            dialogForMinAmount.onClickLeftButton = { [unowned self,unowned dialogForMinAmount] in
                dialogForMinAmount.removeFromSuperview()
                self.btnEditUserDetail.isSelected = false
                self.onClickBtnEditUserData(self.btnEditUserDetail)
            }
            dialogForMinAmount.onClickRightButton = { [unowned self] in
                self.btnEditUserDetail.isSelected = false
                self.onClickBtnEditUserData(self.btnEditUserDetail)
            }
        }
    }

    func openDeliveryPriceConfirmationDialog() {
        if vehicleName.isEmpty() || currentBooking.isUserPickUpOrder {
            currentBooking.isCourier = false
            self.performSegue(withIdentifier: SEGUE.SEGUE_PAYMENT, sender: self)
        } else {
            let deliveryPriceMsg :String = String(format: NSLocalizedString("MSG_DELIVERY_PRICE_CONFIRM", comment: ""),vehicleName)
            let dialogForConfirmDeliveryPrice = CustomAlertDialog.showCustomAlertDialog(title: "TXT_CONFIRM_DELIVERY_PRICE".localized, message: deliveryPriceMsg, titleLeftButton: "".localized, titleRightButton: "TXT_OK".localizedCapitalized)
            dialogForConfirmDeliveryPrice.onClickLeftButton = { [unowned dialogForConfirmDeliveryPrice] in
                dialogForConfirmDeliveryPrice.removeFromSuperview()
            }
            dialogForConfirmDeliveryPrice.onClickRightButton = { [unowned self,unowned dialogForConfirmDeliveryPrice] in
                dialogForConfirmDeliveryPrice.removeFromSuperview()
                currentBooking.isCourier = false
                self.performSegue(withIdentifier: SEGUE.SEGUE_PAYMENT, sender: self)
            }
        }
    }

    func openOffersDialog(arrPromoCodes:Array<PromoCodeModal>)  {
        let dialogOfferList = CustomOffersDialog.showOffers(title: "Offers", message: "", arrPromoCodes: arrPromoCodes, isFromHome: false)
        dialogOfferList.onClickLeftButton = {
            dialogOfferList.removeFromSuperview()
        }
        dialogOfferList.onClickApply = {
            (promoName) in
            dialogOfferList.removeFromSuperview()
            self.txtPromoCode.text = promoName
            self.handleOffersSelection()
        }
    }

    func finalAddressAndLocation(address: String, latitude: Double, longitude: Double) {
        self.txtAddress.text = currentBooking.deliveryAddress
        self.prepareInvoicePARAMS(isFromTipApplied: false)
        self.wsAddItemInServerCart()
    }
    
    func didSetUserDetail(name: String, countryCode: String, phone: String, note: String) {
        txtName.text = name
        txtCountryCode.text = countryCode
        txtContactNo.text = phone
        txtAddNote.text = note
    }

    @IBAction func searching(_ sender: UITextField) {
        if (sender.text?.count)! > 2 {}
    }

    @IBAction func onClickBtnPromo(_ sender: Any) {
        let duration = 0.5
        self.txtPromoCode.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            if preferenceHelper.getUserId().isEmpty() {
                Utility.showToast(message: "MSG_PROMO_ERROR".localizedLowercase)
            } else {
                if (self.txtPromoCode.text?.count)! < 1 {
                    Utility.showToast(message: "MSG_ENTER_PROMOCODE".localized)
                } else {
                    self.wsCheckPromo()
                }
            }
        }
    }

    func handleOffersSelection()  {
        let duration = 0.5
        self.txtPromoCode.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            if preferenceHelper.getUserId().isEmpty() {
                Utility.showToast(message: "MSG_PROMO_ERROR".localizedLowercase)
            } else {
                if (self.txtPromoCode.text?.count)! < 1 {
                    Utility.showToast(message: "MSG_ENTER_PROMOCODE".localized)
                } else {
                    self.wsCheckPromo()
                }
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtVTip {
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            return string.rangeOfCharacter(from: invalidCharacters) == nil
        } else {
            return true
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
        if textField == txtVTip {
            if textField.text!.count == 0 {
                selectedTipInd = 0
                tipEntered = 0
            } else {
                selectedTipInd = 4
                if currentBooking.tip_type == TIP_TYPE.TIP_TYPE_PERCENTAGE {
                    if ((textField.text?.contains("%")) != nil) {
                        if textField.text!.replacingOccurrences(of: "%", with: "").count > 0 {
                            tipEntered = textField.text!.replacingOccurrences(of: "%", with: "").integerValue!
                        } else {
                            tipEntered = 0
                        }
                    } else {
                        tipEntered = textField.text!.integerValue!
                    }
                } else {
                    tipEntered = textField.text!.replacingOccurrences(of: "\(currentBooking.cartCurrency)", with: "").integerValue!
                }
            }
            self.setUIAccordingToTipSelection()
            if tipEntered > 0 {
                self.tipValue = abs(tipEntered)
            }

            self.txtVTip.text = currentBooking.tip_type == TIP_TYPE.TIP_TYPE_PERCENTAGE ? "\(tipEntered)%" : "\(tipEntered)\(currentBooking.cartCurrency)"
            self.prepareInvoicePARAMS(isFromTipApplied: true)
        }

        if textField == txtContactNo {
            let validMobileNumber = txtContactNo.text!.isValidMobileNumber()
            if validMobileNumber.0 == false {
                self.txtContactNo.text = ""
                Utility.showToast(message: validMobileNumber.1)
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtVTip {
            selectedTipInd = 4
            setUIAccordingToTipSelection()
        }

        if textField == txtCountryCode {
            txtCountryCode.textColor = UIColor.themeTextColor
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtCountryCode.becomeFirstResponder()
        } else if textField == txtCountryCode {
            txtContactNo.becomeFirstResponder()
        } else if textField == txtContactNo {
            txtAddNote.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    //MARK: - NAVIGATION METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.compare(SEGUE.SEGUE_STORE_LIST) == ComparisonResult.orderedSame) {
        } else if (segue.identifier?.compare(SEGUE.SEGUE_PAYMENT) == ComparisonResult.orderedSame) {
            let _ = segue.destination as! PaymentVC
        } else {}
    }

    //MARK: - WEB SERVICE
    func getTimeAndDistance(srcLat:Double, srcLong:Double, destLat:Double, destLong:Double)->(String,String) {
        var timeAndDistance:(time:String, distance:String)
        timeAndDistance.time = "0"
        timeAndDistance.distance = "0"
        let src_lat: String = String(srcLat)
        let src_long: String = String(srcLong)
        let dest_lat: String = String(destLat)
        let dest_long: String = String(destLong)

        let request = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(src_lat),\(src_long)&destinations=\(dest_lat),\(dest_long)&key=\(Google.API_KEY)")

        let parseData = parseJSON(inputData: getJSON(urlToRequest: request!))

        let googleRsponse: GoogleDistanceMatrixResponse = GoogleDistanceMatrixResponse(dictionary:parseData)!
        if ((googleRsponse.status?.compare("OK")) == ComparisonResult.orderedSame) {
            timeAndDistance.time = String((googleRsponse.rows?[0].elements?[0].duration?.value) ?? 0)
            timeAndDistance.distance = String((googleRsponse.rows?[0].elements?[0].distance?.value) ?? 0)
        }
        return timeAndDistance
    }

    func getJSON(urlToRequest:URL) -> Data {
        var content:Data?
        do {
            content = try Data(contentsOf:urlToRequest)
        }
        catch let error {
            printE(error)
        }
        return content ?? Data.init()
    }

    func parseJSON(inputData:Data) -> NSDictionary {
        if inputData.count > 0 {
            let dictData = (try! JSONSerialization.jsonObject(with: inputData, options: .mutableContainers)) as! NSDictionary
            return dictData
        } else {
            return NSDictionary()
        }
    }

    func wsGetInvoice(dictParam:Dictionary<String,Any>, isCallApplyPromo: Bool) {
        Utility.showLoading()
        print(Utility.convertDictToJson(dict: dictParam))

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_CART_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            print("WS_GET_CART_INVOICE response ---> \(response)")
            if Parser.isSuccess(response: response) {
                let invoiceResponse:InvoiceResponse = InvoiceResponse.init(dictionary: response)!
                self.selectedStore = invoiceResponse.store
                currentBooking.currentServerTime = invoiceResponse.serverTime
                self.selectedStoreTime = (invoiceResponse.store?.store_time)!
                self.selectedStoreSlotTime = (invoiceResponse.store?.store_delivery_time)!

                currentBooking.selectedStore?.timezone = invoiceResponse.timeZone
                currentBooking.isContactLessDelivery = false
                currentBooking.isAllowContactLessDelivery = invoiceResponse.isAllowContactlessDelivery
                currentBooking.isAllowUserToGiveTip = invoiceResponse.isAllowUserToGiveTip
                currentBooking.tip_type = invoiceResponse.tip_type

                self.timeZone = TimeZone.init(identifier:invoiceResponse.timeZone)!
                self.viewContactLess.isHidden = (self.selectedStore?.isProvidePickupDelivery)! ? true :  !invoiceResponse.isAllowContactlessDelivery
                self.btnContactLess.isSelected = false
                currentBooking.isContactLessDelivery = false
                currentBooking.currentDateMilliSecond = Utility.convertServerDateToMilliSecond(serverDate:currentBooking.currentServerTime , strTimeZone: self.timeZone.identifier)
                self.isFreeDelivery = (invoiceResponse.order_payment?.is_store_pay_delivery_fees)!
                self.viewForPickupDelivery.isHidden = !(self.selectedStore?.isProvidePickupDelivery)!
                self.vehicleName = ""
                if invoiceResponse.vehicles.isEmpty {
                } else {
                    self.vehicleName = invoiceResponse.vehicles[0].vehicleName
                }

                self.isTakingScheduleOrder = (invoiceResponse.store?.is_taking_schedule_order) ?? false
                self.viewForSchedule.isHidden = !self.isTakingScheduleOrder
                
                if self.btnScheduleOrder.isSelected && self.viewForSchedule.isHidden {
                    self.viewForDateAndTime.isHidden = true
                }
                self.isShowSlots = (invoiceResponse.store?.is_store_set_schedule_delivery_time) ?? false
                if self.cbPickupDelivery.isSelected && currentBooking.isFutureOrder{
                    self.storeOpen = Utility.isStoreOpen(storeTime: self.selectedStoreTime,milliSeconds: currentBooking.futureDateMilliSecond)
                } else {
                    if currentBooking.isFutureOrder && self.lblDate.text != "TXT_DATE".localized && self.lbltime.text != "TXT_TIME".localized{
                        if Utility.isStoreOpen(storeTime: self.selectedStoreTime,milliSeconds: currentBooking.futureDateMilliSecond).0 == true{
                            self.storeOpen = Utility.isStoreOpenForSchedule(storeTime: self.selectedStoreSlotTime,milliSeconds: currentBooking.futureDateMilliSecond,is_store_set_schedule_delivery_time: self.isShowSlots)
                        } else {
                            self.storeOpen = Utility.isStoreOpen(storeTime: self.selectedStoreTime,milliSeconds: currentBooking.futureDateMilliSecond)
                        }
                    } else if self.cbPickupDelivery.isSelected {
                        self.storeOpen = Utility.isStoreOpen(storeTime:self.selectedStoreTime,milliSeconds: currentBooking.currentDateMilliSecond)
                    } else if !currentBooking.isFutureOrder {
                        self.storeOpen = Utility.isStoreOpen(storeTime:self.selectedStoreTime,milliSeconds: currentBooking.currentDateMilliSecond)
                    }
                }
                self.unitIsKilometer = !(invoiceResponse.order_payment?.is_distance_unit_mile ?? true)
                self.setTipViewVisibilty()
                
                self.selectedTipInd = self.getSelectedTipIndFromTipValue(tipValue: invoiceResponse.order_payment!.tip_value ?? 0)
                self.setUIAccordingToTipSelection()
                
                Parser.parseInvoice(invoiceResponse.order_payment!, toArray: self.arrForInvoice, isTaxIncluded: invoiceResponse.isTaxIncluded, completetion: { (result) in
                    if (result) {
                        self.tableForInvoice?.reloadData()
                        self.lblTotalValue.text = currentBooking.cartCurrency + " " +  (PaymentConfig.shared.total).toString()
                        let strTotal = String(format:"%@-%@","TXT_PLACEORDER".localizedCapitalized, self.lblTotalValue.text ?? "")
                        self.updatePlaceOrderTitle(strTotal: strTotal)
                        self.heightForTableInvoice.constant = self.tableForInvoice.contentSize.height
                    }
                })
                if isCallApplyPromo{
                    self.wsCheckPromo()
                } else {
                    Utility.hideLoading()
                }
                
                if let invoiceStore = invoiceResponse.store {
                    if invoiceStore.isProvidePickupDelivery && !invoiceStore.is_provide_delivery {
                        self.lblReopenAt.text = ""
                        self.cbPickupDelivery.isSelected = true
                        self.viewForPickupDelivery.isUserInteractionEnabled = false
                        currentBooking.isUserPickUpOrder = self.cbPickupDelivery.isSelected

                        self.tipValue = 0
                        
                        self.stkAddress.isHidden = true
                        self.txtAddNote.isHidden = true
                        self.viewContactLess.isHidden = currentBooking.isAllowContactLessDelivery

                        if self.btnEditUserDetail.isSelected {
                            self.btnMap.isEnabled = !currentBooking.isUserPickUpOrder
                        } else {
                            self.btnMap.isEnabled = false
                        }
                    }
                }
                
            } else {
                let isSuccess:IsSuccessResponse = IsSuccessResponse.init(dictionary: response)!
                if isSuccess.errorCode! == CONSTANT.ERROR_MINMUM_INVOICE_AMOUNT {
                    let minAmount = (response.value(forKey: PARAMS.MIN_ORDER_PRICE) as? Double)?.roundTo() ?? 0.0
                    self.openMinAmountDialog(amount:String(minAmount))
                } else if isSuccess.errorCode! == 967 {
                    self.selectedStore = nil
                    self.openChangeAddressDialog()
                } else if isSuccess.errorCode! == 968 {
                    Utility.showLoading()
                    self.wsClearCart()
                } else {
                    self.selectedStore = nil
                }
            }
            self.hideDetailsWhenTableReservation()
            self.hideDetailsWhenQrCodeTableReservation()
        }
    }

    func wsClearCart() {
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.CART_ID] = currentBooking.cartId

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_CLEAR_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading()
            currentBooking.clearCart()
            currentBooking.clearTableBooking()
            if Utility.isTableBooking() {
                APPDELEGATE.goToMain()
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    @IBAction func onClickBtnAddress(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard.init(name: "MainStoryboard", bundle: nil)
        let locationVC : CartLocationVC = storyBoard.instantiateViewController(withIdentifier: "cartLocationVC") as! CartLocationVC
        locationVC.delegate = self
        locationVC.userDetail = getDestinationAddress()
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    func getDestinationAddress() -> Address {
        let destinationAddress:Address = Address.init()
        destinationAddress.address = currentBooking.deliveryAddress
        destinationAddress.addressType = AddressType.DESTINATION
        destinationAddress.userType = CONSTANT.TYPE_USER
        destinationAddress.note = txtAddNote.text ?? ""
        destinationAddress.city = currentBooking.currentSendPlaceData.city1
        destinationAddress.location = currentBooking.deliveryLatLng
        destinationAddress.flat_no = currentBooking.currentSendPlaceData.flat_no
        destinationAddress.street = currentBooking.currentSendPlaceData.street
        destinationAddress.landmark = currentBooking.currentSendPlaceData.landmark

        let cartUserDetail:CartUserDetail = CartUserDetail()
        cartUserDetail.email = preferenceHelper.getEmail()
        cartUserDetail.countryPhoneCode = txtCountryCode.text
        cartUserDetail.name = txtName.text
        cartUserDetail.phone = txtContactNo.text
        destinationAddress.userDetails = cartUserDetail
        
        return destinationAddress
    }

    var selectedDayInd : Int = 0
    var selectedDateStr : String = ""

    @IBAction func onClickBtnDate(_ sender: UITapGestureRecognizer) {
        lblReopenAt.isHidden = true
        self.isShowSlots = true // This is because we want to open slot date picker everywhere.
        if !self.isShowSlots && !Utility.isTableBooking() {
            let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_FUTURE_ORDER_TIME".localized, titleLeftButton: "".localized, titleRightButton: "TXT_SELECT".localized,mode: .dateAndTime)
            datePickerDialog.datePicker.locale = Locale(identifier: "en_GB")
            datePickerDialog.datePicker.timeZone = self.timeZone
            datePickerDialog.setMinDate(mindate: Date().addingTimeInterval((self.selectedStore?.schedule_order_create_after_minute ?? 0)*60))
            datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
            }
            datePickerDialog.onClickRightButton = { [unowned self,unowned datePickerDialog] (selectedDate:Date) in
                _ = Calendar.current
                currentBooking.futureDateMilliSecond = Utility.convertSelectedDateToMilliSecond(serverDate: selectedDate, strTimeZone: self.timeZone.identifier)
                let offSetMiliSecond = self.timeZone.secondsFromGMT() * 1000
                currentBooking.isFutureOrder = true
                currentBooking.futureUTCMilliSecond = currentBooking.futureDateMilliSecond - Int64.init(offSetMiliSecond)

                let components = Calendar.current.dateComponents(in: self.timeZone, from: selectedDate)
                self.txtDate.text = String(components.day!)  +  "-" + String(components.month!) +  "-" +  String(components.year!)
                self.txtTime.text = String(components.hour!) +  "-" + String(components.minute!)
                self.storeOpen = Utility.isStoreOpen(storeTime: self.selectedStoreTime,milliSeconds: currentBooking.futureDateMilliSecond)

                datePickerDialog.removeFromSuperview()
            }
        } else {
            if sender.view?.tag == 0 {
                let datePickerDialog:CustomDateSlotPickerDialog = CustomDateSlotPickerDialog.showCustomDatePickerSlotDialog(title: "TXT_SELECT_FUTURE_ORDER_DATE".localized, titleLeftButton: "".localized, titleRightButton: "TXT_SELECT".localized, mode: .date, reservationMaxDays: Utility.isTableBooking() ? self.selectedStore?.table_setting_details?.reservation_max_days ?? 7 : 7)
                datePickerDialog.onClickLeftButton = {
                    [unowned datePickerDialog] in
                    datePickerDialog.removeFromSuperview()
                }
                datePickerDialog.onClickRightButton = { [unowned datePickerDialog] (selectedDate:String, selectedDayInd:Int) in
                    self.selectedDateStr = selectedDate
                    self.selectedDayInd = selectedDayInd
                    datePickerDialog.removeFromSuperview()

                    if Utility.isTableBooking() {
                        self.selectedStoreSlotTime = self.responseFetchStoreSetting?.storeData?.booking_time ?? []
                        if self.selectedStoreSlotTime.count-1 >= self.selectedDayInd {
                            if !self.selectedStoreSlotTime[self.selectedDayInd].is_booking_open_full_time {
                                if self.selectedStoreSlotTime[self.selectedDayInd].dayTime.count > 0 && self.selectedStoreSlotTime[self.selectedDayInd].is_booking_open {
                                    self.showCustomDialogTime(ind: self.selectedDayInd)
                                } else {
                                    Utility.showToast(message: "MSG_NO_TIME_SLOT".localized)
                                    self.onClickBtnAsap(UIButton())
                                }
                            } else {
                                self.showCustomDialogTime(ind: self.selectedDayInd)
                            }
                        }
                    } else {
                        if self.selectedStoreSlotTime.count-1 >= self.selectedDayInd {
                            if !self.selectedStoreSlotTime[self.selectedDayInd].isStoreOpenFullTime {
                                if self.selectedStoreSlotTime[self.selectedDayInd].dayTime.count > 0 && self.selectedStoreSlotTime[self.selectedDayInd].isStoreOpen {
                                    self.showCustomDialogTime(ind: self.selectedDayInd)
                                } else {
                                    Utility.showToast(message: "MSG_NO_TIME_SLOT".localized)
                                    self.onClickBtnAsap(UIButton())
                                }
                            } else {
                                self.showCustomDialogTime(ind: self.selectedDayInd)
                            }
                        }
                    }
                }
            } else {
                if Utility.isTableBooking() {
                    self.selectedStoreSlotTime = self.responseFetchStoreSetting?.storeData?.booking_time ?? []
                }
                self.showCustomDialogTime(ind: self.selectedDayInd)
            }
        }
    }

    @IBAction func onClickBtnPeople(_ sender: UITapGestureRecognizer) {
        let datePickerDialog: CustomPickerDialog = CustomPickerDialog.showCustomPickerDialog(title: "Select Number Of Peoples", titleLeftButton: "", titleRightButton: "TXT_SELECT".localized, isPeople: true)
        datePickerDialog.onClickLeftButton = {
            [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog] (selectedPeoples:Int) in
            self.txtPeoples.text = String(selectedPeoples)
            self.txtTables.text = ""
            datePickerDialog.removeFromSuperview()
        }
    }

    @IBAction func onClickBtnTable(_ sender: UITapGestureRecognizer) {
        self.getTableList(numberOfPerson: Int(self.txtPeoples.text ?? "1") ?? 1)
        if self.arrAvailabletable.count > 0 {
            let datePickerDialog: CustomPickerDialog = CustomPickerDialog.showCustomPickerDialog(title: "Select Table", titleLeftButton: "", titleRightButton: "TXT_SELECT".localized, dataSource: self.arrAvailabletable)
            datePickerDialog.onClickLeftButton = {
                [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
            }
            datePickerDialog.onClickRightButton = { [unowned datePickerDialog] (selectedTable:Int) in
                currentBooking.selectedTable = self.arrAvailabletable[selectedTable]
                currentBooking.table_no = currentBooking.selectedTable?.table_no ?? 0
                self.txtTables.text = "\(currentBooking.table_no)"
                datePickerDialog.removeFromSuperview()
            }
        } else {
            Utility.showToast(message: "error_no_table_available_for_people".localized)
        }
    }

    func showCustomDialogTime(ind:Int) {
        if self.selectedDateStr.count <= 0 {
            Utility.showToast(message: "TXT_SELECT_DATE_FIRST".localized)
        } else {
            let selectedDateDay = Utility.getDayFromDate(date:self.selectedDateStr)
            if self.selectedStoreSlotTime.count - 1 >= ind {
                let datePickerDialog:CustomTimeSlotPickerDialog = CustomTimeSlotPickerDialog.showCustomTimePickerSlotDialog(title: "TXT_SELECT_FUTURE_ORDER_TIME".localized, titleLeftButton: "".localized, titleRightButton: "TXT_SELECT".localized, selectedStoreSlot:selectedStoreSlotTime[ind], selectedDayInd: ind, selectedDateDay: selectedDateDay, scheduleTimeInterval: (self.selectedStore?.schedule_order_create_after_minute ?? 0),timeZone: self.timeZone,isTableBooking: Utility.isTableBooking())
                datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                    datePickerDialog.removeFromSuperview()
                }
                datePickerDialog.onClickRightButton = { [unowned datePickerDialog] (selectedTimeSlot:String, isStoreClosed:Bool) in
                    if selectedTimeSlot.count > 0 {
                        DispatchQueue.main.async {
                            let selectedDate : Date = Utility.stringToDate(strDate: "\(self.selectedDateStr) \(selectedTimeSlot.components(separatedBy: "-")[0].removingWhitespaces())", withFormat: DATE_CONSTANT.DATE_FORMATE_SLOT)
                            let selectedDate2 : Date = Utility.stringToDate(strDate: "\(self.selectedDateStr) \(selectedTimeSlot.components(separatedBy: "-")[1].removingWhitespaces())", withFormat: DATE_CONSTANT.DATE_FORMATE_SLOT)
                            currentBooking.futureDateMilliSecond = Utility.convertSelectedDateToMilliSecond(serverDate: selectedDate, strTimeZone: self.timeZone.identifier)
                            currentBooking.futureDateMilliSecond2 = Utility.convertSelectedDateToMilliSecond(serverDate: selectedDate2, strTimeZone: self.timeZone.identifier)

                            let offSetMiliSecond = self.timeZone.secondsFromGMT() * 1000

                            currentBooking.isFutureOrder = true
                            currentBooking.futureUTCMilliSecond = currentBooking.futureDateMilliSecond - Int64.init(offSetMiliSecond)
                            currentBooking.futureUTCMilliSecond2 = currentBooking.futureDateMilliSecond2 - Int64.init(offSetMiliSecond)

                            let components = Calendar.current.dateComponents(in: self.timeZone, from: selectedDate)
                            self.txtDate.text = String(components.day!)  +  "-" + String(components.month!) +  "-" +  String(components.year!)
                            self.txtTime.text = selectedTimeSlot
                            self.storeOpen = Utility.isStoreOpen(storeTime: self.selectedStoreTime,milliSeconds: currentBooking.futureDateMilliSecond)
                        }
                    }
                    datePickerDialog.removeFromSuperview()
                }
            }
        }
    }

    func resetTxtFieldTip()  {
        self.tipEntered = 0
        self.txtVTip.text = ""
    }

    @IBAction func onClickBtnTip5(_ sender: UIButton) {
        selectedTipInd = 1
        resetTxtFieldTip()
        self.setUIAccordingToTipSelection()
        prepareInvoicePARAMS(isFromTipApplied: true)
    }

    @IBAction func onClickBtnTip10(_ sender: UIButton) {
        selectedTipInd = 2
        resetTxtFieldTip()
        self.setUIAccordingToTipSelection()
        prepareInvoicePARAMS(isFromTipApplied: true)
    }

    @IBAction func onClickBtnTip15(_ sender: UIButton) {
        selectedTipInd = 3
        resetTxtFieldTip()
        self.setUIAccordingToTipSelection()
        prepareInvoicePARAMS(isFromTipApplied: true)
    }

    @IBAction func onClickBtnNoTip(_ sender: UIButton) {
        selectedTipInd = 0
        resetTxtFieldTip()
        self.setUIAccordingToTipSelection()
        prepareInvoicePARAMS(isFromTipApplied: true)
    }

    func prepareInvoicePARAMS(isFromTipApplied: Bool) {
        let storeLatLong = currentBooking.storeLatLng
        let deliveryLatLong = currentBooking.deliveryLatLng
        var timeAndDistance = ("0","0")
        if !currentBooking.isUserPickUpOrder {
            timeAndDistance =
                getTimeAndDistance(srcLat:storeLatLong[0], srcLong: storeLatLong[1], destLat: deliveryLatLong[0], destLong: deliveryLatLong[1])
        }
        let time = Double(timeAndDistance.0)
        let distance = Double(timeAndDistance.1)
        
        var totalSpecificationPriceWithQuantity = 0.0
        var totalItemsPriceWithQuantity = 0.0
        
        var totalSpecificationCount = 0
        var totalItemsCount = 0
        var taxDetails = [TaxesDetail]()
        var taxDetailArr = [[String:Any]]()

        for cartProduct in  currentBooking.cart {
            for cartProductItem in cartProduct.items! {
                var eachItemTax = 0
                if currentBooking.isUseItemTax{
                    for obj in cartProductItem.taxDetails{
                        eachItemTax = eachItemTax + obj.tax
                        let x = taxDetails.contains(where: { (a) -> Bool in
                            a.id == obj.id
                        })
                        if !x{
                            taxDetails.append(obj)
                        }
                        for i in taxDetails{
                            if i.id == obj.id{
                                i.tax_amount = i.tax_amount + obj.tax
                            }
                        }
                    }
                } else {
                    for obj in currentBooking.StoreTaxDetails{
                        eachItemTax = eachItemTax + obj.tax
                        let x = taxDetails.contains(where: { (a) -> Bool in
                            a.id == obj.id
                        })
                        if !x{
                            taxDetails.append(obj)
                        }
                        for i in taxDetails{
                            if i.id == obj.id{
                                i.tax_amount = i.tax_amount + obj.tax
                            }
                        }
                    }
                }
                let itemTax = getTax(itemAmount: cartProductItem.item_price!, taxValue: Double(eachItemTax)) * Double(cartProductItem.quantity)
                let specificationTax = getTax(itemAmount: cartProductItem.total_specification_price!, taxValue: Double(eachItemTax)) * Double(cartProductItem.quantity)

                let totalTax = itemTax + specificationTax
                print(totalTax)

                totalItemsPriceWithQuantity += (cartProductItem.item_price! * Double(cartProductItem.quantity!))
                totalSpecificationPriceWithQuantity += (cartProductItem.total_specification_price! * Double(cartProductItem.quantity!))
                totalItemsCount += cartProductItem.quantity!

                for specificationItem  in cartProductItem.specifications {
                    totalSpecificationCount +=  (specificationItem.list?.count)!
                }
            }
        }

        for obj in taxDetails{
            taxDetailArr.append(obj.toDictionary())
        }

        print(taxDetailArr)

        var dictParam:[String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.STORE_ID] = currentBooking.selectedStoreId!
        dictParam[PARAMS.TOTAL_ITEM_COUNT] = totalItemsCount
        dictParam[PARAMS.TOTAL_SPECIFICATION_COUNT] = totalSpecificationCount
        dictParam[PARAMS.TOTAL_CART_PRICE] = currentBooking.totalCartAmount!
        dictParam[PARAMS.TOTAL_TIME] = time ?? 0.0
        dictParam[PARAMS.TOTAL_DISTANCE] = distance ?? 0.0
        dictParam[PARAMS.TOTAL_SPECIFICATION_PRICE] =  totalSpecificationPriceWithQuantity
        dictParam[PARAMS.TOTAL_ITEM_PRICE] =  totalItemsPriceWithQuantity
        dictParam[PARAMS.IS_USER_PICK_UP_ORDER ] = currentBooking.isUserPickUpOrder
        dictParam[PARAMS.TIP_AMOUNT] = self.tipValue
        dictParam[PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX] = currentBooking.totalCartAmountWithoutTax ?? 0.0
        dictParam[PARAMS.TAX_DETAILS] = taxDetailArr
        dictParam[PARAMS.IS_USE_ITEM_TAX] = currentBooking.isUseItemTax
        dictParam[PARAMS.IS_TAX_INCLUDED] = currentBooking.isTaxIncluded
        dictParam[PARAMS.ORDER_TYPE] = CONSTANT.TYPE_USER

        if Utility.isTableBooking() || currentBooking.isQrCodeScanBooking {
            dictParam[PARAMS.TABLE_NO] = currentBooking.table_no
            dictParam[PARAMS.NO_OF_PERSONS] = currentBooking.number_of_pepole
            dictParam[PARAMS.DELIVERY_TYPE] = DeliveryType.tableBooking
            currentBooking.deliveryType = DeliveryType.tableBooking
            dictParam[PARAMS.BOOKING_TYPE] = currentBooking.bookingType
            dictParam[PARAMS.BOOKING_FEES] = currentBooking.booking_fees
        }

        print(Utility.convertDictToJson(dict: dictParam))

        if txtPromoCode.text!.count > 0 {
            wsGetInvoice(dictParam: dictParam,isCallApplyPromo: true)
        } else {
            wsGetInvoice(dictParam: dictParam,isCallApplyPromo: false)
        }
    }

    func getTax(itemAmount:Double, taxValue:Double) -> Double {
        //        return itemAmount * taxValue * 0.01
        if !currentBooking.isTaxIncluded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }

    func wsCheckPromo() {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> = [
            PARAMS.USER_ID:preferenceHelper.getUserId(),
            PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
            PARAMS.ORDER_PAYMENT_ID: currentBooking.orderPaymentId!,
            PARAMS.PROMO_CODE: txtPromoCode.text!
        ]

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_CHECK_PROMO, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                let invoiceResponse:InvoiceResponse = InvoiceResponse.init(dictionary: response)!
                Parser.parseInvoice(invoiceResponse.order_payment!, toArray: self.arrForInvoice,isTaxIncluded: invoiceResponse.isTaxIncluded, completetion: { (result) in
                    if result {
                        self.tableForInvoice?.reloadData()
                        self.lblTotalValue.text = currentBooking.cartCurrency + " " +  (PaymentConfig.shared.total).toString()
                        let strTotal = String(format:"%@-%@","TXT_PLACEORDER".localizedCapitalized, self.lblTotalValue.text ?? "")
                        self.updatePlaceOrderTitle(strTotal: strTotal)
                        currentBooking.currentServerTime = invoiceResponse.serverTime
                    } else {
                        self.txtPromoCode.text = ""
                    }
                })
            } else {
                self.txtPromoCode.text = ""
            }
        }
    }

    func wsAddItemInServerCart(next: Bool = false) {
        Utility.showLoading()
        let cartOrder:CartOrder = CartOrder.init()
        cartOrder.server_token = preferenceHelper.getSessionToken()
        cartOrder.user_id = preferenceHelper.getUserId()
        cartOrder.store_id = currentBooking.selectedStoreId
        cartOrder.order_details = currentBooking.cart
        cartOrder.orderPaymentId = currentBooking.orderPaymentId

        var totalPrice:Double = 0.0
        var totalTax:Double = 0.0
        for cartProduct in currentBooking.cart {
            totalTax = totalTax + cartProduct.totalItemTax
            totalPrice = totalPrice + (cartProduct.total_item_price ?? 0.0)
        }

        cartOrder.totalCartPrice =  totalPrice
        cartOrder.totalItemTax = totalTax

        currentBooking.destinationAddress = [getDestinationAddress()]

        if currentBooking.pickupAddress.isEmpty {
            let mySelectedStore:StoreItem = currentBooking.selectedStore!
            let pickupAddress:Address = Address.init()
            pickupAddress.address = mySelectedStore.address
            pickupAddress.addressType = AddressType.PICKUP
            pickupAddress.userType = CONSTANT.TYPE_USER
            pickupAddress.note = ""
            pickupAddress.city = ""
            pickupAddress.location = mySelectedStore.location ?? [0.0,0.0]

            let cartStoreDetail:CartUserDetail = CartUserDetail()
            cartStoreDetail.email = mySelectedStore.email ?? ""
            cartStoreDetail.countryPhoneCode = mySelectedStore.country_phone_code ?? ""
            cartStoreDetail.name = mySelectedStore.name ?? ""
            cartStoreDetail.phone = mySelectedStore.phone ?? ""
            cartStoreDetail.imageUrl = mySelectedStore.image_url ?? ""
            pickupAddress.userDetails = cartStoreDetail
            
            currentBooking.pickupAddress = [pickupAddress]
        }

        cartOrder.pickupAddress = currentBooking.pickupAddress
        cartOrder.destinationAddress = currentBooking.destinationAddress

        if Utility.isTableBooking() || currentBooking.isQrCodeScanBooking {
            cartOrder.table_no = currentBooking.table_no
            cartOrder.table_id = currentBooking.tableID
            cartOrder.booking_type = currentBooking.bookingType
            cartOrder.delivery_type = DeliveryType.tableBooking
            currentBooking.deliveryType = DeliveryType.tableBooking
            cartOrder.no_of_persons = currentBooking.number_of_pepole
            cartOrder.order_start_at = currentBooking.futureDateMilliSecondTable
            cartOrder.order_start_at2 = currentBooking.futureDateMilliSecondTable2
            cartOrder.table_id = currentBooking.tableID
        }

        let dictData:NSDictionary = (cartOrder.dictionaryRepresentation())
        dictData.setValue(currentBooking.isUseItemTax, forKey: PARAMS.IS_USE_ITEM_TAX)
        dictData.setValue(currentBooking.isTaxIncluded, forKey: PARAMS.IS_TAX_INCLUDED)

        print("WS_ADD_ITEM_IN_CART Invoicevc \(Utility.convertDictToJson(dict: dictData as! Dictionary<String, Any>))")

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData as? Dictionary<String, Any>) { (response,error) -> (Void) in
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                if currentBooking.isQrCodeScanBooking {
                    if next {
                        self.qrCodePlaceOrder()
                    }
                }
                else if Utility.isTableBooking() {
                    if next {
                        self.performSegue(withIdentifier: SEGUE.SEGUE_PAYMENT, sender: self)
                    }
                }
            } else {
                self.wsGetCart()
            }
            Utility.hideLoading()
        }
    }

    func wsGetCart() {
        let dictParam:[String:Any] = APPDELEGATE.getCommonDictionary()

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            currentBooking.clearCart()
            if Parser.parseCart(response) {} else {}
        }
    }

    func wsGetStoreOffers() {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> = [
            PARAMS.STORE_ID:currentBooking.selectedStoreId!,
        ]
        print(dictParam)

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_STORE_PROMO, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                print("WS_GET_STORE_PROMO response \(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))")
                if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                    let objOffers:OffersModal = OffersModal.init(fromDictionary: response as! [String : Any])
                    print(objOffers.promoCodes.count)
                    self.openOffersDialog(arrPromoCodes: objOffers.promoCodes)
                }
            } else {
                self.txtPromoCode.text = ""
            }
        }
    }

    func getTableBookingSetting() {
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.STORE_ID] = currentBooking.selectedStoreId

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.FETCH_TABLE_BOOKING_BASIC_SETTING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response, error) -> (Void) in
            guard let self = self else { return }
            if Parser.isSuccess(response: response) {
                self.responseFetchStoreSetting = ResponseFetchStoreSetting(dictionary: response)
                currentBooking.tableList = self.responseFetchStoreSetting?.storeData?.table_list ?? []
                self.setQrCodeScanBooking()
            }
        }
    }
    
    func wsRegisterUserWithoutCred() {
        
        if !preferenceHelper.getUserId().isEmpty() {
            currentBooking.isCourier = false
            self.performSegue(withIdentifier: SEGUE.SEGUE_PAYMENT, sender: self)
            return
        }
            
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.STORE_ID] = currentBooking.selectedStoreId ?? ""
        dictParam[PARAMS.FIRST_NAME] = txtName.text!
        dictParam[PARAMS.LAST_NAME] = txtLastName.text!
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = txtCountryCode.text!
        dictParam[PARAMS.PHONE] = txtContactNo.text!
        dictParam[PARAMS.EMAIL] = txtEmail.text!
        dictParam[PARAMS.IPHONE_ID] = preferenceHelper.getRandomCartID()
        
        Utility.showLoading()

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_REGISTER_USER_WITHOUT_CRED, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response, error) -> (Void) in
            
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response) {
                Parser.parseUserStorageData(response: response, isQRUser: true, completion: { result in
                    if result {
                        currentBooking.isCourier = false
                        self?.performSegue(withIdentifier: SEGUE.SEGUE_PAYMENT, sender: self)
                    }
                })
            }
        }
    }
}

class InvoiceSection: CustomTableCell {

    //MARK: - OUTLET
    @IBOutlet weak var imgFreeDelivery: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    //MARK: - LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.backgroundColor = UIColor.themeViewBackgroundColor
        lblName.textColor = UIColor.themeTitleColor
        lblName.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
    }

    func setData(title:String,isShowImage:Bool = false) {
        lblName.text = title.appending("     ")
        imgFreeDelivery.isHidden = currentBooking.isUserPickUpOrder ? true : !isShowImage
        lblName.sectionRound(lblName)
    }

    //MARK: - SET CELL DATA
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
