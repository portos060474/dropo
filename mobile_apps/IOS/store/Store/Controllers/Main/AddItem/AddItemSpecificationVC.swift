//
//  AddItemSpecificationVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 03/04/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

protocol SendSubItemDetailDelegate: AnyObject {
    func saveSubItemDetail(_ item_spec: ItemSpecification?, parentSpec: ItemSpecification?, isEditedSpec: Bool)
    func deleteAndReplace(_ item_spec: ItemSpecification?)
}

class AddItemSpecificationVC: BaseVC {
    let downArrow:String = "\u{25BC}"
    @IBOutlet weak var btnSelectRangeType: UIButton!
    weak var delegate: SendSubItemDetailDelegate?
    @IBOutlet weak var txtItemSpeciicationName: UITextField!
    @IBOutlet weak var lblIsRequired: UILabel!
    @IBOutlet weak var swIsRequired: UISwitch!
    @IBOutlet weak var lblAddSpecification: UILabel!
    @IBOutlet weak var tableSpecifications: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var txtFixRange: UITextField!
    @IBOutlet weak var txtMinRange: UITextField!
    @IBOutlet weak var txtMaxRange: UITextField!
    @IBOutlet weak var txtSequenceNumber: UITextField!

    @IBOutlet weak var viewForNavigation: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var  btnRight : UIButton!
    
    @IBOutlet weak var  viewAssociated: UIView!
    @IBOutlet weak var  lblAssociated: UILabel!
    @IBOutlet weak var  switchAssociated: UISwitch!
    
    @IBOutlet weak var  viewSelectSPGroup: UIView!
    @IBOutlet weak var  viewSelectSP: UIView!
    
    @IBOutlet weak var  lblSelectSPGroup: UILabel!
    @IBOutlet weak var  lblSelectSP: UILabel!
    
    @IBOutlet weak var  btnSelectSPGroup: UIButton!
    @IBOutlet weak var  btnSelectSP: UIButton!
    
    @IBOutlet weak var stackViewAssociatedSP: UIStackView!
    
    @IBOutlet weak var viewMainAssociated: UIView!
    
    @IBOutlet weak var btnSwitch: UIButton!
    
    @IBOutlet weak var viewUserCanAddQuantity: UIView!
    @IBOutlet weak var lblUserCanAddQuantity: UILabel!
    @IBOutlet weak var switchUserCanAddQuantity: UISwitch!

    var specificationOrignalDetail:ItemSpecification? = nil
    
    var arrProductSpecification = [List]()
    var isForEditSpecification:Bool = false
    var isTypeSingle:Bool = false
    
    var startRange:Int = 0
    var endRange:Int = 0
    
    let selectRangeType = DropDown()
    let rangeList = ["TXT_SELECT".localized, "TXT_RANGE".localized ]
    
    var pickerViewSPGroup = UIPickerView()
    var pickerViewSP = UIPickerView()
    
    var lastSelectIndexSpGroup = -1
    var lastSelectIndexSp = -1
    
    var arrSavedProductSpecification = [ItemSpecification]()
    var arrDropDownSpGroup = [ItemSpecification]()
    var arrDropDownSp = [List]()
    var isDeleteAndReplace = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        self.setData()
        self.reloadTableData()
        setAccosiateGroup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRangeDropDown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRangeDropDown() {
       /* selectRangeType.anchorView = btnSelectRangeType
        selectRangeType.backgroundColor = UIColor.themeViewBackgroundColor
        selectRangeType.textColor = UIColor.themeTextColor
        selectRangeType.textFont = FontHelper.textRegular(size: FontHelper.regular)
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        selectRangeType.bottomOffset = CGPoint(x: 10, y: btnSelectRangeType.bounds.height+15)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        selectRangeType.dataSource = rangeList
        
        // Action triggered on selection
        selectRangeType.selectionAction = { [weak self] (index, item) in
            self?.btnSelectRangeType.setTitle(item + "  " + (self?.downArrow)!, for: .normal)
            if index == 0 {
                self?.txtFixRange.isHidden = false
                self?.txtMinRange.isHidden = true
                self?.txtMaxRange.isHidden = true
                self?.txtFixRange.text = "0"
                self?.txtMaxRange.text = "1"
                self?.txtMinRange.text = "0"
                self?.btnSelectRangeType.isSelected = false
            }else {
                self?.btnSelectRangeType.isSelected = true
                self?.txtFixRange.isHidden = true
                self?.txtMinRange.isHidden = false
                self?.txtMaxRange.isHidden = false
                self?.txtFixRange.text = "0"
                self?.txtMaxRange.text = "1"
                self?.txtMinRange.text = "0"
                
            }
        }*/
    }
    
