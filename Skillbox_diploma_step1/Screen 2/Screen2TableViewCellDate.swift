//
//  Screen2TableViewCellDate.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 06.03.2021.
//

import UIKit

class Screen2TableViewCellDate: UITableViewCell {

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
        labelCategory.text = deligateScreen2?.getScreen2MenuArray()[specCellTag].name
        labelSelectCategory.text = deligateScreen2?.getScreen2MenuArray()[specCellTag].text
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeCategoryOpenPopUpFromScreen2(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    func setTag(tag: Int) {
        specCellTag = tag
    }
}
