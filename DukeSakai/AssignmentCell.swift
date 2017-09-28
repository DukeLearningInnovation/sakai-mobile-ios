//
//  AssignmentCell.swift
//  DukeSakai
//
//  Created by 毛喆 on 2017-03-21.
//  Copyright © 2017 Zhe Mao. All rights reserved.
//

import UIKit

class AssignmentCell: UITableViewCell {

    @IBOutlet weak var assignmentTitle: UILabel!
    @IBOutlet weak var due: UILabel!
    @IBOutlet weak var scale: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