    func setAccosiateGroup() {
        if isForEditSpecification {
            if specificationOrignalDetail?.isAssociated ?? false {
                lblSelectSPGroup.text = specificationOrignalDetail?.modifierGroupName
                lblSelectSP.text = specificationOrignalDetail?.modifierName
                switchAssociated.isOn = true
                setViewAccordingSwitch(isToast: false)
            } else {
                switchAssociated.isOn = false
                setViewAccordingSwitch(isToast: false)
                setAssociatedViews(switchViewHidden: false, viewSpGroupHide: true, viewSpHide: true)
            }
            switchAssociated.isUserInteractionEnabled = false
            btnSelectSPGroup.isUserInteractionEnabled = false
            btnSwitch.isUserInteractionEnabled = false
            btnSelectSP.isUserInteractionEnabled = false
        } else {
            
            lblSelectSPGroup.text = "TXT_SELECT".localized
            lblSelectSP.text = "TXT_SELECT".localized
            switchAssociated.isOn = false
            setViewAccordingSwitch(isToast: false)
            self.arrDropDownSpGroup = getNonAssociatedGrops()
                        
            let findAlreadyAssociate = arrSavedProductSpecification.filter({$0.id == specificationOrignalDetail?.id})
            
            if findAlreadyAssociate.count > 0 {
                lastSelectIndexSpGroup = 0
                switchAssociated.isOn = false
                if arrDropDownSpGroup.count > 0 {
                    if getSpesificationsList().count == 0 {
                        switchAssociated.isUserInteractionEnabled = false
                        btnSelectSPGroup.isUserInteractionEnabled = false
                        btnSelectSP.isUserInteractionEnabled = false
                        setAssociatedViews(switchViewHidden: false, viewSpGroupHide: true, viewSpHide: true)
                    } else {
                        setViewAccordingSwitch(isToast: false)
                    }
                } else {
                    setViewAccordingSwitch(isToast: false)
                }
            } else {
                setAssociatedViews(switchViewHidden: false, viewSpGroupHide: true, viewSpHide: true)
            }
        }
    }

