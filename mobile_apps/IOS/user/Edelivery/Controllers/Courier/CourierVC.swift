//
//  SplashVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import TableViewDragger

class CourierVC: BaseVC,LocationHandlerDelegate, LeftDelegate, RightDelegate, UIGestureRecognizerDelegate {
    
    /*Pickup Details*/
    @IBOutlet var viewForPickupDetail: UIView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var lblPickupMobileNumber: UILabel!
    @IBOutlet var txtPickupCountryCode: UITextField!
    @IBOutlet var txtPickupContactNumber: UITextField!
    @IBOutlet var txtPickupAddress: UITextField!
    @IBOutlet var btnChangePickupAddress: UIButton!
    @IBOutlet var txtPickupNote: UITextField!
    @IBOutlet var pickupBGView: UIView!
    @IBOutlet var lblPickupDetail: UILabel!
    
    /*Delivery Details*/
    @IBOutlet var deliveryBGView: UIView!
    @IBOutlet var lblDeliveryDetail: UILabel!
    @IBOutlet var txtDestinationName: UITextField!
    @IBOutlet var lblDestinationMobileNumber: UILabel!
    @IBOutlet var txtDestinationCountryCode: UITextField!
    @IBOutlet var txtDestinationContactNumber: UITextField!
    @IBOutlet var txtDestinationAddress: UITextField!
    @IBOutlet var btnChangeDestinationAddress: UIButton!
    @IBOutlet var txtDestinationNote: UITextField!
    @IBOutlet var viewForDeliveryDetail: UIView!
    
    //Courier Detail
    @IBOutlet var viewForCourierDetail: UIView!
    @IBOutlet var lblAddPhotoHere: UILabel!
    @IBOutlet var collectionForCourierImages: UICollectionView!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet weak var viewContactLess: UIView!
    @IBOutlet weak var lblContactLess: UILabel!
    @IBOutlet weak var btnContactLess: UIButton!
    @IBOutlet var imgContactLess: UIImageView!
    
    @IBOutlet var lblAddresses: UILabel!
    @IBOutlet var tblAddress: UITableView!
    @IBOutlet var heightAddressTable: NSLayoutConstraint!
    
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var switchOptimize: UISwitch!
    @IBOutlet var lblOptimize: UILabel!
    
    @IBOutlet var viewScroll: UIScrollView!
    
    var arrForItemImage:[CourierImageViewModel] = []
    var arrForUploadItemImage : [UIImage] = []
    var arrForDeleteItemImage : [String] = []
    var pickupAddress:Address = Address.init()
    var destinationAddress:Address = Address.init()
    var dialogForImage:CustomPhotoDialog? = nil
    var isPickupAddress:Bool = true
    var arrAddress:[Address] = []
    var dragger: TableViewDragger!
    var currentIndex = 0
    var arrAddressNotOptimize = [Address]()
    var arrAddressOptimize = [Address]()
    var isAddressChanged = false {
        didSet {
            updateAddAddressButton()
            googlePathResponse = nil
        }
    }
    var addressId = 0
    var cartOrder: CartOrder?
    
    var googlePathResponse: [String:Any]?
    
    var strArrAddress = """
        [{"address":"Rajkot, Gujarat, India","delivery_status":0,"location":[22.3038945,70.80215989999999],"note":"Note 1","user_details":{"country_phone_code":"+91","name":"Magan User 1","phone":"7897897891"},"user_type":0},{"address":"Devpur Ranuja, Gujarat, India","delivery_status":0,"location":[22.2806793,70.3554121],"note":"Note 2","user_details":{"country_phone_code":"+91","name":"Magan User 2","phone":"7897897892"},"user_type":0},{"address":"Jamnagar, Gujarat, India","delivery_status":0,"location":[22.4707019,70.05773],"note":"Note 3","user_details":{"country_phone_code":"+91","name":"Magan User 3","phone":"7897897893"},"user_type":0},{"address":"Kalavad, Gujarat, India","delivery_status":0,"location":[22.2081932,70.38070580000002],"note":"Note 4","user_details":{"country_phone_code":"+91","name":"Magan User 4","phone":"7897897894"},"user_type":0},{"address":"Chotila, Gujarat, India","delivery_status":0,"location":[22.424833,71.19621],"note":"Note 5","user_details":{"country_phone_code":"+91","name":"Magan User 5","phone":"7897897895"},"user_type":0}]
"""
    
