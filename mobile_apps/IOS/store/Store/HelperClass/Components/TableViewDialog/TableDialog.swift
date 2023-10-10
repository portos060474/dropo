//
//  PickerDialog.swift
//
//  Created by Loren Burton on 02/08/2016.
//

import Foundation
import UIKit



class TableDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource {
    
    

    typealias TableCallback = (_ selectedIndex:[Int]) -> Void

  
    /* Constants */
    private var kTableDialogDefaultButtonHeight:       CGFloat = 50
    private let kTableDialogDefaultButtonSpacerHeight: CGFloat = 1
    private let kTableDialogCornerRadius:              CGFloat = 7
    private let kTableDialogDoneButtonTag:             Int     = 1

    /* Views */
    private var dialogView:   UIView!
    private var titleLabel:   UILabel!
    private var table:      UITableView = UITableView.init()
    private var cancelButton: UIButton!
    private var doneButton:   UIButton!
    private var isAllowMultiselect: Bool!

    /* Variables */
    private var tableData =         [(String,Bool)]()
    private var selectedIndex: [Int] = []
    private var callback:            TableCallback?


    /* Overrides */
    init() {
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
       
        if #available(iOS 11.0, *) {
            kTableDialogDefaultButtonHeight = 50 + (APPDELEGATE.window?.safeAreaInsets.bottom ?? 0.0)
        } else {
            // Fallback on earlier versions
        }
        
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.dialogView = createContainerView()

        self.dialogView!.layer.shouldRasterize = true
        self.dialogView!.layer.rasterizationScale = UIScreen.main.scale

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

