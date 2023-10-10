//
//  CustomTableBookingDialog.swift
//  Edelivery
//
//  Created by Elluminati on 18/10/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class CustomTableBookingDialog: CustomDialog, UITextFieldDelegate {

    //MARK:- OUTLETS
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var heightForList: NSLayoutConstraint!
    @IBOutlet weak var btnReserveTable: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tvData: UITableView!

    var filteredArrStoreList:Array<StoreItem>? = nil
    var originalArrStoreList:Array<StoreItem>? = nil
    var currentDeliveryItem:DeliveriesItem?
    var arrForSelectedTags:[String] = []
    var activeField: UITextField?

    //MARK:- Variables
    var onClickRightButton : (() -> Void)? = nil
    var onClickClearButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    var isFilterApply:Bool = false
    var arrForPriceRate:[Int] = []
    var storeTimeRate = Int.max, storeDistanceRate=Int.max
    var filterSingleton: SelectedFilterOptions = SelectedFilterOptions.shared
    var strStoreId:String = ""
    var responseFetchStoreSetting:ResponseFetchStoreSetting?
    var arrAvailabletable:[Table_list] = []
    var arrOptionForTableBooking:[String] = []
    var isTableSelected:Bool = false
    var selectedDayInd:Int = 0
    var selectedDateStr:String = ""
    static let filterDialog = "CustomTableBookingDialog"
    var preferredContentSize: CGSize {
        get {
            self.tvData.layoutIfNeeded()
            return self.tvData.contentSize
        }
        set {}
    }

    var selectedTable:Table_list? = nil
    var number_of_pepole:Int = 0
    var bookingType:Int = 0
    var booking_fees:Double = 0.0
    var tableBookingDate:String = ""
    var tableBookingTime:String = ""

    public static func showCustomTableBookingDialog(title:String, titleRightButton:String, storeID:String) -> CustomTableBookingDialog {
        let view = UINib(nibName: filterDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTableBookingDialog
        view.strStoreId = storeID
        view.getBookingSetting()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.btnReserveTable.setTitle(titleRightButton, for: .normal)
        view.lblTitle.text = title
        view.filteredArrStoreList = []
        view.deregisterFromKeyboardNotifications()
        view.registerForKeyboardNotifications()
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.filterView)
        }
        if !currentBooking.tableBookingDate.isEmpty && !currentBooking.tableBookingTime.isEmpty {
            view.tableBookingDate = currentBooking.tableBookingDate
            view.tableBookingTime = currentBooking.tableBookingTime
            view.number_of_pepole = currentBooking.number_of_pepole
            view.selectedTable = currentBooking.selectedTable
            view.bookingType = currentBooking.bookingType
        }
        view.tvData.estimatedRowHeight = 80
        view.tvData.register(UINib(nibName: "TableBookingSelectionCell", bundle: nil), forCellReuseIdentifier: "TableBookingSelectionCell")
        view.tvData.register(UINib(nibName: "TableBookingDateTimeSelectionCell", bundle: nil), forCellReuseIdentifier: "TableBookingDateTimeSelectionCell")
        view.tvData.register(UINib(nibName: "TableBookingOrderNowCell", bundle: nil), forCellReuseIdentifier: "TableBookingOrderNowCell")
        view.tvData.dataSource = view
        view.tvData.delegate = view
        view.setLocalization()
        return view
    }

    func setLocalization() {
        self.backgroundColor = UIColor.themeOverlayColor
        btnReserveTable.backgroundColor = UIColor.themeButtonBackgroundColor
        btnReserveTable.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnReserveTable.titleLabel?.font = FontHelper.textMedium()
        btnReserveTable.isEnabled = false
        btnReserveTable.alpha = 0.5
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        btnClose.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        filterView.backgroundColor = UIColor.themeViewBackgroundColor
        filterView.roundCorner(corners: [.topLeft, .topRight], withRadius: 20.0)

        if self.preferredContentSize.height <= UIScreen.main.bounds.height - 100 {
            self.heightForList.constant = self.preferredContentSize.height + tvData.frame.origin.y
        } else {
            self.heightForList.constant = UIScreen.main.bounds.height - 100
        }
    }

    override func layoutSubviews() {}

    override func updateUIAccordingToTheme() {}

    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnReserveTable(_ sender: Any) {
        currentBooking.bookingType = self.bookingType
        currentBooking.number_of_pepole = self.number_of_pepole
        currentBooking.selectedTable = self.selectedTable
        currentBooking.table_no = currentBooking.selectedTable?.table_no ?? 0
        currentBooking.tableBookingDate = self.tableBookingDate
        currentBooking.tableBookingTime = self.tableBookingTime
        currentBooking.deliveryType = DeliveryType.tableBooking
        currentBooking.selectedStoreId = currentBooking.selectedStore?._id ?? ""
        currentBooking.tableID = currentBooking.selectedTable?._id ?? ""

        if currentBooking.bookingType == 2 {
            if onClickRightButton != nil {
                onClickRightButton!()
            }
        } else {
            self.wsAddItemInServerCart()
        }
    }

    @IBAction func onClickBtnClose(_ sender: Any) {
        self.animationForHideView(filterView) { [weak self] in
            guard let self = self else { return  }
            if self.onClickLeftButton != nil{
                self.onClickLeftButton!()
            }
            self.removeFromSuperview();
        }
    }

    deinit {
        deregisterFromKeyboardNotifications()
    }

    func getBookingSetting() {
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.STORE_ID] = self.strStoreId

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.FETCH_TABLE_BOOKING_BASIC_SETTING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response, error) -> (Void) in
            guard let self = self else { return }
            if Parser.isSuccess(response: response) {
                self.responseFetchStoreSetting = ResponseFetchStoreSetting(dictionary: response)
                currentBooking.tableList = self.responseFetchStoreSetting?.storeData?.table_list ?? []
                self.arrAvailabletable = self.responseFetchStoreSetting?.storeData?.table_list ?? []
                self.tvData.beginUpdates()
                self.tvData.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
                self.tvData.endUpdates()

                if currentBooking.number_of_pepole > 0 {
                    self.isTableSelected = false
                    self.getTableList(numberOfPerson: currentBooking.number_of_pepole)
                }

                if self.responseFetchStoreSetting?.storeData?.is_table_reservation ?? false {
                    self.arrOptionForTableBooking.append("text_book_at_restaurant".localized)
                    if currentBooking.selectedTable == nil {
                        self.bookingType = 1
                    }
                }
                
                if self.responseFetchStoreSetting?.storeData?.is_table_reservation_with_order ?? false {
                    self.arrOptionForTableBooking.append("text_book_my_order_now".localized)
                    if currentBooking.selectedTable == nil {
                        self.bookingType = self.arrOptionForTableBooking.count > 0 ? 1 : 2
                    }
                }
                
                if self.arrOptionForTableBooking.count > 0 {
                    self.tvData.beginUpdates()
                    self.tvData.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
                    self.tvData.endUpdates()
                }
            }
        }
    }

    func wsAddItemInServerCart() {
        Utility.showLoading()

        let cartOrder:CartOrder = CartOrder.init()
        cartOrder.server_token = preferenceHelper.getSessionToken()
        cartOrder.user_id = preferenceHelper.getUserId()
        cartOrder.store_id = currentBooking.selectedStoreId
        cartOrder.order_details = currentBooking.cart

        let totalPrice:Double = 0.0
        let totalTax:Double = 0.0

        cartOrder.totalCartPrice =  totalPrice
        cartOrder.totalItemTax = totalTax

        if (currentBooking.destinationAddress.isEmpty || currentBooking.destinationAddress[0].address != currentBooking.deliveryAddress ) {
            let destinationAddress:Address = Address.init()
            destinationAddress.address = currentBooking.deliveryAddress
            destinationAddress.addressType = AddressType.DESTINATION
            destinationAddress.userType = CONSTANT.TYPE_USER
            destinationAddress.note = ""
            destinationAddress.city = currentBooking.currentSendPlaceData.city1
            destinationAddress.location = currentBooking.deliveryLatLng
            destinationAddress.flat_no = currentBooking.currentSendPlaceData.flat_no
            destinationAddress.street = currentBooking.currentSendPlaceData.street
            destinationAddress.landmark = currentBooking.currentSendPlaceData.landmark

            let cartUserDetail:CartUserDetail = CartUserDetail()
            cartUserDetail.email = preferenceHelper.getEmail()
            cartUserDetail.countryPhoneCode = preferenceHelper.getPhoneCountryCode()
            cartUserDetail.name = preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName()
            cartUserDetail.phone = preferenceHelper.getPhoneNumber()
            destinationAddress.userDetails = cartUserDetail
            currentBooking.destinationAddress = [destinationAddress]
        }

        if currentBooking.pickupAddress.isEmpty && (currentBooking.selectedStore != nil) {
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
            cartStoreDetail.imageUrl = mySelectedStore.image_url
            pickupAddress.userDetails = cartStoreDetail
            currentBooking.pickupAddress = [pickupAddress]
        }

        cartOrder.pickupAddress = currentBooking.pickupAddress
        cartOrder.destinationAddress = currentBooking.destinationAddress
        cartOrder.table_no = currentBooking.table_no
        cartOrder.table_id = currentBooking.tableID
        cartOrder.booking_type = currentBooking.bookingType
        cartOrder.delivery_type = currentBooking.deliveryType
        cartOrder.no_of_persons = currentBooking.number_of_pepole
        cartOrder.order_start_at = currentBooking.futureDateMilliSecondTable
        cartOrder.order_start_at2 = currentBooking.futureDateMilliSecondTable2

        let dictData:NSDictionary = (cartOrder.dictionaryRepresentation())
        dictData.setValue(currentBooking.isUseItemTax, forKey: PARAMS.IS_USE_ITEM_TAX)
        dictData.setValue(currentBooking.isTaxIncluded, forKey: PARAMS.IS_TAX_INCLUDED)
        dictData.setValue(currentBooking.totalCartAmountWithoutTax, forKey: PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX)

        print(Utility.convertDictToJson(dict: dictData as! Dictionary<String, Any>))

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData as? Dictionary<String, Any>) { [weak self] (response,error) -> (Void) in
                guard let self = self else { return  }
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                print(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))
                currentBooking.cartId = (response.value(forKey: PARAMS.CART_ID) as? String) ?? ""
                currentBooking.cartCityId = (response.value(forKey: PARAMS.CITY_ID)as? String) ?? ""
                currentBooking.storeLatLng = currentBooking.selectedStore?.location ?? [0.0,0.0]
                currentBooking.cartCurrency = currentBooking.currency
                if self.onClickRightButton != nil{
                    self.onClickRightButton!()
                }
            }
            Utility.hideLoading()
        }
    }

    func getTableList(numberOfPerson:Int) {
        arrAvailabletable.removeAll()
        for table:Table_list in responseFetchStoreSetting?.storeData?.table_list ?? [] {
            if numberOfPerson >= table.table_min_person ?? 0 && numberOfPerson <= table.table_max_person ?? 0 && table.is_user_can_book ?? false && table.is_bussiness ?? false {
                arrAvailabletable.append(table)
            }
        }
        self.tvData.beginUpdates()
        self.tvData.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        self.tvData.endUpdates()
    }

    func setUpRoundedBordersToContainer(viewContainer: UIView) {
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.borderColor = UIColor.themeLightTextColor.cgColor
        viewContainer.applyRoundedCornersWithHeight()
    }

    //MARK:- UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //MARK:- Userdefine Function
    func checkTableBookingValidation() -> Bool {
        if !self.tableBookingDate.isEmpty() && !self.tableBookingTime.isEmpty() && self.number_of_pepole != 0 && self.selectedTable != nil {
            return true
        }
        return false
    }

    func setReserveTableButtonEnableDisable() {
        if self.checkTableBookingValidation() {
            btnReserveTable.backgroundColor = UIColor.themeButtonBackgroundColor
            btnReserveTable.isEnabled = true
            btnReserveTable.alpha = 1.0
        } else {
            btnReserveTable.backgroundColor = UIColor.themeButtonBackgroundColor
            btnReserveTable.isEnabled = false
            btnReserveTable.alpha = 0.5
        }
    }
}

