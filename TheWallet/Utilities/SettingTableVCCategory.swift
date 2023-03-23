//
//  SettingTableVCCategory.swift
//  MoneyManager
//
//  Created by Roman on 17.01.2021.
//

import UIKit

class SettingTableVCCategory: UITableViewCell {
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelSelectCategory: UILabel!
    @IBOutlet var buttonSelectCategory: UIButton!
    
    var vcSettingDelegate: ProtocolVCSetting?
    var indexRow: Int = 0
    
        // Animations
    @objc func changeCategoryOpenPopUpScreen2FromCellCategory(_ tag: Int) {
        vcSettingDelegate?.changeCategoryOpenPopUpScreen2(indexRow)
        print("ChangeCategory from Screen2")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareCell(indexRow: Int) {
        self.indexRow = indexRow
        if let newCategory = vcSettingDelegate!.returnNewOperation().category {
            labelSelectCategory.text = vcSettingDelegate?.getUserData().categories[newCategory.description]?.name
            labelSelectCategory.textColor = .black
        } else {
            labelSelectCategory.text = vcSettingDelegate!.getSettingMenuArray()[indexRow].text
        }
        labelCategory.text = vcSettingDelegate!.getSettingMenuArray()[indexRow].name
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(changeCategoryOpenPopUpScreen2FromCellCategory(_:))
        )
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
}
