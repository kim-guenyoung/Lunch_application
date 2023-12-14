//
//  TableViewCell.swift
//  NavigationController
//
//  Created by 김근영 on 12/10/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