    var addressDialog: AddAddressDialog? {
        didSet {
            addressDialogListner()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegateLeft = self
        setLocalization()
        currentBooking.isContactLessDelivery = false
        self.hideBackButtonTitle()
        btnSubmit.enable(false, isAnimation: true)
        txtDestinationName.text = ""
        txtPickupNote.text = ""
        txtDestinationNote.text = ""
        txtDestinationAddress.text = ""
        txtPickupContactNumber.keyboardType = .numberPad
        txtDestinationContactNumber.keyboardType = .numberPad
        
        btnAdd.addDashedBorder()
        btnAdd.setTitleColor(.themeLightGrayColor, for: .normal)
        btnAdd.setTitle("+", for: .normal)
        btnAdd.titleLabel?.font = FontHelper.textMedium(size: 50)
        
        CurrentBooking.shared.isRoundTrip = false
        CurrentBooking.shared.courierNoOfStop = 0
        
        //Load Temp Data
        if let arr = strArrAddress.toJSON() as? [[String:Any]] {
            for obj in arr {
                //arrAddress.append(Address(fromDictionary: obj))
            }
        }
        tblAddress.reloadData()
        //Load Temp Data End
        
        addressDialog = AddAddressDialog.showCustomAddressDialog(title: "TXT_ADDRESS".localized, titleRightButton: "TXT_ADD_TEXT".localized, address: nil, addInVC: self)
        
        
        if !CurrentBooking.shared.currentAddress.isEmpty() && CurrentBooking.shared.currentLatLng.count > 0 {
            arrAddress.append(Address(address: CurrentBooking.shared.currentAddress, location: CurrentBooking.shared.currentLatLng, user: CartUserDetail(name: preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName(), code: preferenceHelper.getPhoneCountryCode(), phone: preferenceHelper.getPhoneNumber())))
        }
        
        tblAddress.reloadData()
    }
    
    func adjustLabel(label:UILabel) {
        label.sectionRound(label)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblAddress.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        tblAddress.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightAddressTable.constant = tblAddress.contentSize.height
    }
    
    override func updateUIAccordingToTheme() {
        setLocalization()
    }
    
    func setLocalization() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForPickupDetail.backgroundColor = .themeViewBackgroundColor
        viewForCourierDetail.backgroundColor = .themeViewBackgroundColor
        viewForDeliveryDetail.backgroundColor = .themeViewBackgroundColor
        
        self.viewContactLess.isHidden = !currentBooking.isAllowContactLessDelivery
        
        txtName.textColor = UIColor.themeTextColor
        txtPickupCountryCode.textColor = UIColor.themeTextColor
        txtPickupNote.textColor = UIColor.themeTextColor
        txtPickupContactNumber.textColor = UIColor.themeTextColor
        txtPickupAddress.textColor = UIColor.themeTextColor
        lblPickupMobileNumber.textColor = UIColor.themeTextColor
        txtDestinationName.textColor = UIColor.themeTextColor
        txtDestinationCountryCode.textColor = UIColor.themeTextColor
        txtDestinationNote.textColor = UIColor.themeTextColor
        txtDestinationAddress.textColor = UIColor.themeTextColor
        txtDestinationContactNumber.textColor = UIColor.themeTextColor
        lblDestinationMobileNumber.textColor = UIColor.themeTextColor
        lblContactLess.textColor = UIColor.themeTextColor
        lblAddresses.textColor = UIColor.themeTextColor

        lblPickupMobileNumber.text = "TXT_MOBILE_NUMBER".localizedCapitalized
        lblDestinationMobileNumber.text = "TXT_MOBILE_NUMBER".localizedCapitalized
        txtPickupContactNumber.placeholder = "TXT_MOBILE_NUMBER".localizedCapitalized
        txtDestinationContactNumber.placeholder = "TXT_MOBILE_NUMBER".localizedCapitalized
        txtDestinationName.placeholder = "TXT_NAME".localizedCapitalized
        self.setNavigationTitle(title:"TXT_COURIER_ORDER".localizedCapitalized)
        txtName.placeholder = "TXT_NAME".localizedCapitalized
        txtPickupAddress.placeholder = "TXT_PICKUP_ADDRESS".localizedCapitalized
        txtDestinationAddress.placeholder = "TXT_DELIVERY_ADDRESS".localizedCapitalized
        txtPickupNote.placeholder = "TXT_ADD_NOTE".localizedCapitalized
        txtName.text = preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName()
        txtPickupNote.text = ""
        txtDestinationNote.placeholder = "TXT_ADD_NOTE".localizedCapitalized
        btnSubmit.setTitle("TXT_SUBMIT".localizedCapitalized, for: .normal)
        lblAddPhotoHere.text = "TXT_ADD_PHOTO_HERE".localized
        lblPickupDetail.text = "TXT_PICKUP_DETAILS".localized + "    "
        lblDeliveryDetail.text = "TXT_DELIVERY_DETAILS".localized + "    "
        lblContactLess.text = "TXT_CONTACT_LESS_DELIVERY".localized
        lblAddresses.text = "txt_addresses".localized
        
        txtPickupContactNumber.text = preferenceHelper.getPhoneNumber()
        txtPickupAddress.text = currentBooking.currentAddress
        self.pickupAddress.address = currentBooking.currentAddress
        self.pickupAddress.location = currentBooking.currentLatLng
        txtPickupAddress.isUserInteractionEnabled = false
        txtPickupAddress.isEnabled = false
        
        txtName.font = FontHelper.labelRegular()
        txtPickupCountryCode.font = FontHelper.labelRegular()
        txtPickupNote.font = FontHelper.labelRegular()
        txtPickupContactNumber.font = FontHelper.labelRegular()
        txtPickupAddress.font = FontHelper.labelRegular()
        lblPickupMobileNumber.font = FontHelper.labelRegular()
        txtDestinationName.font = FontHelper.labelRegular()
        txtDestinationCountryCode.font = FontHelper.labelRegular()
        txtDestinationNote.font = FontHelper.labelRegular()
        txtDestinationAddress.font = FontHelper.labelRegular()
        txtDestinationContactNumber.font = FontHelper.labelRegular()
        lblDestinationMobileNumber.font = FontHelper.labelRegular()
        lblAddresses.font = FontHelper.textMedium(size: FontHelper.regular)
        lblAddPhotoHere.font = FontHelper.textMedium(size: FontHelper.regular)
        lblContactLess.font = FontHelper.textMedium(size: FontHelper.regular)
        
        btnSubmit.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSubmit.titleLabel?.font = FontHelper.buttonText()
        pickupAddress.addressType = AddressType.PICKUP
        pickupAddress.city = currentBooking.currentCity
        pickupAddress.userType = CONSTANT.TYPE_USER
        destinationAddress.addressType = AddressType.DESTINATION
        destinationAddress.city = currentBooking.currentCity
        destinationAddress.userType = CONSTANT.TYPE_USER
        txtPickupCountryCode.text = preferenceHelper.getPhoneCountryCode()
        txtDestinationCountryCode.text = preferenceHelper.getPhoneCountryCode()
        txtPickupAddress.isUserInteractionEnabled = false
        txtDestinationAddress.isUserInteractionEnabled = false
        txtPickupCountryCode.isUserInteractionEnabled = false
        txtDestinationCountryCode.isUserInteractionEnabled = false
        lblPickupDetail.backgroundColor = UIColor.themeViewBackgroundColor
        lblPickupDetail.textColor = UIColor.themeTitleColor
        lblPickupDetail.font = FontHelper.textMedium(size: FontHelper.regular)
        lblDeliveryDetail.backgroundColor = UIColor.themeViewBackgroundColor
        lblDeliveryDetail.textColor = UIColor.themeTitleColor
        lblDeliveryDetail.font = FontHelper.textMedium(size: FontHelper.regular)
        lblAddPhotoHere.textColor = UIColor.themeTextColor
        btnChangePickupAddress.setImage(UIImage(named:"map")?.imageWithColor(color: .themeTitleColor), for: .normal)
        btnChangeDestinationAddress.setImage(UIImage(named:"map")?.imageWithColor(color: .themeTitleColor), for: .normal)
        imgContactLess.image = UIImage(named: "contactless")?.imageWithColor(color: .themeTitleColor)
        txtPickupCountryCode.tintColor = .themeTitleColor
        txtPickupContactNumber.tintColor = .themeTitleColor
        txtDestinationCountryCode.tintColor = .themeTitleColor
        txtDestinationContactNumber.tintColor = .themeTitleColor
        
        btnContactLess.setImage(UIImage(named: "checked_checkbox_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        self.setBackBarItem(isNative: false)
        
        lblOptimize.font = FontHelper.textMedium(size: FontHelper.regular)
        lblOptimize.text = "txt_optimized_route".localized
        lblOptimize.backgroundColor = .clear
        lblOptimize.textColor = .themeTextColor
        
        self.delegateRight = self
        self.setRightBarItem(isNative: false)
        self.setRightBarItemImage(image: UIImage.init(named: "map_route")!.imageWithColor(color: .themeTextColor)!)
        self.button.tintColor = .themeTextColor
        
        setTableView()
    }
    
    func setTableView() {
        tblAddress.delegate = self
        tblAddress.dataSource = self
        tblAddress.separatorColor = .clear
        tblAddress.register(UINib(nibName: "CourierAddressCell", bundle: nil), forCellReuseIdentifier: "CourierAddressCell")
        
        tblAddress.dragDelegate = self
        tblAddress.dragInteractionEnabled = true
    }
    
    @IBAction func onClickBtnPickupAddress(_ sender: Any) {
        isPickupAddress = true
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)

        let locationVC : CartLocationVC = mainView.instantiateViewController(withIdentifier: "cartLocationVC") as! CartLocationVC
        if currentBooking.courierPickupAddress.count > 0 {
            locationVC.location = currentBooking.courierPickupAddress[0].location
        } else {
            locationVC.location = [0.0,0.0]
        }
        locationVC.deliveryType = DeliveryType.courier
        locationVC.delegate = self
        self.navigationController?.pushViewController(locationVC, animated: true)
    }

    @IBAction func onClickBtnDestinationAddress(_ sender: Any) {
        isPickupAddress = false
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let locationVC : CartLocationVC = mainView.instantiateViewController(withIdentifier: "cartLocationVC") as! CartLocationVC
        if currentBooking.courierDestinationAddress.count > 0 {
            locationVC.location = currentBooking.courierDestinationAddress[0].location
        } else {
            locationVC.location = [0.0,0.0]
        }
        locationVC.deliveryType = DeliveryType.courier
        locationVC.delegate = self
        self.navigationController?.pushViewController(locationVC, animated: true)
    }

    @IBAction func onClickBtnSubmit(_ sender: Any) {
        self.wsGetVehiclelist()
    }

    @IBAction func contactLessPressed(_ sender: UIButton) {
        sender.isSelected =  !sender.isSelected
        currentBooking.isContactLessDelivery = sender.isSelected
    }

    func checkvalidation() -> Bool {
        let validPickupMobileNumber = txtPickupContactNumber.text!.isValidMobileNumber()
        let validDestinationMobileNumber = txtDestinationContactNumber.text!.isValidMobileNumber()

        if (txtName.text?.isEmpty())! {
            txtName.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
            return false
        } else if validPickupMobileNumber.0 == false {
            txtPickupContactNumber.becomeFirstResponder()
            Utility.showToast(message:validPickupMobileNumber.1)
            return false
        } else if (txtPickupAddress.text?.isEmpty())! {
            Utility.showToast(message:"MSG_PLEASE_ENTER_PICKUP_ADDRESS".localized)
            return false
        } else if (txtDestinationName.text?.isEmpty())! {
            txtDestinationName.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
            return false
        } else if validDestinationMobileNumber.0 == false {
            txtDestinationContactNumber.becomeFirstResponder()
            Utility.showToast(message:validDestinationMobileNumber.1)
            return false
        } else if (txtDestinationAddress.text?.isEmpty())! {
            Utility.showToast(message:"MSG_PLEASE_ENTER_DESTINATION_ADDRESS".localized)
            return false
        } else {
            return true
        }
    }
    
    func addressDialogListner() {
        addressDialog?.onClickAddress = { [weak self] dialog in
            guard let self = self else { return }
            self.goToAddress()
        }
        
        addressDialog?.onClickRightButton = { [weak self] dialog in
            guard let self = self else { return }
            dialog.hide()
            if dialog.indexPath != nil {
                let address = dialog.address!
                self.arrAddress.remove(at: dialog.indexPath!.row)
                self.arrAddress.insert(address, at: dialog.indexPath!.row)
                self.isAddressChanged = true
            } else {
                self.arrAddress.append(dialog.address!)
                self.isAddressChanged = true
            }
            if self.arrAddress.count >= 2 {
                self.btnSubmit.enable(true)
            }
            self.tblAddress.reloadData()
        }
        
        addressDialog?.onClickLeftButton = { [weak self] in
            guard let self = self else { return }
            self.addressDialog?.hide()
        }
    }

    func finalAddressAndLocation(address: String, latitude: Double, longitude: Double) {
        
        if let addressDialog = addressDialog {
            //addressDialog.show(withAnimation: false)
            let addressObj = Address.init(fromDictionary: [:])
            addressObj.address = address
            addressObj.location = [latitude,longitude]

            addressDialog.address = addressObj
        }
    }
}

extension CourierVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtPickupContactNumber.becomeFirstResponder()
        } else if textField == txtPickupContactNumber {
            txtPickupNote.becomeFirstResponder()
        } else if textField == txtPickupNote {
            txtDestinationName.becomeFirstResponder()
        } else if textField == txtDestinationContactNumber {
            txtDestinationNote.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        return true
    }
}

