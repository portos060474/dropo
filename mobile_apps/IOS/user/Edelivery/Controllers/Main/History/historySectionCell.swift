import UIKit

class historySectionCell: CustomTableCell {
    
    @IBOutlet weak var lblSection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.textColor = UIColor.themeTextColor
    }
    
    func setData(title: String)
    {
        lblSection.font = FontHelper.textRegular()
        lblSection.text = title.appending("     ")
        lblSection.sectionRound(lblSection)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
