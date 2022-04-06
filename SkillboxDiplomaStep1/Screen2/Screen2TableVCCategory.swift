//
//  Screen2TableViewCellCategoryOrDate.swift
//  Skillbox_diploma_step1
//
//  Created by Roman on 17.01.2021.
//

import UIKit

protocol protocolScreen2TableViewCellCategory {
}

class Screen2TableVCCategory: UITableViewCell {
  @IBOutlet var labelCategory: UILabel!
  @IBOutlet var labelSelectCategory: UILabel!
  @IBOutlet var buttonSelectCategory: UIButton!

  var delegateScreen2: protocolScreen2Delegate?
  var specCellTag: Int = 0

// Анимация
  @objc func changeCategoryOpenPopUpScreen2FromCellCategory(_ tag: Int) {
    delegateScreen2?.changeCategoryOpenPopUpScreen2(specCellTag)
    print("ChangeCategory from Screen2")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func startCell() {
    if delegateScreen2?.returnNewOperation().category.isEmpty == false {
      labelSelectCategory.text = delegateScreen2?.returnNewOperation().category
      labelSelectCategory.textColor = .black
    } else {
      labelSelectCategory.text = delegateScreen2?.returnScreen2MenuArray()[specCellTag].text
    }
    labelCategory.text = delegateScreen2?.returnScreen2MenuArray()[specCellTag].name
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

extension Screen2TableVCCategory: protocolScreen2TableViewCellCategory {
}
