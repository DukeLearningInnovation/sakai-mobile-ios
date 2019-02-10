
import UIKit

class AnnCell: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var announce: UILabel!
    //@IBOutlet weak var author: UILabel!
    // @IBOutlet weak var time: UILabel!
  //  @IBOutlet weak var announce: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
