//
//  StoreTimeVC.swift
//  
//
//  Created by Jaydeep on 06/10/17.
//
import  UIKit
import Foundation




class StoreTimeVC: BaseVC,UITextFieldDelegate,RightDelegate
     {
   
    @IBOutlet weak var btnSun: UIButton!
    @IBOutlet weak var btnMon: UIButton!
    @IBOutlet weak var btnTue: UIButton!
    @IBOutlet weak var btnWed: UIButton!
    @IBOutlet weak var btnThu: UIButton!
    @IBOutlet weak var btnFri: UIButton!
    @IBOutlet weak var btnSat: UIButton!
    @IBOutlet weak var imgStartTime: UIImageView!
    @IBOutlet weak var imgEndTime: UIImageView!

    @IBOutlet weak var btnAddTime: UIButton!
    /* View For Add Store Time*/
    @IBOutlet weak var viewForAddTime: UIView!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    
    /*View For Store Time*/
    @IBOutlet weak var viewForStoreTime: UIView!
    @IBOutlet weak var switchIsStoreOpen: UISwitch!
    @IBOutlet weak var switchIsStoreOpenForWholeDay: UISwitch!
    @IBOutlet weak var lblStoreOpenForWholeDay: UILabel!
    @IBOutlet weak var lblTxtOpenTime: UILabel!
    @IBOutlet weak var lblTxtCloseTime: UILabel!

    @IBOutlet weak var lblStoreOpen: UILabel!
    @IBOutlet weak var tblForStoreTime: UITableView!
    @IBOutlet weak var imgTimeOpen: UIImageView!
    @IBOutlet weak var imgTimeClose: UIImageView!

    var selectedDay = Day(rawValue:0)!
    var selectedOpenTime:Date = Date()
    var selectedCloseTime:Date = Date()
    var password:String = ""
    var isUpdate = false;/*Variables*/
    var arrForStoreTime:[StoreTime] = StoreSingleton.shared.store.storeTime
    var arrForSelectedDayStoreTime:[DayTime] = []
    var isFromStoreDeliveryTime : Bool = false
    
    //View For Add For Product
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateRight = self
        arrForStoreTime.removeAll()
        if !isFromStoreDeliveryTime{
            arrForStoreTime = StoreSingleton.shared.store.storeTime
        }else{
            arrForStoreTime = StoreSingleton.shared.store.storeDeliveryTime
        }
        arrForStoreTime = arrForStoreTime.sorted{ $0.day < $1.day }
        self.setRightBarItem(isNative: false)
        setLocalization()
        arrForSelectedDayStoreTime.removeAll()
        btnSun.isSelected = true
        setStoreDayData(day: selectedDay)
        tblForStoreTime.tableFooterView = UIView()
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isUpdate = false
        self.switchIsStoreOpenForWholeDay.isEnabled = false
        self.enable(isEnable: false)
//        self.setRightBarItemImage(image: UIImage.init(named: "editBlackIcon")!)
//        self.setRightBarItemImage(image: UIImage(), title: "TXT_EDIT".localized, mode: .center)
//        self.setrightBarItemBG()
        
        let image = UIImage.init(named: "edit")!.imageWithColor(color: .themeColor)!
        self.setRightBarItemImage(image: image)

    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
        
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    func setLocalization() {
        
        /*set colors*/
        
        viewForAddTime.backgroundColor = UIColor.themeViewBackgroundColor
        viewForStoreTime.backgroundColor = UIColor.themeViewBackgroundColor
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        lblTxtOpenTime.textColor = UIColor.themeLightTextColor
        lblTxtCloseTime.textColor = UIColor.themeLightTextColor
        
        lblStoreOpenForWholeDay.textColor = UIColor.themeTextColor
        lblStoreOpen.textColor = UIColor.themeTextColor
        
        txtEndTime.textColor = UIColor.themeTextColor
        txtStartTime.textColor = UIColor.themeTextColor
        
        btnAddTime.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
         btnAddTime.backgroundColor = UIColor.themeColor
        btnAddTime.setTitle("TXT_ADD_TIME".localizedCapitalized, for: .normal);
        
        tblForStoreTime.backgroundColor = UIColor.themeViewBackgroundColor
        
        txtStartTime.borderStyle = .roundedRect
        txtStartTime.tintColor = .themeTextColor
        txtEndTime.borderStyle = .roundedRect
        txtEndTime.tintColor = .themeTextColor

        switchIsStoreOpen.onTintColor = UIColor.themeColor
        switchIsStoreOpenForWholeDay.onTintColor = UIColor.themeColor
        
        btnSun.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnMon.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnTue.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnWed.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnThu.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnFri.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnSat.setTitleColor(UIColor.themeLightTextColor, for: .normal)

        btnSun.setTitleColor(UIColor.themeColor, for: .selected)
        btnMon.setTitleColor(UIColor.themeColor, for: .selected)
        btnTue.setTitleColor(UIColor.themeColor, for: .selected)
        btnWed.setTitleColor(UIColor.themeColor, for: .selected)
        btnThu.setTitleColor(UIColor.themeColor, for: .selected)
        btnFri.setTitleColor(UIColor.themeColor, for: .selected)
        btnSat.setTitleColor(UIColor.themeColor, for: .selected)

        
        btnSun.backgroundColor = UIColor.themeViewBackgroundColor
        btnMon.backgroundColor = UIColor.themeViewBackgroundColor
        btnTue.backgroundColor = UIColor.themeViewBackgroundColor
        btnWed.backgroundColor = UIColor.themeViewBackgroundColor
        btnThu.backgroundColor = UIColor.themeViewBackgroundColor
        btnFri.backgroundColor = UIColor.themeViewBackgroundColor
        btnSat.backgroundColor = UIColor.themeViewBackgroundColor
        
        
        lblTxtCloseTime.font = FontHelper.textRegular(size: 13.0)
        lblTxtOpenTime.font = FontHelper.textRegular(size: 13.0)
        lblTxtOpenTime.text = "TXT_OPEN_TIME".localizedCapitalized
        lblTxtCloseTime.text = "TXT_CLOSE_TIME".localizedCapitalized
        
        
        /*Set Font*/
        
        lblStoreOpen.font = FontHelper.textRegular()
        lblStoreOpenForWholeDay.font = FontHelper.textRegular()
        btnSun.titleLabel?.font = FontHelper.textMedium(size: 14)
        btnMon.titleLabel?.font = FontHelper.textMedium(size: 14)
        btnTue.titleLabel?.font = FontHelper.textMedium(size: 14)
        btnWed.titleLabel?.font = FontHelper.textMedium(size: 14)
        btnThu.titleLabel?.font = FontHelper.textMedium(size: 14)
        btnFri.titleLabel?.font = FontHelper.textMedium(size: 14)
        btnSat.titleLabel?.font = FontHelper.textMedium(size: 14)
        txtStartTime.font = FontHelper.textRegular()
        txtEndTime.font = FontHelper.textRegular()
        
        //Set Text
//        self.setNavigationTitle(title: "TXT_STORE_TIME".localized)
        
        if !isFromStoreDeliveryTime{
            self.setNavigationTitle(title: "TXT_STORE_TIME".localized)
            self.lblStoreOpen.text = "TXT_STORE_OPEN".localized

        }else{
            self.setNavigationTitle(title: "TXT_IS_SET_DELIVERY_STORE_TIME".localized)
            self.lblStoreOpen.text = "TXT_STORE_PROVIDE_PICKUP_DELIVERY".localized

            
        }
        
        btnSun.setTitle(Day.SUN.text(), for: .normal)
        btnMon.setTitle(Day.MON.text(), for: .normal)
        btnTue.setTitle(Day.TUE.text(), for: .normal)
        btnWed.setTitle(Day.WED.text(), for: .normal)
        btnThu.setTitle(Day.THU.text(), for: .normal)
        btnFri.setTitle(Day.FRI.text(), for: .normal)
        btnSat.setTitle(Day.SAT.text(), for: .normal)
        
        self.lblStoreOpenForWholeDay.text = "TXT_STORE_OPEN_FOR_FULL_TIME".localized
        self.txtStartTime.placeholder = "TXT_START_TIME".localized
        self.txtEndTime.placeholder = "TXT_END_TIME".localized
        self.txtEndTime.text = ""
        self.txtStartTime.text = ""
        
        updateUIAccordingToTheme()
     }
    
    override func updateUIAccordingToTheme() {
        imgTimeOpen.image = UIImage.init(named: "time")!.imageWithColor(color: .themeIconTintColor)!
        imgTimeClose.image = UIImage.init(named: "time")!.imageWithColor(color: .themeIconTintColor)!
        txtStartTime.layer.borderColor = UIColor.themeTextColor.cgColor
        txtEndTime.layer.borderColor = UIColor.themeTextColor.cgColor
        
        txtStartTime.layer.borderWidth = 0.1
        txtEndTime.layer.borderWidth = 0.1
        
        imgStartTime.image = UIImage(named: "time")?.imageWithColor(color: .themeIconTintColor)
        imgEndTime.image = UIImage(named: "time")?.imageWithColor(color: .themeIconTintColor)
        
        self.tblForStoreTime.reloadData()
    }

    func onClickRightButton() {
            if isUpdate {
                if !preferenceHelper.getSocialId().isEmpty() {
                    self.password = ""
                    self.wsStoreTime()
                }
                else {
                    self.openVerifyAccountDialog();
                }
            }else {
                isUpdate = true
                self.setStoreDayData(day: selectedDay)
            }
        
//            self.setRightBarItemImage(image: UIImage.init(named: "doneBlackIcon")!)
//        self.setRightBarItemImage(image: UIImage(), title: "TXT_SAVE".localized, mode: .center)
//        self.setrightBarItemBG()
        self.setRightBarItemImage(image: UIImage(named: "correct")!.imageWithColor(color: .themeColor)!, title: "", mode: .center)

    }
    func setStoreDayData(day:Day) {
        arrForSelectedDayStoreTime.removeAll()
        for storeTime:StoreTime in arrForStoreTime {
            if storeTime.day == day.rawValue {
                arrForSelectedDayStoreTime.removeAll()
                switchIsStoreOpenForWholeDay.isOn = storeTime.isStoreOpenFullTime
                switchIsStoreOpen.isOn = storeTime.isStoreOpen
                for time in storeTime.dayTime {
                    arrForSelectedDayStoreTime.append(time)
                }
                if isUpdate {
                if switchIsStoreOpenForWholeDay.isOn {
                    self.enable(isEnable: false)
                }
                else
                     {
                    self.enable(isEnable: true)
                }
                }
                break;
                
            }
            
        }
        
        tblForStoreTime.reloadData()
        self.txtEndTime.text = ""
        self.txtStartTime.text = ""
    }
    //MARK:- Action Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtStartTime {
        showTimePicker(isOpenTime: true)
        }else {
        showTimePicker(isOpenTime: false)
        }
        
        return false
    }
    
    @IBAction func onClickSwOpenFor24(_ sender: Any) {
        let storeTime:StoreTime = self.arrForStoreTime[selectedDay.rawValue]
            
        storeTime.isStoreOpenFullTime = switchIsStoreOpenForWholeDay.isOn
        print(selectedDay.rawValue)
        
        
        
        print(storeTime.toDictionary())
        if switchIsStoreOpenForWholeDay.isOn {
            storeTime.isStoreOpen = true
            self.switchIsStoreOpen.isOn = true
            self.enable(isEnable: false)
        }else
         {
            self.enable(isEnable: true)
        }
        
    }
    func enable(isEnable:Bool) {
       
        if isUpdate {
            self.switchIsStoreOpenForWholeDay.isEnabled = true
        }else {
            self.switchIsStoreOpenForWholeDay.isEnabled = false
        }
        self.switchIsStoreOpen.isEnabled = isEnable
        tblForStoreTime.isUserInteractionEnabled = isEnable
        btnAddTime.isEnabled = isEnable
        txtEndTime.isEnabled = isEnable
        txtStartTime.isEnabled = isEnable
        
    }
    @IBAction func onClickStoreOpen(_ sender: UISwitch) {
        self.arrForStoreTime[selectedDay.rawValue].isStoreOpen = switchIsStoreOpen.isOn
    }
    //MARK:- User Define Methods
    func showTimePicker(isOpenTime:Bool
         = false)
     {
    
        let title = isOpenTime ? "TXT_SELECT_OPEN_TIME".localized : "TXT_SELECT_CLOSE_TIME".localized
        let dialogForTimePicker:CustomTimePicker = CustomTimePicker.showCustomTimePickerDialog(title:title, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, openingTime: txtStartTime.text!,isOpenTime:isOpenTime)
        
        
        dialogForTimePicker.onClickLeftButton = { [unowned dialogForTimePicker] in
                dialogForTimePicker.removeFromSuperview();
        }
        dialogForTimePicker.onClickRightButton = {[unowned dialogForTimePicker, unowned self] 
                
                (selectedTime:Date) in
                
                let strSelectedTime:String = Utility.dateToString(date: selectedTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
                
                if isOpenTime {
                self.txtStartTime.text = strSelectedTime
                self.selectedOpenTime = selectedTime
                }
                else {
                self.txtEndTime.text = strSelectedTime
                self.selectedCloseTime = selectedTime
                }
                
                dialogForTimePicker.removeFromSuperview();
                
        }
        
        
    }
    @IBAction func onClickBtnDay(_ sender: UIButton) {
        btnSun.isSelected = false
        btnMon.isSelected = false
        btnTue.isSelected = false
        btnWed.isSelected = false
        btnThu.isSelected = false
        btnFri.isSelected = false
        btnSat.isSelected = false
        sender.isSelected = true
        
        selectedDay = Day(rawValue: sender.tag)!
        self.setStoreDayData(day: selectedDay)
        
    }
    
    //MARK: TableViewDelegateMethods
    
@IBAction func onClickTimePicker(_ sender: Any) {
        if (self.txtStartTime.text?.isEmpty())! || (self.txtEndTime.text?.isEmpty())! {
            Utility.showToast(message: "MSG_PLEASE_SELECT_TIME".localized)
        }else {
        let openT = isValidOpenTime()
        let clostT = isValidCloseTime()
        if  openT && clostT {
            let selectedTime:DayTime = DayTime.init()
            
            selectedTime.storeOpenTime = txtStartTime.text
            selectedTime.storeCloseTime = txtEndTime.text
            self.arrForSelectedDayStoreTime.append(selectedTime)
            self.sortArray()
            self.arrForStoreTime[selectedDay.rawValue].dayTime = self.arrForSelectedDayStoreTime
            txtStartTime.text = ""
            txtEndTime.text = ""
            self.tblForStoreTime.reloadData();
            
        }else {
            if  !openT {
                
                self.txtStartTime.text = ""
                Utility.showToast(message: "MSG_INVALID_OPEN_TIME".localized)
            }else {
                
                self.txtEndTime.text = ""
                Utility.showToast(message: "MSG_INVALID_CLOSE_TIME".localized)
            }
        }
            
        }
    }
    
    func sortArray() {
        self.arrForSelectedDayStoreTime.sort { (date1, date2) -> Bool in
            let openTime1:Date = Utility.stringToDate(strDate: date1.storeOpenTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
            let openTime2:Date = Utility.stringToDate(strDate: date2.storeOpenTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
            return openTime1.compare(openTime2) == .orderedAscending
        }
    }
    
    func isValidOpenTime() -> Bool {
        let strOpenTime = Utility.dateToString(date: selectedOpenTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        let newOpenTime:Date = Utility.stringToDate(strDate: strOpenTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        
        let strCloseTime = Utility.dateToString(date: selectedCloseTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        let newCloseTime:Date = Utility.stringToDate(strDate: strCloseTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        if (self.arrForSelectedDayStoreTime.isEmpty) {
            
            return true;
        }else {
            
            for time in arrForSelectedDayStoreTime {
                  let openTime:Date = Utility.stringToDate(strDate: time.storeOpenTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
             
                  let closeTime:Date = Utility.stringToDate(strDate: time.storeCloseTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
                if(( openTime <= newOpenTime) && (newOpenTime <= closeTime )) {
                    return false
                }
                else if(newOpenTime <= openTime && closeTime <= newCloseTime) {
                    return false
                }
                
            }
            return true;
        }
    }
    func isValidCloseTime() -> Bool {
        let strOpenTime = Utility.dateToString(date: selectedOpenTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        let strCloseTime = Utility.dateToString(date: selectedCloseTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        let newOpenTime:Date = Utility.stringToDate(strDate: strOpenTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        let newCloseTime:Date = Utility.stringToDate(strDate: strCloseTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
        
        if (self.arrForSelectedDayStoreTime.isEmpty) {
            return newOpenTime < newCloseTime
        }else {
            
            if (newCloseTime > newOpenTime) {
                for time in arrForSelectedDayStoreTime {
                
                    let openTime:Date = Utility.stringToDate(strDate: time.storeOpenTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
                    
                    let closeTime:Date = Utility.stringToDate(strDate: time.storeCloseTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
                    
                    
                    if (newCloseTime >= openTime && newCloseTime <= closeTime)
                    {
                        return false;
                        
                    }
                    else if (newOpenTime <= openTime && newCloseTime >=
                        closeTime)
                    {
                        return false;
                    }
                }
                return true
            }else {
                    return false;
            }
        }
    }
    //update Store Time
    
    func wsStoreTime() {
        
        
        var storeUpdateTime:[[String:Any]] = []
//        for storeTime:StoreTime in StoreSingleton.shared.store.storeTime {
//            storeUpdateTime.append(storeTime.toDictionary())
//        }
        
        if !isFromStoreDeliveryTime{
            for storeTime:StoreTime in StoreSingleton.shared.store.storeTime {
                storeUpdateTime.append(storeTime.toDictionary())
            }
        }else{
            for storeTime:StoreTime in StoreSingleton.shared.store.storeDeliveryTime {
                storeUpdateTime.append(storeTime.toDictionary())
            }
        }

        
       /* let dictParam : [String : Any] =
            [
             PARAMS.OLD_PASSWORD: password,
             PARAMS.STORE_TIME : storeUpdateTime,
             PARAMS.SOCIAL_ID: preferenceHelper.getSocialId(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID: preferenceHelper.getUserId()
        ]*/
        var dictParam : [String : Any] = [:]
        if !isFromStoreDeliveryTime {
            dictParam  = [
                 PARAMS.OLD_PASSWORD: password,
                 PARAMS.STORE_TIME : storeUpdateTime,
                 PARAMS.SOCIAL_ID: preferenceHelper.getSocialId(),
                 PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
                 PARAMS.STORE_ID: preferenceHelper.getUserId()
            ]
        }else{
           dictParam =
                [
                 PARAMS.OLD_PASSWORD: password,
                 "store_delivery_time" : storeUpdateTime,
                 PARAMS.SOCIAL_ID: preferenceHelper.getSocialId(),
                 PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
                 PARAMS.STORE_ID: preferenceHelper.getUserId()
            ]
        }
        
        print(Utility.conteverDictToJson(dict: dictParam))
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        Utility.showLoading()
        alamoFire.getResponseFromURL(url: WebService.WS_UPDATE_STORE_TIME, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                print(response)
                if let storeData = response["store"] as? [String:Any] {
                    if !self.isFromStoreDeliveryTime{
                        StoreSingleton.shared.store.storeTime = Store(fromDictionary: storeData).storeTime
                   }else{
                       StoreSingleton.shared.store.storeDeliveryTime = Store(fromDictionary: storeData).storeDeliveryTime
                   }
                }
                _ = self.navigationController?.popViewController(animated: true);
                
            }
            Utility.hideLoading()
        }
    }

    func openVerifyAccountDialog() {
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "MSG_PLEASE_ENTER_CURRENT_PASSWORD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_PASSWORD".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: true)
        dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
            dialogForVerification.removeFromSuperview();
        }
        dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self] (text1:String,text2:String) in
            let validPassword = text1.checkPasswordValidation()
            if validPassword.0 == false {
               
                Utility.showToast(message: validPassword.1);
            } else {
                self.password = text1
                self.wsStoreTime();
                dialogForVerification.removeFromSuperview();
            }
        }
    }
}

extension StoreTimeVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (arrForSelectedDayStoreTime.count)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell:StoreTimeCell? = tableView.dequeueReusableCell(withIdentifier: "storeTimeCell", for: indexPath) as? StoreTimeCell
        if cell == nil {
            
            cell = StoreTimeCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "storeTimeCell")
            
        }
        cell?.btnRemoveTime.tag = indexPath.row
        cell?.btnRemoveTime?.setImage(UIImage.init(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)

        cell?.setCellData(dayTime: (arrForSelectedDayStoreTime[indexPath.row]), parent: self)
        return cell!
        
    }
    
}


class StoreTimeCell: CustomCell {
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnRemoveTime: UIButton!
    weak var parent:StoreTimeVC? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblTime.font = FontHelper.textRegular()
        self.lblTime.textColor = UIColor.themeTextColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - set cell data
    func setCellData(dayTime:DayTime,parent:Any) {
        self.parent = parent as? StoreTimeVC
        self.lblTime.text = dayTime.storeOpenTime + " to " + dayTime.storeCloseTime
        
    }
    @IBAction func onClickRemoveStoreTime(_ sender: UIButton) {
        if (self.parent?.isKind(of: StoreTimeVC.self))! {
            
            self.parent?.arrForSelectedDayStoreTime.remove(at: sender.tag)
            self.parent?.arrForStoreTime[(self.parent?.selectedDay.rawValue)!].dayTime = self.parent?.arrForSelectedDayStoreTime
            self.parent?.tblForStoreTime.reloadData()
        }
    }
    
    
}