        self.dialogView!.layer.opacity = 0.5
        self.dialogView!.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)

        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

       
        self.addSubview(self.dialogView!)
    }

    /* Handle device orientation changes */
    @objc func deviceOrientationDidChange(notification: NSNotification) {
        close() // For now just close it
    }

    /* Required UIPickerView functions */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        var cell :SelectableItemCell?
        if let sCell: SelectableItemCell = tableView.dequeueReusableCell(withIdentifier: "cellForSelectableItem", for: indexPath) as? SelectableItemCell {
            cell=sCell
            
        }else {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellForSelectableItem") as? SelectableItemCell
            
        }

        if isAllowMultiselect {
        cell?.btnCheck.isHidden = false
        cell?.btnCheck.tag = indexPath.row
        cell?.lblName.text = tableData[indexPath.row].0
        cell?.btnCheck.isSelected = tableData[indexPath.row].1
        }else {
            cell?.btnCheck.isHidden = !tableData[indexPath.row].1
            cell?.btnCheck.isSelected = tableData[indexPath.row].1
            cell?.btnCheck.tag = indexPath.row
            cell?.lblName.text = tableData[indexPath.row].0
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isAllowMultiselect {
        tableData[indexPath.row].1 = !tableData[indexPath.row].1
        tableView.reloadData()
        }else {
            selectedIndex = [indexPath.row]
            for i in 0..<tableData.count {
                tableData[i].1 = false
            }
            tableData[indexPath.row].1 = true
            tableView.reloadData()
            
        }
    }

   

    /* Create the dialog view, and animate opening the dialog */
    func show(title: String, doneButtonTitle: String = "TXT_DONE".localized, cancelButtonTitle: String = "TXT_CANCEL".localized, options: [(String,Bool)],isAllowMultiselect:Bool = true, callback: @escaping TableCallback) {
        self.titleLabel.text = title
        self.tableData = options
        self.table.tableFooterView = UIView.init()
        self.doneButton.setTitle(doneButtonTitle, for: .normal)
        self.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        self.callback = callback
        self.isAllowMultiselect = isAllowMultiselect
        /* */
//        APPDELEGATE.window!.addSubview(self)
//        APPDELEGATE.window!.endEditing(true)
        UIApplication.shared.keyWindow?.addSubview(self)
        APPDELEGATE.window?.bringSubviewToFront(self);
//        view.animationBottomTOTop(self.alertView)

        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
       
        /* Anim */
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: { () -> Void in
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.dialogView!.layer.opacity = 1
                self.dialogView!.layer.transform = CATransform3DMakeScale(1, 1, 1)
            },
            completion: nil
        )
    }

    /* Dialog close animation then cleaning and removing the view from the parent */
    private func close() {
         NotificationCenter.default.removeObserver(self)

        let currentTransform = self.dialogView.layer.transform

        let startRotation = (self.value(forKeyPath: "layer.transform.rotation.z") as? NSNumber) as? Double ?? 0.0
        let rotation = CATransform3DMakeRotation((CGFloat)(-startRotation + M_PI * 270 / 180), 0, 0, 0)

        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        self.dialogView.layer.opacity = 1

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: UIView.AnimationOptions.transitionCurlUp,
            animations: { () -> Void in
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
                self.dialogView.layer.opacity = 0
            }) { (finished: Bool) -> Void in
                for v in self.subviews {
                    v.removeFromSuperview()
                }

                self.removeFromSuperview()
        }
    }

    /* Creates the container view here: create the dialog, then add the custom content and buttons */
    private func createContainerView() -> UIView {
        let screenSize = countScreenSize()
     
        let dialogSize =    CGSize.init(width: screenSize.width, height: 230
            + kTableDialogDefaultButtonHeight
            + kTableDialogDefaultButtonSpacerHeight)

        // For the black background
        
        self.frame = CGRect.init(origin: CGPoint.zero, size: screenSize)

        // This is the dialog's container; we attach the custom content and the buttons to this one
        
        
        //let dialogContainer = UIView(frame: CGRect.init(x: (screenSize.width - dialogSize.width) / 2, y: (screenSize.height - dialogSize.height) / 2, width: dialogSize.width, height: dialogSize.height))
       
        let dialogContainer =   UIView(frame:     CGRect.init(origin: CGPoint.init(x: 0, y:(screenSize.height - dialogSize.height )), size: dialogSize))
        
        // First, we style the dialog to match the iOS8 UIAlertView >>>
        let gradient: CAGradientLayer = CAGradientLayer(layer: self.layer)
        gradient.frame = dialogContainer.bounds
        gradient.colors = [UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor,
            UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1).cgColor,
            UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor]

        let cornerRadius = kTableDialogCornerRadius
        gradient.cornerRadius = cornerRadius
        dialogContainer.layer.insertSublayer(gradient, at: 0)

        dialogContainer.layer.cornerRadius = cornerRadius
        dialogContainer.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
        dialogContainer.layer.borderWidth = 1
        dialogContainer.layer.shadowRadius = cornerRadius + 5
        dialogContainer.layer.shadowOpacity = 0.1
   
        dialogContainer.layer.shadowOffset =   CGSize.init(width:0 - (cornerRadius + 5) / 2 , height: 0 - (cornerRadius + 5) / 2)
        dialogContainer.layer.shadowColor = UIColor.black.cgColor
        dialogContainer.layer.shadowPath = UIBezierPath(roundedRect: dialogContainer.bounds, cornerRadius: dialogContainer.layer.cornerRadius).cgPath

        // There is a line above the button
      
        let lineView = UIView(frame:   CGRect.init(x: 0, y: dialogContainer.bounds.size.height - kTableDialogDefaultButtonHeight - kTableDialogDefaultButtonSpacerHeight, width:  dialogContainer.bounds.size.width, height: kTableDialogDefaultButtonSpacerHeight))
        
        lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        dialogContainer.addSubview(lineView)
        // ˆˆˆ

        //Title
        self.backgroundColor = .themeViewBackgroundColor
        self.titleLabel = UILabel(frame: CGRect.init(x: 10, y: 10, width: screenSize.width - 20, height: 30))
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.textColor = UIColor.themeTextColor
        self.titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 16)
        dialogContainer.addSubview(self.titleLabel)

        
        self.table.frame = CGRect.init(x: 0, y: titleLabel.frame.maxY + 10, width: 0, height: 180)
        self.table.autoresizingMask = UIView.AutoresizingMask.flexibleRightMargin
        self.table.frame.size.width = screenSize.width
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.register(UINib.init(nibName: "cellForSelectableItem", bundle: nil), forCellReuseIdentifier: "cellForSelectableItem")
        
        self.table.reloadData()
         addButtonsToView(dialogContainer)
        dialogContainer.addSubview(self.table)

        // Add the buttons
       

        return dialogContainer
    }

    /* Add buttons to container */
    private func addButtonsToView(_ container: UIView) {
        let buttonWidth = container.bounds.size.width / 2

        self.cancelButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
       
        self.cancelButton.frame = CGRect.init(x: 0, y: container.bounds.size.height - kTableDialogDefaultButtonHeight, width: buttonWidth, height: kTableDialogDefaultButtonHeight)
        self.cancelButton.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        self.cancelButton.setTitleColor(UIColor.themeTextColor, for: UIControl.State.highlighted)
        self.cancelButton.titleLabel!.font = UIFont(name: "AvenirNext-Medium", size: 15)
        self.cancelButton.layer.cornerRadius = kTableDialogCornerRadius
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
        container.addSubview(self.cancelButton)

        self.doneButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
       
        self.doneButton.frame =  CGRect.init(x: buttonWidth, y: container.bounds.size.height - kTableDialogDefaultButtonHeight, width: buttonWidth, height: kTableDialogDefaultButtonHeight)
        
        self.doneButton.tag = kTableDialogDoneButtonTag
        self.doneButton.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        self.doneButton.setTitleColor(UIColor.themeTextColor, for: UIControl.State.highlighted)
        self.doneButton.titleLabel!.font = UIFont(name: "AvenirNext-Medium", size: 15)
        self.doneButton.layer.cornerRadius = kTableDialogCornerRadius
        self.doneButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        container.addSubview(self.doneButton)
    }

    @objc func cancelButtonTapped(sender: UIButton!) {
            close()
    }
    @objc func buttonTapped(sender: UIButton!) {
        if sender.tag == kTableDialogDoneButtonTag {
            if isAllowMultiselect {
            selectedIndex.removeAll()
            for i in 0..<tableData.count {
                if tableData[i].1 {
                    selectedIndex.append(i)
                }
            }
            }
            if selectedIndex.count <= 0 {
                Utility.showToast(message: "MSG_PLEASE_SELECT_ANY_VEHICLE".localized)
            }else {
            self.callback?(selectedIndex)
                close()
            }
            
        }

        
    }

    /* Helper function: count and return the screen's size */
    func countScreenSize() -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height

        
        return CGSize.init(width: screenWidth, height: screenHeight)
    }
   
}
class SelectableItemCell: CustomCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblName.textColor = UIColor.themeTextColor
        self.lblName.font = FontHelper.labelRegular()
        self.btnCheck.isUserInteractionEnabled = false
        
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
   
    
    @IBAction func onClickCheckBox (_ sender: Any) {
        if (self.btnCheck.isSelected) {
            self.btnCheck.isSelected = false
     
        }else {
            self.btnCheck.isSelected = true
           
        }
    }
}