    //MARK: -
    //MARK: - Custom setup,Localization,Color & Font
    func setLocalization() -> Void {
        self.txtItemSpeciicationName.placeholder = "TXT_ITEM_SPECIFICATION_NAME".localized
        self.lblIsRequired.text = "TXT_IS_REQUIRED_OR_NOT".localized
        self.lblAddSpecification.text = "TXT_ADD_SPECIFICATION".localized
        
        lblUserCanAddQuantity.text = "txt_user_can_add_modifier_qty".localized
        lblUserCanAddQuantity.textColor = UIColor.themeTextColor
        lblUserCanAddQuantity.font = FontHelper.textRegular()
        
        viewUserCanAddQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        switchUserCanAddQuantity.onTintColor = .themeColor
        
        self.btnSelectRangeType.setTitleColor(.themeTextColor, for: .normal)
        self.btnSelectRangeType.setTitleColor(.themeTextColor, for: .selected)

//        self.btnSelectRangeType.titleLabel?.textColor = .themeTextColor
        self.btnSelectRangeType.titleLabel?.font = FontHelper.textRegular()
        
        self.btnSelectRangeType.setTitle(rangeList[0] + "  " + downArrow, for: .normal)
        self.btnSelectRangeType.setTitle(rangeList[1] + "  " + downArrow, for: .selected)
        self.txtFixRange.text = "0"
        self.txtMaxRange.text = "1"
        self.txtMinRange.text = "0"
        self.lblTitle.text = "TXT_ADD_ITEM_SPECIFICATION".localized
        self.lblTitle.textColor = UIColor.themeTitleColor
        self.lblTitle.font = FontHelper.textMedium()
        
        self.txtSequenceNumber.placeholder =  "TXT_SEQUENCE_NUMBER".localized
        self.txtSequenceNumber.textColor = UIColor.themeTextColor

        self.viewForNavigation.backgroundColor = UIColor.themeViewBackgroundColor
        switchAssociated.onTintColor = UIColor.themeColor
        
        //SET COLORS
        txtItemSpeciicationName.textColor = UIColor.themeTextColor
        lblIsRequired.textColor = UIColor.themeLightTextColor
        lblAddSpecification.textColor = UIColor.themeLightTextColor
        txtItemSpeciicationName.textColor = UIColor.themeTextColor
     
        txtMaxRange.placeholder = "TXT_MAX_RANGE".localized
        txtMaxRange.font = FontHelper.textRegular()
        txtMaxRange.textColor = UIColor.themeTextColor
        
        txtMinRange.placeholder = "TXT_MIN_RANGE".localized
        txtMinRange.font = FontHelper.textRegular()
        txtMinRange.textColor = UIColor.themeTextColor
        
        
        txtFixRange.placeholder = "TXT_FIX_RANGE".localized
        txtFixRange.font = FontHelper.textRegular()
        txtFixRange.textColor = UIColor.themeTextColor
        
        self.swIsRequired.tintColor = .themeLightTextColor
        swIsRequired.onTintColor = .themeColor
        txtSequenceNumber.font = FontHelper.textRegular()

        //SET FONTS
        
        txtItemSpeciicationName.font = FontHelper.textRegular()
        lblIsRequired.font = FontHelper.textSmall()
        lblAddSpecification.font = FontHelper.textSmall()
        txtItemSpeciicationName.font = FontHelper.textRegular()
        
        lblAssociated.text = "txt_associate_modifier".localized
        lblAssociated.font = FontHelper.textRegular()
        lblAssociated.textColor = UIColor.themeTitleColor
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableSpecifications.estimatedRowHeight = 60
        self.tableSpecifications.rowHeight = UITableView.automaticDimension
        self.btnSave.setTitle("TXT_SAVE".localizedUppercase, for: .normal)
        self.btnSave.backgroundColor = UIColor.themeColor
        self.btnSave.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnSave.titleLabel?.font = FontHelper.buttonText()
        self.btnSave.setRound(withBorderColor: .clear, andCornerRadious: self.btnSave.frame.size.height/2, borderWidth: 1.0)
        updateUIAccordingToTheme()
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
//               gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
        {
            self.view.endEditing(true)
        }
    
    @IBAction func onClickBtnRange(_ sender: Any) {
        self.view.endEditing(true)
        showDropDown()
    }
    
    //MARK: -
    //MARK: - Set data
    
    override func updateUIAccordingToTheme() {
        if LocalizeLanguage.isRTL{
            self.btnBack.setImage(UIImage.init(named: "back_right")!.imageWithColor(color: .themeTextColor)!, for: .normal)
        }else{
            self.btnBack.setImage(UIImage.init(named: "back")!.imageWithColor(color: .themeTextColor)!, for: .normal)
        }
        self.btnRight.setTitle("", for: .normal)
        self.btnRight.setImage(UIImage.init(named: "correct")!.imageWithColor(color: .themeColor)!, for: .normal)
    }
    
    func updateUIForRange(isMax:Bool) {
        self.btnSelectRangeType.setTitle(rangeList[0] + "  " + downArrow, for: .normal)
        self.txtFixRange.isHidden = isMax
        self.txtMinRange.isHidden = !isMax
        self.txtMaxRange.isHidden = !isMax
        self.btnSelectRangeType.isSelected = isMax
        if isMax {
            self.btnSelectRangeType.setTitle(rangeList[1] + "  " + downArrow, for: .selected)
        }
    }
    
    func setData() {
        self.txtItemSpeciicationName.text = specificationOrignalDetail?.name
        self.txtSequenceNumber.text = "\(specificationOrignalDetail?.sequence_number ?? 0)"
        self.txtFixRange.keyboardType = .numberPad

        if (specificationOrignalDetail?.rangeMax == 0) &&  (specificationOrignalDetail?.range == 0) {
                specificationOrignalDetail?.type = 2
                isTypeSingle = false
                self.btnSelectRangeType.setTitle(rangeList[0] + "  " + downArrow, for: .selected)
                self.btnSelectRangeType.isSelected = false
                self.txtFixRange.isHidden = false
                self.txtMinRange.isHidden = true
                self.txtMaxRange.isHidden = true
                self.txtFixRange.text = "0"
                startRange = 0
                self.swIsRequired.setOn(false, animated: true)
        }else {
            isTypeSingle = (specificationOrignalDetail?.type == 1)
            if (specificationOrignalDetail?.rangeMax)! > 0 {
                updateUIForRange(isMax: true)
                startRange = (specificationOrignalDetail?.range) ?? 0
                endRange = (specificationOrignalDetail?.rangeMax) ?? 0
                self.txtFixRange.text = "0"
                self.txtMaxRange.text = String(specificationOrignalDetail?.rangeMax ?? 0)
                self.txtMinRange.text = String(specificationOrignalDetail?.range ?? 0)
            }else {
                updateUIForRange(isMax: false)
                startRange = (specificationOrignalDetail?.range) ?? 0
                endRange = (specificationOrignalDetail?.rangeMax) ?? 0
                self.txtFixRange.text = String(specificationOrignalDetail?.range ?? 0)
                self.txtMaxRange.text = "0"
                self.txtMinRange.text = "1"
            }
            if (specificationOrignalDetail?.isRequired)! {
                self.swIsRequired.setOn(true, animated: true)
            }else {
                self.swIsRequired.setOn(false, animated: true)
            }
        }
       arrProductSpecification = (specificationOrignalDetail?.list)!
        
        //sort
        var arrSortForDisplaySpecificationItems = [List]()
        let sortedArray = arrProductSpecification.sorted{ $0.sequence_number < $1.sequence_number }
        for obj in sortedArray
        {
            arrSortForDisplaySpecificationItems.append(obj)
        }
        arrProductSpecification.removeAll()
        arrProductSpecification.append(contentsOf: arrSortForDisplaySpecificationItems)
        
        if !isForEditSpecification {
            for listItem in arrProductSpecification {
                listItem.isUserSelected = true
            }
        }
        
        self.textFieldDidEndEditing(txtFixRange)
    }
    
    func showDropDown() {
        let actionSheetController = UIAlertController(title: "TXT_SELECT".localized, message: "OPTION_TO_SELECT".localized, preferredStyle:.actionSheet)
        
        let cancelAction = UIAlertAction.init(title: "TXT_CANCEL".localized, style: .cancel) { action -> Void in
            
        }
        actionSheetController.addAction(cancelAction)
        
        
        let oneActionButton = UIAlertAction(title: "TXT_SELECT".localized, style: .default) { action -> Void in
            
            self.btnSelectRangeType.setTitle(actionSheetController.title! + "  " + (self.downArrow), for: .normal)
            self.txtFixRange.isHidden = false
            self.txtMinRange.isHidden = true
            self.txtMaxRange.isHidden = true
            self.txtFixRange.text = "0"
            self.txtMaxRange.text = "1"
            self.txtMinRange.text = "0"
            self.btnSelectRangeType.isSelected = false
            self.setUserCanAddQuntityView()
     
        }
        actionSheetController.addAction(oneActionButton)
        
        let twoActionButton = UIAlertAction(title: "TXT_RANGE".localized, style: .default) { action -> Void in
            self.btnSelectRangeType.setTitle(actionSheetController.title! + "  " + (self.downArrow), for: .normal)

            self.btnSelectRangeType.isSelected = true
            self.txtFixRange.isHidden = true
            self.txtMinRange.isHidden = false
            self.txtMaxRange.isHidden = false
            self.txtFixRange.text = "0"
            self.txtMaxRange.text = "1"
            self.txtMinRange.text = "0"
            self.setUserCanAddQuntityView()
        }
        
        actionSheetController.addAction(twoActionButton)

        //Issue resolved : Added Actionsheet support for IPAD
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheetController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(actionSheetController, animated: true, completion: nil)
                
            }
        }else{
            self.present(actionSheetController, animated: true, completion: nil)
        }
        
    }
    
    func reloadTableData() {
        self.tableSpecifications.reloadData()
        tableSpecifications.layoutIfNeeded()
        tableHeightConstraint.constant = self.tableSpecifications.contentSize.height
    }
    override func updateViewConstraints() {
        tableHeightConstraint.constant = self.tableSpecifications.contentSize.height
        super.updateViewConstraints()
    }
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: -
    //MARK: - button click events
    
    @IBAction func onClickSave (_ sender: Any) {
        self.view.endEditing(true)
        
        let userSelectedArray = getSelectedData()
        let defaultSelectedArray = arrProductSpecification.filter() {($0 as List).isDefaultSelected}
        let defaultCount = defaultSelectedArray.count
        let maxDefaultCount = btnSelectRangeType.isSelected ? endRange : (startRange == 0) ? Int.max  : startRange
        
        self.checkValidation()
        
        if userSelectedArray.count > 0 && userSelectedArray.count >= startRange {
        
            if isTypeSingle &&  defaultCount > maxDefaultCount {
                Utility.showToast(message: "TXT_DEFAULT_COUNT_MSG".localized)
            }else if !isTypeSingle  && defaultCount > maxDefaultCount {
                Utility.showToast(message: "TXT_DEFAULT_COUNT_MSG".localized)
            } else if switchAssociated.isOn && lastSelectIndexSpGroup < 0 && !isForEditSpecification {
                Utility.showToast(message: "txt_select_modifier_group".localized)
            } else if switchAssociated.isOn && lastSelectIndexSpGroup >= 0 && lastSelectIndexSp < 0 && !isForEditSpecification {
                Utility.showToast(message: "txt_select_specification".localized)
            } else if (specificationOrignalDetail?.isParentAssociate ?? false) && (!isTypeSingle || btnSelectRangeType.isSelected) && !isDeleteAndReplace {
                
                let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "txt_deleting_conflict_modifier".localized, titleLeftButton: "TXT_EXIT".localizedUppercase, titleRightButton: "TXT_REMOVE".localizedUppercase)
                
                dialogForUpdateApp.onClickLeftButton = { [weak dialogForUpdateApp] in
                    dialogForUpdateApp?.removeFromSuperview()
                }
                
                dialogForUpdateApp.onClickRightButton = { [weak self] in
                    guard let self = self else { return }
                    self.arrSavedProductSpecification = self.arrSavedProductSpecification.filter({$0.id != self.specificationOrignalDetail?.id ?? ""})
                    dialogForUpdateApp.removeFromSuperview()
                    self.specificationOrignalDetail?.isParentAssociate = true
                    self.isDeleteAndReplace = true
                    self.onClickSave(self.btnSave as Any)
                }
            } else {
                specificationOrignalDetail?.type = isTypeSingle ? 1 : 2
                specificationOrignalDetail?.isRequired = (startRange == 0) ? false : true

                specificationOrignalDetail?.list = getSelectedData()
                specificationOrignalDetail?.range = startRange
                specificationOrignalDetail?.rangeMax =  btnSelectRangeType.isSelected ? endRange : 0
                
                specificationOrignalDetail?.name = self.txtItemSpeciicationName.text
                
                if viewUserCanAddQuantity.isHidden {
                    specificationOrignalDetail?.user_can_add_specification_quantity = false
                } else {
                    if switchUserCanAddQuantity.isOn {
                        specificationOrignalDetail?.user_can_add_specification_quantity = true
                    } else {
                        specificationOrignalDetail?.user_can_add_specification_quantity = false
                    }
                }
                
                //sort
                var arrSortspecificationOrignalDetail = [List]()
                let sortedArray = specificationOrignalDetail!.list.sorted{ $0.sequence_number < $1.sequence_number }
                for obj in sortedArray
                {
                    arrSortspecificationOrignalDetail.append(obj)
                }
                specificationOrignalDetail!.list.removeAll()
                specificationOrignalDetail!.list.append(contentsOf: arrSortspecificationOrignalDetail)
                
                specificationOrignalDetail?.sequence_number = Int(self.txtSequenceNumber.text!)
                
                if lastSelectIndexSpGroup >= 0 && lastSelectIndexSp >= 0 {
                    specificationOrignalDetail?.isAssociated = true
                    specificationOrignalDetail?.modifierGroupId = arrDropDownSpGroup[lastSelectIndexSpGroup].id
                    specificationOrignalDetail?.modifierId = arrDropDownSp[lastSelectIndexSp].id
                    specificationOrignalDetail?.modifierGroupName = arrDropDownSpGroup[lastSelectIndexSpGroup].name
                    specificationOrignalDetail?.modifierName = arrDropDownSp[lastSelectIndexSp].name
                    arrDropDownSpGroup[lastSelectIndexSpGroup].isParentAssociate = true
                    if isDeleteAndReplace {
                        delegate?.deleteAndReplace(specificationOrignalDetail!)
                    } else {
                        delegate?.saveSubItemDetail(specificationOrignalDetail!, parentSpec: arrDropDownSpGroup[lastSelectIndexSpGroup], isEditedSpec: isForEditSpecification)
                    }
                } else {
                    if !isForEditSpecification {
                        let filter = arrSavedProductSpecification.filter({$0.id == specificationOrignalDetail?.id && !$0.isAssociated})
                        if filter.count > 0 {
                            Utility.showToast(message: "txt_specification_already_added".localized)
                            return
                        }
                    }
                    if isDeleteAndReplace {
                        delegate?.deleteAndReplace(specificationOrignalDetail!)
                    } else {
                        delegate?.saveSubItemDetail(specificationOrignalDetail!, parentSpec: nil, isEditedSpec: isForEditSpecification)
                    }
                }
                self.navigationController?.popViewController(animated: true)
            }
         
        }else {
            Utility.showToast(message: "MSG_SELECT_AT_LEAST_SPECIFICATION_TO_SATISFY_RANGE".localized)
        }
    }
   
    /**
     * this method used to match specification from particular item and product specification and
     * it make a new list of specification
     */
    func getSelectedData() -> [List] {
        if arrProductSpecification.isEmpty {
            return []
        }else {
        var cell = SpecificationItemCell()
        for i in 0...self.arrProductSpecification.count-1 {
            let indexPath = IndexPath(row: i, section:0)
            cell = self.tableSpecifications.cellForRow(at: indexPath) as! SpecificationItemCell
            
            if (cell.btnCheck.isSelected) {
                arrProductSpecification[i].price = cell.txtPrice.text?.doubleValue ?? 0.0
                if (cell.btnDefault.isSelected) {
                    arrProductSpecification[i].isDefaultSelected = true
                }
                else {
                    arrProductSpecification[i].isDefaultSelected = false
                }
            }
        }
            let filteredArray = arrProductSpecification.filter() {($0 as List).isUserSelected}
            return filteredArray
        }
    }
    
    func setAssociatedViews(switchViewHidden: Bool, viewSpGroupHide: Bool, viewSpHide:Bool) {
        if switchViewHidden {
            viewMainAssociated.isHidden = true
            stackViewAssociatedSP.isHidden = true
        } else {
            viewMainAssociated.isHidden = false
            if viewSpGroupHide && viewSpGroupHide {
                stackViewAssociatedSP.isHidden = true
            } else if !viewSpGroupHide || !viewSpHide {
                stackViewAssociatedSP.isHidden = false
            }
            viewSelectSPGroup.isHidden = viewSpGroupHide
            viewSelectSP.isHidden = viewSpHide
        }
    }
}


