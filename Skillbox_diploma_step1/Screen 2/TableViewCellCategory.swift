//
//  TableViewCellCategory.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 17.01.2021.
//

import UIKit

class TableViewCellCategory: UITableViewCell {
    
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelSelectCategory: UILabel!
    @IBOutlet var categoryButton: UIButton!
    
//    var tag: Int

    override func awakeFromNib() {
        super.awakeFromNib()
        

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        var deligateContainerViewScreen2: UIView

        // Configure the view for the selected state
    }
}