extension CourierVC: UICollectionViewDataSource,UICollectionViewDelegate {

    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForItemImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForAddImage", for: indexPath) as! ImageCollectionViewCell
        let isForUpload = arrForItemImage[indexPath.row].isForUpload ?? false

        if !isForUpload {
             cell.imgCollection.downloadedFrom(link:Utility.getDynamicResizeImageURL(width: cell.imgCollection.frame.width, height: cell.imgCollection.frame.height, imgUrl: arrForItemImage[indexPath.row].url!), isFromResize: true)
        } else {
            cell.imgCollection.image = arrForItemImage[indexPath.row].image!
        }
        cell.btnDeleteImage.tag = indexPath.row
        cell.btnDeleteImage.addTarget(self, action:#selector(CourierVC.deleteImage(sender:)), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerId", for: indexPath)
        if self.arrForItemImage.count == 3 {
            footerView.frame = CGRect.zero
        }
        return footerView
    }

    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func reloadCollectionView() {
        collectionForCourierImages.reloadData()
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height:100)
    }

    @IBAction func onClickAddImage(_ sender: UIButton) {
        if self.arrForItemImage.count == 3 {
            Utility.showToast(message: "MSG_MAX_IMAGE_UPLOADED".localized)
        } else {
            dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
            dialogForImage?.onImageSelected = {[unowned self, weak dialogForImage = self.dialogForImage] (image:UIImage) in
                self.arrForItemImage.append(CourierImageViewModel.init(url: "", image: image,isForUpload: true)!)
                self.collectionForCourierImages.reloadData()
            }
        }
    }
    
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        openAddAddressDialog()
    }
    
    @IBAction func onSwitchOptimizedChanged(_ sender: UISwitch) {
        if arrAddress.count < 2 {
            sender.isOn = false
            return
        }
        if sender.isOn {
            if !isAddressChanged && arrAddressOptimize.count > 0 {
                arrAddress.removeAll()
                for address in arrAddressOptimize {
                    arrAddress.append(address)
                }
                tblAddress.reloadData()
            } else {
                arrAddressNotOptimize.removeAll()
                for i in 0..<arrAddress.count {
                    let obj = arrAddress[i]
                    arrAddressNotOptimize.append(obj)
                }
                wsDirectionApi()
            }
        } else {
            if arrAddressNotOptimize.count > 0 {
                arrAddress.removeAll()
                for address in arrAddressNotOptimize {
                    arrAddress.append(address)
                    tblAddress.reloadData()
                }
            }
        }
    }

    @objc func deleteImage(sender:UIButton) {
        if (arrForItemImage[sender.tag].url?.isEmpty())! {
            arrForItemImage.remove(at: sender.tag)
        } else {
            arrForDeleteItemImage.append(arrForItemImage[sender.tag].url!)
            arrForItemImage.remove(at: sender.tag)
        }
        reloadCollectionView()
    }

    func onClickLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onClickRightButton() {
        self.view.endEditing(true)
        if arrAddress.count >= 2 {
            if let googlePathResponse = googlePathResponse {
                let vc = UIStoryboard(name: "Courier", bundle: nil).instantiateViewController(withIdentifier: "CourierStopPathVC") as! CourierStopPathVC
                vc.googlePathResponse = googlePathResponse
                vc.arrAddress = self.arrAddress
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            } else {
                wsDirectionApi(type: 2)
            }
        } else {
            Utility.showToast(message: "txt_add_at_least_two_address".localized)
        }
    }
    
    func openAddAddressDialog() {
        addressDialog?.reset()
        addressDialog?.show()
    }
    
    func goToAddress() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)
        let locationVC : CartLocationVC = mainView.instantiateViewController(withIdentifier: "cartLocationVC") as! CartLocationVC
        if arrAddress.count > 0 {
            locationVC.location = arrAddress[currentIndex].location
        } else {
            locationVC.location = [0.0,0.0]
        }
        locationVC.deliveryType = DeliveryType.courier
        locationVC.delegate = self
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    func updateAddAddressButton() {
        if isAddressChanged {
            switchOptimize.isOn = false
        }
        if arrAddress.count >= (preferenceHelper.getMaxCourierStop() + 2) {
            btnAdd.isHidden = true
        } else {
            btnAdd.isHidden = false
        }
        if arrAddress.count >= 4 {
            //hide optimaize rounte
            switchOptimize.isHidden = false
            lblOptimize.isHidden = switchOptimize.isHidden
        } else {
            //show optimaize rounte
            switchOptimize.isHidden = true
            lblOptimize.isHidden = switchOptimize.isHidden
        }
    }
}

