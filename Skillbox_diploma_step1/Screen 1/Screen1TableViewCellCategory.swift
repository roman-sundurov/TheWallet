//
//  Screen1TableViewCellCategory.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 26.01.2021.
//

import UIKit

class Screen1TableViewCellCategory: UITableViewCell {

    @IBOutlet var viewPictureOfCategory: UIView!
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
