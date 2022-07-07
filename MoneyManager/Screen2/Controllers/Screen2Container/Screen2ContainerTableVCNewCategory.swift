//
//  Screen2ContainerTableVCNewCategory.swift
//  MoneyManager
//
//  Created by Roman on 21.04.2021.
//

import UIKit

protocol protocolScreen2ContainerTableVCNewCategory {
  func textFieldNewCategoryClear()
}

class Screen2ContainerTableVCNewCategory: UITableViewCell {
  // MARK: - объявление аутлетов

  @IBOutlet var textFieldNewCategory: UITextField!
  @IBOutlet var buttonAddNewCategory: UIButton!


  // MARK: - переходы

  @IBAction func buttonAddNewCategoryAction(_ sender: Any) {
    if let value = textFieldNewCategory.text?.isEmpty, value == false {
      Persistence.shared.addCategory(name: textFieldNewCategory.text!, icon: "")

      delegateScreen2Container?.screen2ContainerAddNewCategory()

      textFieldNewCategoryClear()
      textFieldNewCategory.endEditing(true)
    } else {
      delegateScreen2Container?.presentAlertErrorAddNewCategory()
    }
  }


  // MARK: - делегаты и переменные

  var delegateScreen2Container: protocolScreen2ContainerDelegate?


  override func awakeFromNib() {
    super.awakeFromNib()

    textFieldNewCategory.layer.cornerRadius = 10
    buttonAddNewCategory.layer.cornerRadius = 10
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}


extension Screen2ContainerTableVCNewCategory: protocolScreen2ContainerTableVCNewCategory {
  func textFieldNewCategoryClear() {
    textFieldNewCategory.text = ""
  }
}
