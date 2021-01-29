//
//  CountedTableViewCell.swift
//  Converter
//
//  Created by User on 25.01.2021.
//

import UIKit

class CountedTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