extension AddItemSpecificationVC : UITableViewDelegate,UITableViewDataSource {
    //MARK: -
    //MARK: - UITableview delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProductSpecification.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:SpecificationItemCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: "specificationItemCell", for: indexPath) as? SpecificationItemCell
        
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "specificationItemCell") as? SpecificationItemCell
        }
        cell?.btnCheck.tag = indexPath.row
        cell?.btnDefault.tag = indexPath.row
        cell?.btnCheck.setImage(UIImage.init(named: "unchecked"), for: .normal)
        cell?.btnCheck.setImage(UIImage.init(named: "checked")?.imageWithColor(color: .themeColor), for: .selected)

        let spec:List = arrProductSpecification[indexPath.row]
        cell?.setCellData(specificationItem:spec,parent:self)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func onClickBtnCheckBox(_ sender:UIButton) {
        if sender.isSelected {
            arrProductSpecification[sender.tag].isUserSelected = true
        }else {
            arrProductSpecification[sender.tag].isUserSelected = false
        }
        
    }
    func onClickBtnDefault(_ sender:UIButton) {
        if sender.isSelected {
            arrProductSpecification[sender.tag].isDefaultSelected = true
        }else {
            arrProductSpecification[sender.tag].isDefaultSelected = false
        }
        reloadTableData()
    }
    
    @IBAction func onClickSwitch(_ sender: UIButton) {
        self.view.endEditing(true)
        if switchAssociated.isOn {
            switchAssociated.isOn = false
        } else {
            switchAssociated.isOn = true
        }
        setViewAccordingSwitch()
    }
    
    @IBAction func onClickSpGroup(_ sender: UIButton) {
        self.view.endEditing(true)
        DropDown.startListeningToKeyboard()
        
        let dropDown = DropDown()
        
        self.arrDropDownSpGroup = getNonAssociatedGrops()
        
        for obj in arrDropDownSpGroup {
            print(obj)
        }
         
        dropDown.dataSource = arrDropDownSpGroup.map({$0.name})
        dropDown.anchorView = viewSelectSPGroup
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.lastSelectIndexSpGroup = index
            self.setAssociatedViews(switchViewHidden: false, viewSpGroupHide: false, viewSpHide: false)
            self.lblSelectSPGroup.text = item
        }
        dropDown.show()
    }
    
    @IBAction func onClickSp(_ sender: UIButton) {
        self.view.endEditing(true)
        DropDown.startListeningToKeyboard()
        
        let dropDown = DropDown()
        
        self.arrDropDownSp = getSpesificationsList()
        
        dropDown.dataSource = arrDropDownSp.map({$0.name})
        dropDown.anchorView = viewSelectSP
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.lastSelectIndexSp = index
            self.lblSelectSP.text = item
        }
        dropDown.show()
    }
    
    func getNonAssociatedGrops() -> [ItemSpecification] {
        var arrSpecification = [ItemSpecification]()
        let findAlreadyAssociate = arrSavedProductSpecification.filter({$0.id == specificationOrignalDetail?.id})
        if findAlreadyAssociate.count > 0 {
            let findWithModifire = findAlreadyAssociate.filter({$0.modifierGroupId != ""})
            if findWithModifire.count > 0 {
                specificationOrignalDetail?.modifierGroupId = findWithModifire[0].modifierGroupId
                for obj in arrSavedProductSpecification {
                    if obj.isParentAssociate && specificationOrignalDetail?.modifierGroupId == obj.id && obj.id != self.specificationOrignalDetail?.id {
                        arrSpecification.append(obj)
                    }
                }
            } else {
                for obj in arrSavedProductSpecification {
                    let arrGroupAssociated = arrSavedProductSpecification.filter({$0.isAssociated && $0.id == obj.id}).map({$0.id ?? ""})
                    
                    if (obj.type == 1 && !obj.isParentAssociate) && obj.id != self.specificationOrignalDetail?.id && !arrGroupAssociated.contains(obj.id) {
                        arrSpecification.append(obj)
                    } else if obj.type == 1 && obj.isParentAssociate && obj.id != self.specificationOrignalDetail?.id && !arrGroupAssociated.contains(obj.id) {
                        arrSpecification.append(obj)
                    }
                }
            }
        } else {
            for obj in arrSavedProductSpecification {
                
                let arrGroupAssociated = arrSavedProductSpecification.filter({$0.isAssociated && $0.id == obj.id}).map({$0.id ?? ""})
                
                if obj.type == 1 && !obj.isAssociated && obj.id != self.specificationOrignalDetail?.id && !arrGroupAssociated.contains(obj.id) {
                    arrSpecification.append(obj)
                }
            }
        }
        return arrSpecification
    }
    
    func getSpesificationsList() -> [List] {
        var arrList = arrDropDownSpGroup[lastSelectIndexSpGroup].list ?? []
        if lastSelectIndexSpGroup >= 0 {
            for objSaved in arrSavedProductSpecification {
                if objSaved.id == self.specificationOrignalDetail?.id {
                    arrList = arrList.filter({$0.id != objSaved.modifierId})
                }
            }
        }
        return arrList
    }
    
    func setViewAccordingSwitch(isToast: Bool = true) {
        if switchAssociated.isOn {
            if !isForEditSpecification {
                if getNonAssociatedGrops().count == 0 {
                    switchAssociated.isOn = false
                    if isToast {
                        Utility.showToast(message: "txt_there_is_no_modifier".localized)
                    }
                    return
                }
                setAssociatedViews(switchViewHidden: false, viewSpGroupHide: false, viewSpHide: true)
            }
        } else {
            if arrSavedProductSpecification.count > 0 {
                setAssociatedViews(switchViewHidden: false, viewSpGroupHide: true, viewSpHide: true)
            } else {
                setAssociatedViews(switchViewHidden: true, viewSpGroupHide: true, viewSpHide: true)
            }
        }
    }
    
    func setUserCanAddQuntityView() {
        if txtFixRange.text == "1" && !txtFixRange.isHidden {
            viewUserCanAddQuantity.isHidden = true
        } else {
            viewUserCanAddQuantity.isHidden = false
            if let obj = self.specificationOrignalDetail {
                if obj.user_can_add_specification_quantity {
                    switchUserCanAddQuantity.isOn = true
                } else {
                    switchUserCanAddQuantity.isOn = false
                }
            } else {
                switchUserCanAddQuantity.isOn = false
            }
        }
    }
}

