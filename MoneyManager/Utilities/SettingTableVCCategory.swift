//
//  SettingTableVCCategory.swift
//  MoneyManager
//
//  Created by Roman on 17.01.2021.
//

import UIKit

protocol protocolSettingTableVCCategory {
}

class SettingTableVCCategory: UITableViewCell {
  @IBOutlet var labelCategory: UILabel!
  @IBOutlet var labelSelectCategory: UILabel!
  @IBOutlet var buttonSelectCategory: UIButton!

  var vcSettingDelegate: protocolVCSetting?
  var specCellTag: Int = 0

// Анимация
  @objc func changeCategoryOpenPopUpScreen2FromCellCategory(_ tag: Int) {
    vcSettingDelegate?.changeCategoryOpenPopUpScreen2(specCellTag)
    print("ChangeCategory from Screen2")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func startCell() {
    if vcSettingDelegate!.returnNewOperation().category.isEmpty == false {
      labelSelectCategory.text = vcSettingDelegate!.returnNewOperation().category
      labelSelectCategory.textColor = .black
    } else {
      labelSelectCategory.text = vcSettingDelegate!.returnScreen2MenuArray()[specCellTag].text
    }
    labelCategory.text = vcSettingDelegate!.returnScreen2MenuArray()[specCellTag].name
    let gesture = UITapGestureRecognizer(
      target: self,
      action: #selector(changeCategoryOpenPopUpScreen2FromCellCategory(_:))
    )
    self.isUserInteractionEnabled = true
    self.addGestureRecognizer(gesture)
  }

  func setTag(tag: Int) {
    specCellTag = tag
  }
}

extension SettingTableVCCategory: protocolSettingTableVCCategory {
}