extension CourierVC {

    func enableSubmitButton(isEnable:Bool = false) {
        if isEnable {
            self.btnSubmit.isEnabled = true
            btnSubmit.backgroundColor = UIColor.themeButtonBackgroundColor
        } else {
            self.btnSubmit.isEnabled = false
            btnSubmit.backgroundColor = UIColor.themeDisableButtonBackgroundColor
        }
    }

    func wsAddItemInServerCart() {
        Utility.showLoading()
        cartOrder = CartOrder.init()
        cartOrder?.server_token = preferenceHelper.getSessionToken()
        cartOrder?.user_id = preferenceHelper.getUserId()
        cartOrder?.store_id = ""
        cartOrder?.order_details = []
        cartOrder?.orderPaymentId = ""
        cartOrder?.totalCartPrice = 0.0
        cartOrder?.totalItemTax = 0.0
        destinationAddress.addressType = AddressType.DESTINATION
        destinationAddress.userType = CONSTANT.TYPE_USER
        destinationAddress.note = txtDestinationNote.text ?? ""
        destinationAddress.city = currentBooking.currentSendPlaceData.city1
        let cartUserDetail:CartUserDetail = CartUserDetail()
        cartUserDetail.email = ""
        cartUserDetail.countryPhoneCode = txtDestinationCountryCode.text
        cartUserDetail.name = txtDestinationName.text
        cartUserDetail.phone = txtDestinationContactNumber.text
        destinationAddress.userDetails = cartUserDetail
        pickupAddress.addressType = AddressType.PICKUP
        pickupAddress.userType = CONSTANT.TYPE_USER
        pickupAddress.note = txtPickupNote.text ?? ""
        pickupAddress.city = currentBooking.currentSendPlaceData.city1
        let cartStoreDetail:CartUserDetail = CartUserDetail()
        cartStoreDetail.email = ""
        cartStoreDetail.countryPhoneCode = txtPickupCountryCode.text ?? ""
        cartStoreDetail.name = txtName.text ?? ""
        cartStoreDetail.phone = txtPickupContactNumber.text ?? ""
        pickupAddress.userDetails = cartStoreDetail
        
        
        var arrPickupAddress = [Address]()
        var arrAddressFinal = [Address]()
        for i in 0..<arrAddress.count {
            let obj = arrAddress[i]
            obj.userType = CONSTANT.TYPE_USER
            if i != 0 {
                arrAddressFinal.append(obj)
            } else {
                obj.addressType = AddressType.PICKUP
                arrPickupAddress.append(obj)
            }
        }
        
        cartOrder?.pickupAddress = arrPickupAddress
        cartOrder?.destinationAddress = arrAddressFinal
        
        let dictData:NSDictionary = (cartOrder?.dictionaryRepresentation())!
        dictData.setValue(currentBooking.bookCountryId ?? "", forKey: PARAMS.COUNTRY_ID)
        dictData.setValue(currentBooking.bookCityId ?? "", forKey: PARAMS.CITY_ID)
        dictData.setValue(DeliveryType.courier, forKey: PARAMS.DELIVERY_TYPE)
        print(Utility.convertDictToJson(dict: dictData as! Dictionary<String, Any>))
        print("dicdata \(dictData)")
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData as? Dictionary<String, Any>) { (response,error) -> (Void) in
            print("response \(response)")
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                currentBooking.cartId = (response.value(forKey: "cart_id") as? String) ?? ""
                currentBooking.cartCityId = (response.value(forKey: "city_id") as? String) ?? ""
                currentBooking.deliveryType = DeliveryType.courier
                
                self.wsDirectionApi(type: 1)
                /*
                if self.navigationController?.visibleViewController == self {
                   self.performSegue(withIdentifier: SEGUE.SEGUE_COURIER_INVOICE, sender: self)
                }*/
            }
            Utility.hideLoading()
        }
    }

    func wsGetVehiclelist() {
        Utility.showLoading()

        let dictData:[String:Any] =
             [PARAMS.DELIVERY_TYPE:DeliveryType.courier,
             PARAMS.CITY_ID:currentBooking.bookCityId ?? ""]
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_VEHICLES_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictData) { (response,error) -> (Void) in
            print(response)
            Utility.hideLoading()
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                let vehicleListResponse:VehicleListResponse = VehicleListResponse.init(fromDictionary: response as! [String : Any])
                if vehicleListResponse.adminVehicles.count > 0 {
                    self.openVehicleDialog(arr: vehicleListResponse.adminVehicles)
                } else {
                    Utility.showToast(message: "ERROR_CODE_851".localized)
                }
            }
        }
    }
    
    func wsDirectionApi(type: Int = 0) {  // type = 1
        let saddr = "\(arrAddress[0].location[0]),\(arrAddress[0].location[1])"
        let daddr = "\(arrAddress.last!.location[0]),\(arrAddress.last!.location[1])"
                
        var wayPoint: [String] = []
        for i in 0..<arrAddress.count {
            let obj = arrAddress[i]
            if i != 0 && i != arrAddress.count - 1 {
                wayPoint.append("\(obj.location[0]),\(obj.location[1])")
            }
        }
        
        var apiUrlStr = Google.DIRECTION_URL + "\(saddr)&destination=\(daddr)&waypoints=optimize:false|\(wayPoint.joined(separator: "|"))&key=\(Google.API_KEY)"
        
        if switchOptimize.isOn {
            apiUrlStr = Google.DIRECTION_URL + "\(saddr)&destination=\(daddr)&waypoints=optimize:true|\(wayPoint.joined(separator: "|"))&key=\(Google.API_KEY)"
        }
  
        print(apiUrlStr)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url =  URL(string: apiUrlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? apiUrlStr) else {
            return
        }
        do {
            DispatchQueue.main.async {
                session.dataTask(with: url) { [unowned self] (data, response, error) in
                    if error != nil {
                        self.switchOptimize.isOn = false
                        return
                    }
                    guard let data = data else {
                        self.switchOptimize.isOn = false
                        return
                    }
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            printE(json)
                            self.googlePathResponse = json
                            
                            var totalDistance: Double = 0
                            var totalTime: Double = 0
                            if let routs = json["routes"] as? [[String:Any]] {
                                for rout in routs {
                                    if let legs = rout["legs"] as? [[String:Any]] {
                                        for leg in legs {
                                            if let distance = leg["distance"] as? [String:Any] {
                                                if let value = distance["value"] as? Double {
                                                    totalDistance += value
                                                } else if let value = distance["value"] as? Int {
                                                    totalDistance += Double(value)
                                                }
                                            }
                                            if let duration = leg["duration"] as? [String:Any] {
                                                if let value = duration["value"] as? Double {
                                                    totalTime += value
                                                } else if let value = duration["value"] as? Int {
                                                    totalTime += Double(value)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                DispatchQueue.main.async {
                                    if type == 1 {
                                        self.gotoInvoice(time: totalTime, distance: totalDistance)
                                    } else if type == 2 {
                                        self.onClickRightButton()
                                    } else {
                                        if let first = routs.first {
                                            if let indexes = first["waypoint_order"] as? [Int] {
                                                self.resetIndexes(wayPointIndex: indexes)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch let error {
                        self.switchOptimize.isOn = false
                        print("Failed to draw",error.localizedDescription)
                    }
                }.resume()
            }
        }
    }

    func openVehicleDialog(arr: [VehicleDetail]) {
        let dialogForVehicle: CustomVehicleSelectionDialog = CustomVehicleSelectionDialog.showCustomVehicleSelectionDialog(title: "TXT_CHOOSE_DELIVERY_VEHICLE".localized, titleLeftButton: "".localized, titleRightButton: "TXT_CONFIRM".localizedCapitalized, arrForVehicle: arr)
        dialogForVehicle.onClickRightButton = {
            [unowned self, unowned dialogForVehicle] (selectedVehicleId:String, dialog) in
            currentBooking.selectedVehicleId = selectedVehicleId
            currentBooking.isRoundTrip = dialog.switchRoundTrip.isOn
            dialogForVehicle.removeFromSuperview()
            
            
            for item in self.arrForItemImage {
                if let imageToUpload = item.image {
                    currentBooking.courierImage.append(imageToUpload)
                }
            }
            wsAddItemInServerCart()
        }
        dialogForVehicle.onClickLeftButton = {
            [unowned dialogForVehicle] in
            dialogForVehicle.removeFromSuperview()
        }
    }
    
    func gotoInvoice(time: Double, distance: Double) {
        let sb = UIStoryboard(name: "Courier", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CourierInvoiceVC") as! CourierInvoiceVC
        vc.totalTime = time
        vc.totalDistance = distance
        vc.cartOrder = self.cartOrder
        if arrAddress.count > 2 {
            CurrentBooking.shared.courierNoOfStop = arrAddress.count - 2
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resetIndexes(wayPointIndex: [Int]) {
        if wayPointIndex.count == 0 || arrAddressNotOptimize.count == 0 {
            return
        }
        isAddressChanged = false
        
        var arrMilestone = [Address]()
        for i in 0..<arrAddressNotOptimize.count {
            if i != 0 && i != arrAddressNotOptimize.count - 1 {
                arrMilestone.append(arrAddressNotOptimize[i])
            }
        }
        
        arrAddress.removeAll()
        arrAddressOptimize.removeAll()
        
        for index in wayPointIndex {
            arrAddress.append(arrMilestone[index])
            arrAddressOptimize.append(arrMilestone[index])
        }
        arrAddress.insert(arrAddressNotOptimize[0], at: 0)
        arrAddressOptimize.insert(arrAddressNotOptimize[0], at: 0)
        
        arrAddress.append(arrAddressNotOptimize.last!)
        arrAddressOptimize.append(arrAddressNotOptimize.last!)
        
        tblAddress.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.SEGUE_COURIER_INVOICE {
            if segue.destination is CourierInvoiceVC {
                currentBooking.courierPickupAddress = [self.pickupAddress]
            }
        }
    }
}

extension CourierVC: UITableViewDelegate, UITableViewDataSource, CourierAddressCellDelegate, UITableViewDragDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourierAddressCell", for: indexPath) as! CourierAddressCell
        cell.delegate = self
        cell.lblTopLine.isHidden = false
        cell.lblBottomLine.isHidden = false
        cell.imgPin.isHidden = true
        cell.viewRoundPin.isHidden = false
        if indexPath.row == 0 {
            cell.lblTopLine.isHidden = true
            cell.imgPin.isHidden = false
            cell.viewRoundPin.isHidden = true
        }
        if indexPath.row == arrAddress.count - 1 {
            cell.lblBottomLine.isHidden = true
            cell.imgPin.isHidden = false
            cell.viewRoundPin.isHidden = true
        }
        let obj = arrAddress[indexPath.row]
        cell.lblAddress.text = obj.address
        let name = obj.userDetails?.name ?? ""
        let phone = (obj.userDetails?.countryPhoneCode ?? "") + (obj.userDetails?.phone ?? "")
        cell.lblName.text = "\(name) | \(phone)"
        cell.lblNote.text = obj.note ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrAddress[indexPath.row]
        addressDialog?.showUpdateDialog(indexPath: indexPath)
        addressDialog?.address = obj
    }
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = arrAddress[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = arrAddress.remove(at: sourceIndexPath.row)
        arrAddress.insert(mover, at: destinationIndexPath.row)
        tblAddress.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tblAddress.isScrollEnabled = false
        viewScroll.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tblAddress.isScrollEnabled = true
        viewScroll.isScrollEnabled = true
    }
    func didTapCellButton(sender: UIButton, cell: CourierAddressCell) {
        if let index = tblAddress.indexPath(for: cell) {
            if sender == cell.btnDelete {
                arrAddress.remove(at: index.row)
                self.isAddressChanged = true
                if arrAddress.count < 2 {
                    btnSubmit.enable(false)
                }
                tblAddress.reloadData()
                arrAddressOptimize.removeAll()
                arrAddressNotOptimize.removeAll()
                updateAddAddressButton()
            }
        }
    }
}

extension CourierVC: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        let address = arrAddress[indexPath.row]
        arrAddress.remove(at: indexPath.row)
        arrAddress.insert(address, at: newIndexPath.row)
        
        if arrAddress.count == arrAddressNotOptimize.count {
            arrAddressNotOptimize.remove(at: indexPath.row)
            arrAddressNotOptimize.insert(address, at: newIndexPath.row)
            switchOptimize.isOn = false
        }

        tblAddress.reloadData()

        return true
    }
    
    func dragger(_ dragger: TableViewDragger, willBeginDraggingAt indexPath: IndexPath) {
        tblAddress.contentSize.height = 900
    }
    
    func dragger(_ dragger: TableViewDragger, willEndDraggingAt indexPath: IndexPath) {
        print("willEndDraggingAt")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnDeleteImage: UIButton!
    @IBOutlet weak var imgCollection: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.imgCollection.clipsToBounds = true
    }
}

class CourierImageViewModel {
    public var url : String?
    public var image : UIImage?
    public var isForUpload : Bool?

    required public init?(url:String,image:UIImage?,isForUpload:Bool = false) {
        self.url = url
        self.image = image
        self.isForUpload = isForUpload
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
