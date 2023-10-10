//
//  CustomVehicleSelectionDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomVehicleSelectionDialog:CustomDialog, UITextFieldDelegate {
   
    //MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet var collectionForVehicle: UICollectionView!
    @IBOutlet var lblPricePerDistance: UILabel!
    @IBOutlet var lblPricePerDistanceValue: UILabel!
    @IBOutlet var viewPricePerDistanceValue: UIView!
    
    @IBOutlet var lblParcelCapacity: UILabel!
    @IBOutlet var lblParcelCapacityValue: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblDescriptionValue: UILabel!
    
    @IBOutlet var lblRoundTrip: UILabel!
    @IBOutlet var switchRoundTrip: UISwitch!
    @IBOutlet var viewRoundTrip: UIView!
    
    @IBOutlet var lblLWH: UILabel!
    @IBOutlet var lblLWHValue: UILabel!
    @IBOutlet var viewLWH: UIView!
    
    @IBOutlet var lblWeight: UILabel!
    @IBOutlet var lblWeightValue: UILabel!
    @IBOutlet var viewWeight: UIView!
        
    //MARK:Variables
    var onClickRightButton : ((_ selectedId:String, _ dialog:  CustomVehicleSelectionDialog) -> Void)? = nil
    var changeSwitchRoundTrip : ((_ dialog:CustomVehicleSelectionDialog ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  dialogNibName = "dialogForVehicleSelection"
    var arrForVehicle: [VehicleDetail] = []
    var selectedVehicle: VehicleDetail = VehicleDetail.init(fromDictionary: [:])
    
    var lastIndex = 0
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public static func showCustomVehicleSelectionDialog
    (title:String,titleLeftButton:String,titleRightButton:String,arrForVehicle:[VehicleDetail]) ->
    CustomVehicleSelectionDialog
    {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomVehicleSelectionDialog
        view.alertView.setShadow()
        view.setLocalization()
        view.arrForVehicle = arrForVehicle
        view.arrForVehicle[0].isSelected = true
        view.selectedVehicle = view.arrForVehicle[0]
        view.setCollectionView()
        view.setVehicleData()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.text = title
        view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton, for: UIControl.State.normal)
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.alertView)
        }
        return view
    }
    
    func setVehicleData() {
        lblDescription.text = "TXT_DESCRIPTION".localized
        lblPricePerDistance.text = "TXT_PRICE_PER_DISTANCE".localized
        lblParcelCapacity.text = "TXT_PARCEL_CAPACITY".localized
        lblDescriptionValue.text = selectedVehicle.descriptionField
        lblPricePerDistanceValue.text = selectedVehicle.price_per_unit_distance.toCurrencyString()
        lblParcelCapacityValue.text = "--"
        let unitSize = selectedVehicle.size_type == 1 ? "txt_meter".localized : "txt_centimeter".localized
        lblLWHValue.text = "\(selectedVehicle.length) * \(selectedVehicle.width) * \(selectedVehicle.height) \(unitSize)"
        
        let unitWeight = selectedVehicle.weight_type == 1 ? "txt_kg".localized : "txt_gm".localized
        lblWeightValue.text = "\(selectedVehicle.min_weight) * \(selectedVehicle.max_weight) \(unitWeight)"
        
        viewRoundTrip.isHidden = !selectedVehicle.is_round_trip
        viewLWH.isHidden = (selectedVehicle.length == 0 && selectedVehicle.width == 0 && selectedVehicle.height == 0) ? true : false
        viewWeight.isHidden = (selectedVehicle.min_weight == 0 && selectedVehicle.max_weight == 0) ? true : false
        viewPricePerDistanceValue.isHidden = selectedVehicle.price_per_unit_distance == 0 ? true : false
        switchRoundTrip.isOn = false
    }
    
    func setLocalization() {

        /* Set Color */
        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        lblTitle.textColor = UIColor.themeTextColor
        btnLeft.titleLabel?.font =  FontHelper.textSmall()
        btnLeft.tintColor = .themeColor
        btnRight.titleLabel?.font =  FontHelper.textRegular()
        lblTitle.font = FontHelper.textLarge()
        lblParcelCapacity.textColor = UIColor.themeTextColor
        lblParcelCapacity.font = FontHelper.textMedium()
        lblPricePerDistance.textColor = UIColor.themeTextColor
        lblPricePerDistance.font = FontHelper.textMedium()
        lblDescription.textColor = UIColor.themeTextColor
        lblDescription.font = FontHelper.textMedium()
        lblParcelCapacityValue.textColor = UIColor.themeTextColor
        lblParcelCapacityValue.font = FontHelper.textRegular()
        lblPricePerDistanceValue.textColor = UIColor.themeTextColor
        lblPricePerDistanceValue.font = FontHelper.textRegular()
        lblDescriptionValue.textColor = UIColor.themeTextColor
        lblDescriptionValue.font = FontHelper.textRegular()
        lblRoundTrip.textColor = UIColor.themeTextColor
        lblRoundTrip.font = FontHelper.textMedium()
        lblWeight.textColor = UIColor.themeTextColor
        lblWeight.font = FontHelper.textMedium()
        lblWeightValue.textColor = UIColor.themeTextColor
        lblWeightValue.font = FontHelper.textRegular()
        lblLWH.textColor = UIColor.themeTextColor
        lblLWH.font = FontHelper.textMedium()
        lblLWHValue.textColor = UIColor.themeTextColor
        lblLWHValue.font = FontHelper.textRegular()
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnLeft.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    public override func layoutSubviews() {
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }
    
    override func updateUIAccordingToTheme() {
        setLocalization()
    }
    
    //ActionMethods
    
    @IBAction func onClickBtnLeft(_ sender: Any) {
        self.animationForHideView(alertView) {
            self.removeFromSuperview()
        }
    }
    
    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(selectedVehicle.vehicleId, self)
        }
    }
    
    @IBAction func changeSwitchRoundTrip(_ sender: Any) {
        if self.changeSwitchRoundTrip != nil {
            self.changeSwitchRoundTrip!(self)
        }
    }
}

extension CustomVehicleSelectionDialog : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        func setCollectionView() {
            let nibName = UINib(nibName: "CustomVehicleCell", bundle:nil)
            collectionForVehicle.register(nibName, forCellWithReuseIdentifier: "cell")
            collectionForVehicle.dataSource = self
            collectionForVehicle.delegate = self
            collectionForVehicle.reloadData()
        }
        
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.arrForVehicle.indices.forEach {
            self.arrForVehicle[$0].isSelected = false
        }
        self.arrForVehicle[indexPath.row].isSelected = true
        if lastIndex == indexPath.row {
            return
        }
        selectedVehicle = self.arrForVehicle[indexPath.row]
        lastIndex = indexPath.row
        self.setVehicleData()
        collectionView.reloadData()
    }
        
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomVehicleCell
            cell.setCellData(cellItem: arrForVehicle[indexPath.row])
            return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrForVehicle.count
    }
        
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height - 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            if arrForVehicle.count <= 3 {
                let totalCellWidth = (collectionView.frame.width/3) * CGFloat(collectionView.numberOfItems(inSection: 0))
                let edgeInsets = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth)) / 2
                return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
        }
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
   
}
