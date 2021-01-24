//
//  TableViewCellChangeCategoryScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 23.01.2021.
//

import UIKit
import SimpleCheckbox

protocol protocolDataFromContainer: class {
    func buttonDeleteItemHandler(_ tag: Int)
    func checkBoxStatus(_ tag: Int,_ type: Bool)
}

class Screen2Container_TableViewCellChangeCategory: UITableViewCell {
    
    @IBOutlet var labelChangeCategory: UILabel!
    @IBOutlet var buttonDeleteItemObject: UIButton!
    @IBOutlet var checkBoxObject: Checkbox!
    
    var deligateScreen2Container: protocolDataFromContainer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBoxObject.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

        // Configure the view for the selected state
    }
    
    
    @IBAction func buttonDeleteItem(_ sender: Any) {
        deligateScreen2Container?.buttonDeleteItemHandler(checkBoxObject.tag)
    }
    
    @objc func checkboxValueChanged(sender: Checkbox) {
        switch checkBoxObject.isChecked {
        case true:
            deligateScreen2Container?.checkBoxStatus(checkBoxObject.tag, true)
        case false:
            deligateScreen2Container?.checkBoxStatus(checkBoxObject.tag, false)
        }
    }

}