extension AddItemSpecificationVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFixRange {
            setUserCanAddQuntityView()
        }
        checkValidation()
    }
    func checkValidation() {
        if btnSelectRangeType.isSelected {
            startRange = txtMinRange.text?.integerValue ?? 0
            endRange = txtMaxRange.text?.integerValue ?? 0
            isTypeSingle = false
            
            if startRange >= endRange {
                txtMaxRange.text = ""
                Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_MAX_RANGE".localized)
            }
        }else {
            endRange = 0
            startRange = txtFixRange.text?.integerValue  ?? 0
            isTypeSingle = (startRange == 1)
        }
        
        swIsRequired.isOn = (startRange != 0)
  }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtItemSpeciicationName {
            self.openLocalizedLanguagDialog()
            return false
        }
        return true
    }
    func openLocalizedLanguagDialog()
    {
        self.view.endEditing(true)
        let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: [:], title: txtItemSpeciicationName.placeholder ?? "",nameLang: self.specificationOrignalDetail!.nameLanguages)
                    dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
                        
                        print(selectedArray)
                        var namelang = [String]()
                        var count : Int = 0
                        if ConstantsLang.storeLanguages.count > 0{
                        for i in 0...ConstantsLang.storeLanguages.count-1
                        {
                            count = 0
                            for j in 0...selectedArray.count-1
                            {
                                if Array(selectedArray.keys)[j] == ConstantsLang.storeLanguages[i].code{
                                    namelang.append(selectedArray[ConstantsLang.storeLanguages[i].code]!)
                                    count = 1
                                }
                            }
                            if count == 0{
                                namelang.append("")
                            }
                        }
                        }
                        print(namelang)
                        self.specificationOrignalDetail?.nameLanguages = namelang
                        self.txtItemSpeciicationName.text = self.specificationOrignalDetail?.nameLanguages[ConstantsLang.StoreLanguageIndexSelected]
                        self.txtSequenceNumber.text = "\(self.specificationOrignalDetail?.sequence_number ?? 0)"

                        dialogForLocalizedLanguage.removeFromSuperview()
                    }
        }
}

extension AddItemSpecificationVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewSPGroup {
            return 5
        } else if pickerView == pickerViewSP {
            return 5
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewSPGroup {
            return "1"
        } else if pickerView == pickerViewSP {
            return "1"
        }
        return ""
    }
}
