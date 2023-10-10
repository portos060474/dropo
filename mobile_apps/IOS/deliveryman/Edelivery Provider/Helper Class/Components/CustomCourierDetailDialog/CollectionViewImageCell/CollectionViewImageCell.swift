import UIKit

class CollectionViewImageCell: CustomCollectionCell {
    @IBOutlet var imageItem: UIImageView!
    override func awakeFromNib() {
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.imageItem.clipsToBounds = true
      //  self.imageItem.setRound(withBorderColor: .themeLightGrayTextColor, andCornerRadious: 3.0, borderWidth: 1)
        self.imageItem.applyShadowToView()
    }
}
