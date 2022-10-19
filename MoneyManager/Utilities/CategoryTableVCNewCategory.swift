//
//  CategoryTableVCNewCategory.swift
//  MoneyManager
//
//  Created by Roman on 21.04.2021.
//

import UIKit

protocol protocolCategoryTableVCNewCategory {
  func textFieldNewCategoryClear()
}

class CategoryTableVCNewCategory: UITableViewCell {
  // MARK: - объявление аутлетов

  @IBOutlet var textFieldNewCategory: UITextField!
  @IBOutlet var buttonAddNewCategory: UIButton!


  // MARK: - переходы

  @IBAction func buttonAddNewCategoryAction(_ sender: Any) {
    if let value = textFieldNewCategory.text?.isEmpty, value == false {
      vcCategoryDelegate?.returnVCMainDelegate().addCategory(name: textFieldNewCategory.text!, icon: "")

      vcCategoryDelegate?.screen2ContainerAddNewCategory()

      textFieldNewCategoryClear()
      textFieldNewCategory.endEditing(true)
    } else {
      vcCategoryDelegate?.presentAlertErrorAddNewCategory()
    }
  }


  // MARK: - делегаты и переменные

  var vcCategoryDelegate: protocolVCCategory?


  override func awakeFromNib() {
    super.awakeFromNib()

    textFieldNewCategory.layer.cornerRadius = 10
    buttonAddNewCategory.layer.cornerRadius = 10
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}


extension CategoryTableVCNewCategory: protocolCategoryTableVCNewCategory {
  func textFieldNewCategoryClear() {
    textFieldNewCategory.text = ""
  }
}
