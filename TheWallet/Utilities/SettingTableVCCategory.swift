//
//  SettingTableVCCategory.swift
//  MoneyManager
//
//  Created by Roman on 17.01.2021.
//

import UIKit

final class SettingTableVCCategory: UITableViewCell {
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelSelectCategory: UILabel!
    @IBOutlet var buttonSelectCategory: UIButton!

    var vcSettingDelegate: ProtocolVCSetting?
    var indexRow: Int = 0

    // Animations
    @objc func changeCategoryOpenPopUpScreen2FromCellCategory(_ tag: Int) {
        do {
            try vcSettingDelegate?.changeCategoryOpenPopUpScreen2(indexRow)
        } catch {
            vcSettingDelegate?.showAlert(message: "Error changeCategoryOpenPopUpScreen2FromCellCategory")
        }
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
        if let vcSettingDelegate = vcSettingDelegate {
            if let newCategory = vcSettingDelegate.returnNewOperation().category {
                do {
                    labelSelectCategory.text = try vcSettingDelegate.getUserData().categories[newCategory.description]?.name
                } catch {
                    labelSelectCategory.text = "Error data"
                    vcSettingDelegate.showAlert(message: "labelSelectCategory error")
                }
                labelSelectCategory.textColor = .black
            } else {
                print("Error: SettingTableVCCategory prepareCell newCategory")
            }
            labelSelectCategory.text = vcSettingDelegate.getSettingMenuArray()[indexRow].text
            labelCategory.text = vcSettingDelegate.getSettingMenuArray()[indexRow].name
        } else {
            print("Error: SettingTableVCCategory prepareCell vcSettingDelegate")
        }
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(changeCategoryOpenPopUpScreen2FromCellCategory(_:))
        )
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
}
