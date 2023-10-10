 

import UIKit

class SpecificationGroupCell: CustomCell {

    @IBOutlet weak var lblSpecificationGroupName: UILabel!
    @IBOutlet weak var btnRemoveSpecification: UIButton!
    
    var isCellSelected:Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSpecificationGroupName.font = FontHelper.textRegular()
        lblSpecificationGroupName.textColor = .themeTextColor
        

    }
    
    func setCellUI(isFromCat:Bool){
        if isFromCat{
            btnRemoveSpecification.setImage(UIImage(named: "RightArrow")?.imageWithColor(color: .themeIconTintColor), for: .normal)
            btnRemoveSpecification.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .selected)
        }else{
            btnRemoveSpecification.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
