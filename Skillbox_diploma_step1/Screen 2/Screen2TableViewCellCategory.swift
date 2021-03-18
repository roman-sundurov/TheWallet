//
//  Screen2TableViewCellCategoryOrDate.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 17.01.2021.
//

import UIKit

protocol protocolScreen2TableViewCellCategory {
}

class Screen2TableViewCellCategory: UITableViewCell {
    
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelSelectCategory: UILabel!
    @IBOutlet var buttonSelectCategory: UIButton!
    
    var deligateScreen2: protocolScreen2Delegate?
    var specCellTag: Int = 0

//Анимация
    @objc func changeCategoryOpenPopUpFromScreen2(_ tag: Int) {
        deligateScreen2?.returnDelegateScreen2TableViewCellNote().tapOutsideTextViewEditToHide()
        deligateScreen2?.changeCategoryOpenPopUp(specCellTag)
        print("ChangeCategory from Screen2")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func startCell() {
        if deligateScreen2?.returnNewOperation().category != "" {
            labelSelectCategory.text = deligateScreen2?.returnNewOperation().category
        }
        else{
            labelSelectCategory.text = deligateScreen2?.getScreen2MenuArray()[specCellTag].text
        }
        labelCategory.text = deligateScreen2?.getScreen2MenuArray()[specCellTag].name
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeCategoryOpenPopUpFromScreen2(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    func setTag(tag: Int) {
        specCellTag = tag
    }
}

extension Screen2TableViewCellCategory: protocolScreen2TableViewCellCategory{

}
