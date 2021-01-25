//
//  TableViewCellChangeCategoryScreen2Container.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 23.01.2021.
//

import UIKit
import SimpleCheckbox

protocol protocolScreen2Container_TableViewCellChangeCategoryDeligate {
//    func setTag(tag: Int)
//    func startCell()
}

class Screen2Container_TableViewCellChangeCategory: UITableViewCell {
    
    @IBOutlet var labelChangeCategory: UILabel!
    @IBOutlet var buttonDeleteItemObject: UIButton!
    @IBOutlet var checkBoxObject: Checkbox!
    
    var delegateScreen2Container: protocolScreen2ContainerDelegate?
    var specCellTag: Int = 0
    
    //анимация
    @objc func closeWindows() {
        delegateScreen2Container?.closeWindows(specCellTag)
        print("ClosePopup from ContainerCell")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

        // Configure the view for the selected state
    }
    
    
    @IBAction func buttonDeleteItem(_ sender: Any) {
        delegateScreen2Container?.buttonDeleteItemHandler(checkBoxObject.tag)
    }
    
    @objc func checkboxValueChanged(sender: Checkbox) {
        switch checkBoxObject.isChecked {
        case true:
            delegateScreen2Container?.checkBoxStatus(checkBoxObject.tag, true)
        case false:
            delegateScreen2Container?.checkBoxStatus(checkBoxObject.tag, false)
        }
    }
    
    func startCell() {
        checkBoxObject.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        labelChangeCategory.text = delegateScreen2Container?.giveScreen2ContainerMenuArray()[specCellTag].name
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeWindows))
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        checkBoxObject.tag = specCellTag
        checkBoxObject.checkmarkStyle = .tick
        checkBoxObject.borderLineWidth = 0
        checkBoxObject.borderStyle = .circle
        checkBoxObject.checkmarkSize = 1
        checkBoxObject.checkmarkColor = .white
    }
    
    func setTag(tag: Int) {
        specCellTag = tag
    }

}
