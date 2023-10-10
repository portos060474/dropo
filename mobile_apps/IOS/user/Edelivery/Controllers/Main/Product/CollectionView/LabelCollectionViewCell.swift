import UIKit

class LabelCollectionViewCell: CustomCollectionCell {
    @IBOutlet var label: UILabel!
    override func awakeFromNib() {
        label.font = FontHelper.textRegular()
        label.textColor = UIColor.themeSectionBackgroundColor
    }
    
}
