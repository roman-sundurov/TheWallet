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

  var vcSettingDelegate: protocolVCSetting?
  var indexRow: Int = 0

// Анимация
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
    if vcSettingDelegate!.returnNewOperation().category.isEmpty == false {
      labelSelectCategory.text = vcSettingDelegate!.returnNewOperation().category
      labelSelectCategory.textColor = .black
    } else {
      labelSelectCategory.text = vcSettingDelegate!.returnScreen2MenuArray()[indexRow].text
    }
    labelCategory.text = vcSettingDelegate!.returnScreen2MenuArray()[indexRow].name
    let gesture = UITapGestureRecognizer(
      target: self,
      action: #selector(changeCategoryOpenPopUpScreen2FromCellCategory(_:))
    )
    self.isUserInteractionEnabled = true
    self.addGestureRecognizer(gesture)
  }
}