//MARK:- Tableview Methods

extension CustomTableBookingDialog:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:TableBookingDateTimeSelectionCell = tableView.dequeueReusableCell(withIdentifier: "TableBookingDateTimeSelectionCell",for:indexPath) as! TableBookingDateTimeSelectionCell
            cell.setCellData(date: self.tableBookingDate, time: self.tableBookingTime)
            cell.viewForDate.tag = 0
            cell.viewForTime.tag = 1
            cell.viewForDate.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onClickBtnDate(_:))))
            cell.viewForTime.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onClickBtnDate(_:))))
            return cell
        } else if indexPath.row == 1 {
            let cell:TableBookingSelectionCell = tableView.dequeueReusableCell(withIdentifier: "TableBookingSelectionCell",for:indexPath) as! TableBookingSelectionCell
            cell.setCellData(cellItem: "text_no_of_people".localized)
            cell.onItemSelected = { [weak self] index in
                guard let self = self else { return }
                self.number_of_pepole = index + 1
                self.selectedTable = nil
                self.isTableSelected = false
                self.getTableList(numberOfPerson: index + 1)
                self.setReserveTableButtonEnableDisable()
            }
            return cell
        } else if indexPath.row == 2 {
            let cell:TableBookingSelectionCell = tableView.dequeueReusableCell(withIdentifier: "TableBookingSelectionCell",for:indexPath) as! TableBookingSelectionCell
            cell.setCellData(cellItem: self.arrAvailabletable, isTableSelected: self.isTableSelected, selectedTable: self.selectedTable)
            cell.onItemSelected = {  [weak self] index in
                guard let self = self else { return }
                self.selectedTable = self.arrAvailabletable[index]
                currentBooking.booking_fees = self.responseFetchStoreSetting?.storeData?.booking_fees ?? 0.0
                self.setReserveTableButtonEnableDisable()
            }
            return cell
        } else {
            let cell:TableBookingOrderNowCell = tableView.dequeueReusableCell(withIdentifier: "TableBookingOrderNowCell",for:indexPath) as! TableBookingOrderNowCell
            cell.setCellData(arrOrderOptions: arrOptionForTableBooking, bookingType: self.bookingType)
            cell.onItemSelected = { [weak self] index in
                guard let self = self else { return }
                self.bookingType = index+1
                self.setReserveTableButtonEnableDisable()
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return UITableView.automaticDimension
        } else {
            return 80
        }
    }

    //MARK: - Button Click
    @IBAction func onClickBtnDate(_ sender: UITapGestureRecognizer) {
        let selectedStoreSlotTime:[StoreTime] = self.responseFetchStoreSetting?.storeData?.booking_time ?? []
        
        if sender.view?.tag == 0 {
            let datePickerDialog:CustomDateSlotPickerDialog = CustomDateSlotPickerDialog.showCustomDatePickerSlotDialog(title: "TXT_SELECT_FUTURE_ORDER_DATE".localized, titleLeftButton: "".localized, titleRightButton: "TXT_SELECT".localized, mode: .date, reservationMaxDays: self.responseFetchStoreSetting?.storeData?.reservation_max_days ?? 7)
            datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
            }
            datePickerDialog.onClickRightButton = { [unowned self, unowned datePickerDialog] (selectedDate:String, selectedDayIndex:Int) in
                self.selectedDateStr = selectedDate
                self.selectedDayInd = selectedDayIndex
                datePickerDialog.removeFromSuperview()
                if selectedStoreSlotTime.count-1 >= self.selectedDayInd {
                    if !(selectedStoreSlotTime[self.selectedDayInd].is_booking_open_full_time ?? false) {
                        if selectedStoreSlotTime[self.selectedDayInd].dayTime!.count > 0 && selectedStoreSlotTime[selectedDayInd].is_booking_open ?? false {
                            self.showCustomDialogTime(ind: self.selectedDayInd, selectedDateStr:self.selectedDateStr)
                        } else {
                            Utility.showToast(message:"TXT_STORE_IS_CLOSED".localized)
                        }
                    } else {
                        self.showCustomDialogTime(ind: self.selectedDayInd, selectedDateStr:self.selectedDateStr)
                    }
                }
            }
        } else {
            self.showCustomDialogTime(ind: selectedDayInd, selectedDateStr:selectedDateStr)
        }
    }

    func showCustomDialogTime(ind:Int, selectedDateStr:String) {
        let timeZone:TimeZone = TimeZone.init(identifier:currentBooking.selectedCityTimezone)!
        let selectedStoreSlotTime:[StoreTime] = self.responseFetchStoreSetting?.storeData?.booking_time ?? []

        if selectedDateStr.count <= 0 {
            Utility.showToast(message: "TXT_SELECT_DATE_FIRST".localized)
        } else {
            let selectedDateDay = Utility.getDayFromDate(date: selectedDateStr)
            if selectedStoreSlotTime.count-1 >= ind {
                let datePickerDialog:CustomTimeSlotPickerDialog = CustomTimeSlotPickerDialog.showCustomTimePickerSlotDialog(title: "TXT_SELECT_FUTURE_ORDER_TIME".localized, titleLeftButton: "".localized, titleRightButton: "TXT_SELECT".localized, selectedStoreSlot:selectedStoreSlotTime[ind], selectedDayInd: ind, selectedDateDay: selectedDateDay, scheduleTimeInterval:(currentBooking.selectedStore?.schedule_order_create_after_minute ?? 0), timeZone: timeZone, isTableBooking:true)
                datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                    datePickerDialog.removeFromSuperview()
                }
                datePickerDialog.onClickRightButton = { [weak self, unowned datePickerDialog] (selectedTimeSlot:String, isStoreClosed:Bool) in
                    if selectedTimeSlot.count > 0 {
                        DispatchQueue.main.async {
                            let selectedDate : Date = Utility.stringToDate(strDate: "\(selectedDateStr) \(selectedTimeSlot.components(separatedBy: "-")[0].removingWhitespaces())", withFormat: DATE_CONSTANT.DATE_FORMATE_SLOT)
                            let selectedDate2 : Date = Utility.stringToDate(strDate: "\(selectedDateStr) \(selectedTimeSlot.components(separatedBy: "-")[1].removingWhitespaces())", withFormat: DATE_CONSTANT.DATE_FORMATE_SLOT)
                            currentBooking.futureDateMilliSecond = Utility.convertSelectedDateToMilliSecond(serverDate: selectedDate, strTimeZone: timeZone.identifier)
                            currentBooking.futureDateMilliSecond2 = Utility.convertSelectedDateToMilliSecond(serverDate: selectedDate2, strTimeZone: timeZone.identifier)

                            let offSetMiliSecond = timeZone.secondsFromGMT() * 1000
                            currentBooking.isFutureOrder = true
                            currentBooking.futureUTCMilliSecond = currentBooking.futureDateMilliSecond - Int64.init(offSetMiliSecond)
                            currentBooking.futureUTCMilliSecond2 = currentBooking.futureDateMilliSecond2 - Int64.init(offSetMiliSecond)

                            let components = Calendar.current.dateComponents(in: timeZone, from: selectedDate)

                            self?.tableBookingDate = String(components.day!)  +  "-" + String(components.month!) +  "-" +  String(components.year!)
                            self?.tableBookingTime = selectedTimeSlot

                            self?.tvData.beginUpdates()
                            self?.tvData.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                            self?.tvData.endUpdates()

                            self?.setReserveTableButtonEnableDisable()
                        }
                    }
                    datePickerDialog.removeFromSuperview()
                }
            }
        }
    }
}
