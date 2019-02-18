
import UIKit

class MemberCell: UITableViewCell {

//from storyboard
    @IBOutlet weak var courseTitle: UILabel!
//end storyboard
    @IBOutlet weak var instructor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
