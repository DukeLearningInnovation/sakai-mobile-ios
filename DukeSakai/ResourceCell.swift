
import UIKit

class ResourceCell: UITableViewCell {

    @IBOutlet weak var resouce_icon: UIImageView!
    @IBOutlet weak var resourceTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
